---
name: reference_screenshot_shows_drawn_not_panel_displayed
description: "A screenshot shows what was drawn, not what a physical panel displays; read the monitor EDID and test with colour swatches first"
metadata:
  type: reference
---

A screenshot or X capture is the framebuffer, never the panel. dwm-quickshell Session 49: the laptop panel (EDID: 6 bits per channel, blue primary y=0.14) showed dark navy as grey while screenshots were identical to the external monitor. Read bits per channel and primaries with `edid-decode` and test with plain swatches before arguing with the user. On Arch `v4l-utils` (extra) ships `/usr/bin/edid-decode`; it takes the hex text from `xrandr --prop` directly, no `xxd`. See [[feedback_accepts_controlled_live_tests]].
