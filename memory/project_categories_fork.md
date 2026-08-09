---
name: project-categories-fork
description: "This repo is bojanstrkovski-21's fork of rofi with a custom drun \"categories\" feature, periodically synced from upstream davatorium/rofi"
metadata: 
  node_type: memory
  type: project
  originSessionId: a0aeda18-9c42-4589-a5c3-bd8633198a3b
  modified: 2026-07-28T20:14:51.602Z
---

This is a personal fork of rofi (upstream: davatorium/rofi) that adds a custom
"categories" feature: separate drun modes per app category (accessories, dev,
graphics, multimedia, internet, office, system, settings, all), with
Alt+Shift+1-9 keybinds to switch between them and dedicated themes
(`everforest-categories.rasi`, `ohmyarchboki-dark-categories.rasi`,
`ohmyarchboki-everforest-categories.rasi`).

Key files:
- `source/modes/drun-categories.c` / `include/modes/drun-categories.h` — the feature itself
- Registered in `include/modes/modes.h` and `source/rofi.c` (`rofi_collectmodes_add` calls)
- Keybinds in `source/keyb.c`
- Packaged via `Build-arch/PKGBUILD` (pkgname `rofi-categories`), built from git source
  on the `next` branch (no `pkgver()` function — version is static, VCS-pulled at build time)

**Why:** user maintains this fork long-term and periodically merges
`davatorium:next` into their own `next` branch via GitHub UI, then wants to
verify the categories feature wasn't broken/conflicted before continuing work.

**How to apply:** After a user says they just synced with upstream, check for
merge conflicts (`<<<<<<<` markers), diff the merge-base vs upstream tip on
files categories touches (`settings.h`, `keyb.c`, `rofi.c`, `modes.h`,
`xrmoptions.c`), confirm `drun-categories.c` still registered, and do a test
build (`ninja -C build`) to confirm it compiles. See also [[feedback-pkgbuild-pkgrel]].
