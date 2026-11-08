---
name: project-boki-webapps
description: Boki-WebApps — Go GTK 4 web-app manager in ~/Projects/boki-webapps; theme CSS and icons are different directories
metadata:
  type: project
---

Boki-WebApps (`~/Projects/boki-webapps`, module `boki-webapps`, app id `com.boki.WebApps`) turns a site into a `WebApp-*.desktop` launcher and opens it in an installed browser. Go, plain GTK 4 via gotk4. No libadwaita, no WebKit, no in-app back/forward bar, no system-wide install. The repo is MIT (`LICENSE`). webapp-manager was the layout reference and stays GPL; its source is not in this tree.

Theme CSS is only `~/.config/boki-webapps/theme.css`. That directory belongs to the theme changer. Icons, including pictures the user drops in, are `~/.local/share/boki-webapps/icons/`. Do not edit `~/.config/chadboki-qswm/quickshell-scripts/dwm-quickshell-theme` from this project.

Browsers come from desktop files, not a hardcoded list. Firefox can show a navbar. Chromium-family, Brave Origin included, uses `--app`. `~/.local/bin/brave-basic` calls a missing `/usr/bin/brave`; the installed browser is `brave-origin`. Leave `WebApp-Youtube6921.desktop` alone unless the user names it. cgo `free` warnings are from gotk4, not this app.

Remote is `git@github.com:bojanstrkovski-21/boki-webapps.git`. `push.sh` and `set-git-cred.sh` are the filled-in `~/.agents` scripts. Git and session rules stay in `~/.agents` (see [[global-working-agreement]] and [[feedback-codeberg-pushes]]). Do not copy them into this file.

Project instructions are `CLAUDE.md`. The session log is `memory/PROJECT.md`. When the user says "end session" or "end-session", write that log and sync `~/.agents/memory/` without asking, then report what was written (`~/.agents/commands/end-session.md` steps 4 and 6). A session rooted at `~/Projects/yay` must not change that repo while working on this app.
