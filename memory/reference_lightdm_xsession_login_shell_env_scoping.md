---
name: reference-lightdm-xsession-login-shell-env-scoping
description: "A custom WM's own autostart hook runs too late to scope session-wide env vars for apps the WM later spawns -- LightDM's Xsession wrapper sources .bashrc via a login shell before the WM even starts"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-06T19:55:16.646Z
---

`/etc/lightdm/Xsession` (and equivalent wrappers on other display managers)
re-execs itself as a shell login session before running a `.desktop`
session's `Exec=` target, e.g. `[ -z "$BASH" ] && exec $SHELL --login $0
"$@"`. A bash login shell sources `/etc/profile` -> `~/.bash_profile` ->
`~/.bashrc` (if the former sources the latter) as part of that re-exec,
*before* the actual window manager/session binary ever runs.

This has two consequences:

1. Any export in `~/.bashrc`/`~/.profile` silently applies to the whole
   graphical session, not just interactive terminals -- a stray
   `export SOME_VAR=...` written for shell convenience can leak into every
   GUI app the session later launches.
2. If a custom WM/session binary is `exec`'d directly from the `.desktop`
   file's `Exec=` (no wrapper script in between), its own post-launch
   autostart hook (anything the WM itself forks as a *child* once it's
   already running) cannot scope environment variables for apps the WM
   later spawns -- a forked child's `export`s never propagate back to the
   parent process's environment, so by the time the autostart hook runs,
   the WM's own env is already fixed. Env vars meant to reach every
   spawned app must be set *before* the WM process starts, e.g. in a small
   wrapper script that exports them then `exec`s the real binary, with the
   `.desktop` file's `Exec=` pointed at that wrapper instead of the binary
   directly.

[[reference_qt_custom_palette_needs_fusion_style]]
