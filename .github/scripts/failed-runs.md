# Daily failed-runs alert

`.github/workflows/failed-runs.yml` runs every day at 06:17 UTC. It reads the GitHub
Actions runs of every repository in the organization from the last 24 hours and sends
one [ntfy](https://ntfy.sh) message that lists each workflow whose latest run on a
branch failed, with a link to the run. A workflow that failed and then passed on a
later run is only counted. When nothing is failing, it sends nothing.

It costs nothing: Actions minutes are free for public repositories, and ntfy.sh
topics are free.

## Setup

1. Pick a long, random topic name, for example the output of
   `echo selfhostit-ci-$(openssl rand -hex 8)`. Anyone who knows the name can read
   the topic on ntfy.sh, so treat it like a password.
2. In this repository, under **Settings → Secrets and variables → Actions → New
   repository secret**, add `NTFY_TOPIC` with that name.
3. In the ntfy app (Android, iOS or https://ntfy.sh/app), tap **+**, enter the same
   topic name, keep the server `ntfy.sh`, and subscribe.
4. Under **Actions → Failed runs → Run workflow**, run it once. With "Send a message
   even when nothing failed" ticked, you get a message either way.

Optional:

- `ACTIONS_READ_TOKEN` secret: only needed for private repositories. Create a
  fine-grained token with the organization as owner, all repositories, and
  **Actions: read** (plus the default Metadata: read).
- `NTFY_TOKEN` secret and `NTFY_SERVER` variable: for your own ntfy server or a
  topic that needs a login.

GitHub turns off scheduled workflows in a public repository after 60 days without
a commit and emails a warning first. If that happens, turn it back on under
**Actions → Failed runs → Enable workflow**.

## Try it locally

```sh
ORG=selfhostit DRY_RUN=true .github/scripts/failed-runs.sh
```
