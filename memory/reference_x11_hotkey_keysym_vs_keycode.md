---
name: reference_x11_hotkey_keysym_vs_keycode
description: "X11 global-hotkey daemons must grab AND match by keycode, not keysym — matching by a live-resolved keysym silently breaks letter-triggered bindings under any non-Latin active layout"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-21T21:58:02.297Z
---

When building an X11 global-hotkey daemon (`XGrabKey`-based), grabs are
keycode-based and layout-independent — resolved once (e.g. via
`XKeysymToKeycode()`) at grab time. But if the keypress dispatch/match
logic re-resolves the incoming event's keycode into a keysym live (e.g.
`XLookupKeysym(ev, 0)`) and compares it against a keysym that was resolved
once at *config load* time (under whatever layout was active then, e.g.
"us"), the match silently fails the moment a different XKB layout becomes
active — because the same physical key now produces a different keysym
(e.g. Cyrillic instead of `XK_m` under a Macedonian layout). This breaks
every letter-triggered binding, not just one, and fails silently (no
crash, no log, the grab still exists) — easy to misdiagnose as an input
or a specific-binding bug rather than a systemic layout issue. Fix: store
each binding's `KeyCode` at grab time and match dispatch on `KeyCode`
directly, never re-derive or compare keysyms after the initial grab
resolution. Found and fixed in `chadwm-boki/hotkeyd.c` (the
[[project_dwm-quickshell]] project) — see that project's `memory/
PROJECT.md` Session 15 entry for the full trail. Testing this class of
bug specifically requires layout-switching, not just single-layout
testing — see [[reference_xdotool_raw_keycode_injection]] for how to
faithfully test it.
