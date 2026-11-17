#!/usr/bin/env bash
# Lists GitHub Actions runs that failed in the last $HOURS hours across every
# repository of $ORG and sends one ntfy message about them.
#
# A workflow on a branch that failed and then passed on a later run is not listed,
# only counted. Nothing is sent when nothing is still failing, unless ALWAYS_NOTIFY=true.
#
# Env: ORG, HOURS (24), NTFY_TOPIC (required unless DRY_RUN=true),
#      NTFY_SERVER (https://ntfy.sh), NTFY_TOKEN (for a protected topic),
#      ALWAYS_NOTIFY (false), DRY_RUN (false: print the message instead of sending it),
#      REPOS (space-separated names, instead of every repository of ORG),
#      GH_TOKEN (read by gh).
set -euo pipefail

ORG="${ORG:?set ORG}"
HOURS="${HOURS:-24}"
NTFY_SERVER="${NTFY_SERVER:-https://ntfy.sh}"
ALWAYS_NOTIFY="${ALWAYS_NOTIFY:-false}"
DRY_RUN="${DRY_RUN:-false}"

since="$(date -u -d "-${HOURS} hours" +%Y-%m-%dT%H:%M:%SZ)"

repos="${REPOS:-$(gh api --paginate "orgs/${ORG}/repos?per_page=100&type=all" \
  --jq '.[] | select(.archived | not) | select(.disabled | not) | .name' | sort)}"

failing=""   # one line per workflow+branch whose latest run failed
recovered=0  # failed in the window, but a later run passed
checked=0

for repo in $repos; do
  # Completed runs created in the window, newest first.
  runs="$(gh api --paginate \
    "repos/${ORG}/${repo}/actions/runs?per_page=100&status=completed&created=>=${since}" \
    --jq '.workflow_runs[] | [.workflow_id, .head_branch, .conclusion, .name, .html_url, .event] | @tsv' \
    2>/dev/null)" || { echo "::warning::could not read runs of ${ORG}/${repo}"; continue; }
  checked=$((checked + 1))
  [ -n "$runs" ] || continue

  # Keep the newest run per workflow and branch; skipped and cancelled runs don't count.
  while IFS=$'\t' read -r _ branch conclusion name url event; do
    case "$conclusion" in
      failure|timed_out|startup_failure)
        failing+="- **${repo}** · ${name} on \`${branch}\` (${event}): [run](${url})"$'\n' ;;
    esac
  done < <(printf '%s\n' "$runs" \
    | awk -F'\t' '$3 != "skipped" && $3 != "cancelled" && !seen[$1 FS $2]++')

  recovered=$((recovered + $(printf '%s\n' "$runs" | awk -F'\t' '
    $3 == "skipped" || $3 == "cancelled" { next }
    { key = $1 FS $2 }
    !(key in latest) { latest[key] = $3; next }
    ($3 == "failure" || $3 == "timed_out" || $3 == "startup_failure") && latest[key] == "success" { fixed[key] = 1 }
    END { n = 0; for (k in fixed) n++; print n }')))
done

count="$(printf '%s' "$failing" | grep -c '^- ' || true)"
echo "Checked ${checked} repositories since ${since}: ${count} failing, ${recovered} recovered."

if [ "$count" -eq 0 ] && [ "$ALWAYS_NOTIFY" != "true" ]; then
  exit 0
fi

if [ "$count" -eq 0 ]; then
  title="${ORG}: no failed workflows"
  body="All workflows in ${checked} repositories passed in the last ${HOURS} hours."
  priority=low; tags=white_check_mark
else
  title="${ORG}: ${count} failing workflow$([ "$count" -eq 1 ] || echo s)"
  body="$failing"
  priority=default; tags=x
fi
if [ "$recovered" -gt 0 ]; then
  body+=$'\n'"${recovered} more failed but passed on a later run."
fi
# ntfy keeps messages up to 4,096 bytes.
if [ "${#body}" -gt 3900 ]; then
  body="${body:0:3900}"$'\n'"…and more, see the Actions tab of each repository."
fi

if [ "$DRY_RUN" = "true" ]; then
  printf '%s\n\n%s\n' "$title" "$body"
  exit 0
fi

: "${NTFY_TOPIC:?set the NTFY_TOPIC secret}"
auth=()
[ -z "${NTFY_TOKEN:-}" ] || auth=(-H "Authorization: Bearer ${NTFY_TOKEN}")
curl -fsS --retry 3 -o /dev/null "${auth[@]}" \
  -H "Title: ${title}" \
  -H "Priority: ${priority}" \
  -H "Tags: ${tags}" \
  -H "Markdown: yes" \
  -H "Click: https://github.com/${ORG}" \
  --data-binary "$body" \
  "${NTFY_SERVER%/}/${NTFY_TOPIC}"
echo "Sent to ntfy."
