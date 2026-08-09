---
name: reference-doom-theme-loading
description: "Where the user's Doom Emacs config lives and how it loads/updates the archboki-emacs-themes package"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 00d4e5d4-4210-415c-ae00-f8b9baac1f08
---

User's Doom config: `~/.config/doom/` (`config.el` sets `doom-theme`;
`packages.el` declares `(package! archboki-themes :recipe (:host
github :repo "bojanstrkovski-21/archboki-emacs-themes"))`).

Doom installs packages via straight.el into a **separate clone**,
not the user's dev directory: for this package,
`~/.config/emacs/.local/straight/repos/archboki-emacs-themes`. Edits
in `~/Projects/archboki-emacs-themes` (the dev repo, see
[[project-archboki-themes]]) are invisible to the running Emacs until
pushed to GitHub and pulled into that straight clone.

Update commands: `doom sync -u` (or `doom upgrade`) pulls + rebuilds
**every** package. To update only this one package without touching
others, run `M-x straight-pull-package` inside Emacs and pick
`archboki-emacs-themes` — plain `doom sync` alone never pulls new
commits, it only regenerates autoloads/init from whatever's already
on disk.

For fast local theme-development iteration without any push/pull
round-trip, the user was offered (not yet set up as of 2026-07-05) a
symlink from the straight repo path to the dev directory instead.
