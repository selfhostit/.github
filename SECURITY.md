# Security policy

This policy covers every repository in the selfhostit organization: the apps (Splitwiz,
should-we, Flowy, Troye, Shoppa, Calio), the plasto template, the installer in
[selfhostit/docs](https://github.com/selfhostit/docs) and the website. Each app repository
also has its own `SECURITY.md` with the same rules.

## Reporting a problem

Please don't open a public issue for a security problem. Report it privately, either with
**Report a vulnerability** on the repository's Security tab (for example
[Flowy's](https://github.com/selfhostit/flowy/security/advisories/new)), or by writing to
**kalfasyan@pm.me**, with:

- which app or script, and which version (the image tag, release or commit),
- what you found and how to reproduce it,
- what someone could do with it.

## What happens next

- **A reply within 7 days,** usually sooner, saying whether the problem is confirmed.
- **Critical problems,** such as reading or changing someone else's data or taking over the
  server, are fixed in a new release within 7 days of confirming them. Other problems are
  fixed in a release within 30 days. If a fix takes longer, you hear why.
- **Disclosure:** once the fix is released, a GitHub security advisory on the repository says
  what was wrong, which versions were affected and how to update, and a CVE is requested
  when the problem warrants one. You are credited, unless you'd rather not be named. Please
  keep the problem private until then.
- selfhostit is run by one person, so there is no bug bounty.

## Supported versions

Fixes go into a new release of the newest version of each app. Installs follow that app's
major version tag (`:1`, `:2` for should-we), so `selfhostit update` or `docker compose pull`
brings the fix; older releases are not patched. The installer is supported in its newest
release.

## How the apps are protected

[Security and privacy](https://github.com/selfhostit/docs/blob/main/security.md) describes
what protects an install, how sign-in and sessions work, how the code and images are built
and scanned, what needs sudo, what you are trusting and what is not done yet, with links to
the code.
