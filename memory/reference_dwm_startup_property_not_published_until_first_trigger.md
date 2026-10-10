---
name: reference-dwm-startup-property-not-published-until-first-trigger
description: dwm root-window state properties (e.g. _DWM_GAPS) that are only ever published from an action handler read as missing/zero to Quickshell until that action first fires
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-10T11:44:27.974Z
---

In `chadboki-qswm/dwm.c`, `updatelayoutprop()` (publishes `_DWM_GAPS`/
`_DWM_LAYOUT`/`_DWM_MFACT`/`_DWM_NMASTER`/`_DWM_BORDERPX` to the root
window for Quickshell to read) was only ever called from inside action
handlers — `updatecurrentdesktop()` (fired on a tag switch) and the
layout/mfact/nmaster/borderpx setters. `setup()` never called it, so on a
fresh login these properties simply didn't exist on the root window yet.

Symptom this caused: the floating panel style (`chadboki-qswm`'s
`DwmPanel.qml`) rendered non-floating on every fresh login/reboot/relogin,
but fixed itself the instant you switched to any other tag and back.
Root cause: `LayoutModel.qml` read nothing for `gaps=` (property didn't
exist), defaulted `root.gaps` to 0, which set `Theme.gapPx = 0` →
`Theme.panelMargin = 0` → non-floating look — until the first tag switch
called `updatecurrentdesktop()` → `updatelayoutprop()` for the very first
time, publishing the real gap value.

Confirmed via a temporary `Quickshell.execDetached` file-logger (stdout is
redirected to `/dev/null` by `autostart.sh`, so plain `console.log` isn't
visible) showing `Theme.panelWindowHeight` oscillating between the wrong
and the right value — this ruled out a Quickshell/QML-side
`exclusiveZone`/`implicitHeight` reactivity bug (two earlier fix attempts
in that layer both failed) and pointed at the real upstream source.

**General lesson**: any dwm root-window property whose only producer is an
action handler, not `setup()` itself, will read as missing/default to an
external consumer (Quickshell, a status bar, etc.) until that action
fires once — "works after I touch X" during startup debugging is a strong
signal to check whether the relevant publish call is reachable from
`setup()`/`main()` at all, not just from the runtime action path.

Fix: call the publish function once in `setup()` (after the relevant
atoms are interned, before `grabkeys()`) so the real value exists before
any client/panel ever polls it. See `chadboki-qswm/dwm.c`'s `setup()`,
right before `grabkeys()`. Confirmed fixed and live-verified 2026-10-10
(logout/login, panel floats immediately, no tag switch needed).

**Deploy gotcha that made the fix look like it failed on the first try**:
editing `dwm.c` in this repo (`dwm-quickshell/chadboki-qswm/dwm.c`) is not
enough — `./rebuild` (the script the user actually runs) builds from the
separate live checkout at `~/.config/chadboki-qswm/dwm.c`, which is a
plain `cp -a` mirror with no automatic sync back from the repo. The
existing "3-copy sync" rule in this project's `CLAUDE.md` only covers
`quickshell-scripts/`/`quickshell-configs/` (QML/scripts) — `dwm.c`
itself needs its own explicit `cp` to the live checkout before any
rebuild, or the user will rebuild and reinstall the *old* binary and
report the fix as not working, even though the repo's own source is
correct. Always diff repo `dwm.c` against `~/.config/chadboki-qswm/dwm.c`
(or just `cp` it over) immediately after making any `dwm.c` edit, before
asking the user to rebuild.
