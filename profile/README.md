<div align="center">

# selfhostit

**Small apps you run on your own hardware.**<br>
Your data stays home, on a NAS, a Raspberry Pi or a cheap server. Each app is one small
container, installs on your phone from the browser, and needs no account on anyone's cloud.

[![Start an app with plasto](https://img.shields.io/badge/Start_an_app_with_plasto-2ea44f?style=for-the-badge&logo=github)](https://github.com/selfhostit/plasto/generate)
[![Buy me a coffee](https://img.shields.io/badge/Buy_me_a_coffee-ffdd00?style=for-the-badge&logo=buymeacoffee&logoColor=black)](https://buymeacoffee.com/kalfasyan)

</div>

## Apps

| | | |
|:---:|---|---|
| <img src="https://raw.githubusercontent.com/selfhostit/splitwiz/main/docs/logo.png" width="56" alt=""> | **[Splitwiz](https://github.com/selfhostit/splitwiz)** | Split shared costs with your partner or roommate. A self-hosted Splitwise for two, with CSV import. |
| <img src="https://raw.githubusercontent.com/selfhostit/should-we/main/docs/assets/logo.png" width="56" alt=""> | **[should-we](https://github.com/selfhostit/should-we)** | Pick one option together. Everyone weighs what matters to them and rates each option, and you get one ranking. |
| <img src="https://raw.githubusercontent.com/selfhostit/flowy/main/web/public/icons/icon.svg" width="56" alt=""> | **[Flowy](https://github.com/selfhostit/flowy)** | A private period and cycle tracker: predictions, a day log, insights and reminders, with Mochi the cat. |
| <img src="https://raw.githubusercontent.com/selfhostit/troye/main/web/public/icons/icon.svg" width="56" alt=""> | **[Troye](https://github.com/selfhostit/troye)** | A private calorie and weight tracker. Food photos are read by a vision model on your own GPU. *Work in progress.* |

## Build your own: plasto

<img align="right" src="https://raw.githubusercontent.com/selfhostit/plasto/main/web/public/icons/icon.svg" width="88" alt="">

**[plasto](https://github.com/selfhostit/plasto)** is the template the apps grow from. It takes
an idea to an app on your phone, running in one small container, without rebuilding the
same parts every time. You add your data model and screens; plasto brings the rest:

- Sign-in, users and roles, with a first-run setup screen
- A SQLite database with an admin UI and realtime updates ([PocketBase](https://pocketbase.io))
- A phone-installable web app in [Svelte 5](https://svelte.dev) and [Tailwind](https://tailwindcss.com), with dark mode
- Push notifications from your own server, with no third-party service
- Scheduled jobs that catch up after downtime, and nightly backups
- Python workers for the heavy lifting (ML, scraping, LLMs), on the same machine or another
- A one-command deploy, with images for amd64, arm64 and armv7 on
  [ghcr.io/selfhostit](https://github.com/orgs/selfhostit/packages)

```sh
# On GitHub: "Use this template", then
scripts/rename.sh      # plasto becomes your app's name
make setup             # install dependencies
make dev               # backend on :8090, web app on :5173
```

<div align="center">

**Simple. Intuitive. Self-hosted. Fast.**

</div>
