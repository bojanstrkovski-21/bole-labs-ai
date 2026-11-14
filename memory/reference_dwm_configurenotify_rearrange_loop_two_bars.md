---
name: reference_dwm_configurenotify_rearrange_loop_two_bars
description: "dwm with a bar window on each of two monitors: re-arranging on every ConfigureNotify loops forever; skip when geometry is unchanged and measure with xev + CPU"
metadata:
  type: reference
---

Handling a bar window's ConfigureNotify by calling arrange() restacks, which sends the next ConfigureNotify: an infinite loop that freezes dwm (dwm-quickshell Session 49). Skip the re-arrange when the geometry did not change. Measure with `xev -id <win> -event structure` plus the dwm CPU use, not by reading code.
