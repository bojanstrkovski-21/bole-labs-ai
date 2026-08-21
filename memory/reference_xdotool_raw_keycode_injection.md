---
name: reference_xdotool_raw_keycode_injection
description: "xdotool key <letter> is unreliable for testing a layout-dependent X11 keybind when the active layout lacks that letter's keysym — use raw keycode down/up injection instead"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-21T21:58:13.124Z
---

`xdotool key <letter>` (e.g. `xdotool key alt+m`) resolves the letter to a
keysym and, if the currently active XKB layout has no keycode mapped to
that keysym (e.g. testing a Latin-letter keybind while a Cyrillic layout
is active), xdotool falls back to temporarily remapping an *unused*
keycode to that keysym, sending the event, then unmapping it. That
synthetic event lands on a different keycode than whatever a real
`XGrabKey`-based grab is actually listening on, so it can look like a
keybind is broken (or, worse, look like it works when the real bug is
elsewhere) purely due to xdotool's own injection mechanics — not a
faithful simulation of a real physical keypress. To faithfully test a
layout-dependent keybind, inject the raw keycode directly instead:
1. find the physical key's keycode under a known layout, e.g.
   `xmodmap -pk 2>&1 | awk '$2 ~ /0x006d/'` for "m" under "us" (58 here),
2. `xdotool keydown alt; xdotool keydown 58; xdotool keyup 58; xdotool
   keyup alt`.
Found while debugging a real hotkeyd bug in the [[project_dwm-quickshell]]
project — see [[reference_x11_hotkey_keysym_vs_keycode]] for the bug this
technique was needed to actually verify (the first fix attempt looked
broken purely because of this xdotool limitation, not the real fix).
