---
name: project-butterview
description: butterview — Zig 0.16 SDL3 image viewer; Arch PKGBUILD; GitHub remote; user pushes
metadata:
  type: project
---

butterview (`~/Projects/butterview`) is a small image viewer: one picture, a thumbnail strip, a status line. Zig 0.16, SDL3, SDL3_image, SDL3_ttf, libjpeg-turbo, libdbus. No GTK and no Qt.

The workspace root is a git repo on `main`. Remote `git@github.com:bojanstrkovski-21/butterview-arch.git`. The user commits and pushes. Do not run `push.sh` or contact the remote. Root holds `CLAUDE.md`, `memory/`, `install-scripts/`, `mise.toml` (Zig 0.16.0), `PKGBUILD`, and `ensure-zig.install`. Editable tree is `butterview-arch/` (no nested `.git`). `upstream/` is a read-only clone of `https://justaguy.dev/drew/butterview.git`. Do not edit `upstream/`.

Sources are `butterview-arch/src/main.zig`, `exif.zig`, `gif.zig`, `portal.zig`, `theme.zig`. Build with `bash install-scripts/zig_build.sh`. The snapshot started at upstream `4c247056f0cd8989975dd5e3683564993da614f7` (2026-11-06, "consistent readme footer"). On 2026-11-11 the ten review fixes in `to-do.txt` were applied in `butterview-arch/` only. ReleaseSafe build succeeded. Short drafts live in `drafts/issues/` (five files for one Forgejo issue), `drafts/pull-requests/`, and `drafts/discussions/`. The checkbox list is for `to-do.txt` only. Not sent upstream.

`makepkg -s` from the root builds a local Arch package into `build/` (`/build/` is gitignored). `ensure-zig.install` installs mise if missing and Zig 0.16.0 through mise only when it is not already installed. Do not use Arch `extra/zig` (0.17). Zig is not a runtime dependency. A launch with no real path opens the folder view. A real image path still opens that image. The desktop `Icon=butterview` matches the hicolor icons; a blank Quickshell icon needs a Quickshell reload after install. Latest local commit on 2026-11-11 is `6a5e2cb` ("builder completed"), matching recorded `origin/main`. License is GPL-3.0-or-later. Do not relicense.

Instructions are `CLAUDE.md`. The session log is `memory/PROJECT.md`. Grok's workspace note is `~/.grok/memory-v2/workspaces/butterview-388e1c07/topics/butterview.md`. Git and session rules stay in `~/.agents` (see [[global-working-agreement]]).
