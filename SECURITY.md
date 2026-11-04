# Security policy

This policy covers every repository in the selfhostit organization: the apps (Splitwiz,
should-we, Flowy, Troye), the plasto template, the installer in
[selfhostit/docs](https://github.com/selfhostit/docs) and the website.

## Reporting a problem

Please don't open a public issue for a security problem. Write to **kalfasyan@pm.me** with:

- which app or script, and which version (the image tag or commit),
- what you found and how to reproduce it,
- what someone could do with it.

You'll get a reply within a week, usually sooner. A fix ships as a new image and installer
on `main`, and the report is credited in the pull request unless you'd rather not be named.
selfhostit is run by one person, so there is no bug bounty.

## Supported versions

Only the latest version is supported: the `latest` image (`:2` for should-we) and the
installer on `main`. Update with `selfhostit update all` or by running the installer again.

## How the apps are protected

[Security and privacy](https://github.com/selfhostit/docs/blob/main/security.md) describes
what protects an install, how the images are built, what you are trusting and what is not
done yet, with links to the code.
