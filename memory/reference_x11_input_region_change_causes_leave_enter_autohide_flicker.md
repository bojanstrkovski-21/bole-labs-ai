---
name: reference_x11_input_region_change_causes_leave_enter_autohide_flicker
description: "Changing a window's input mask under the pointer makes X send Leave+Enter, so hover-driven autohide that also resizes its mask flickers — add hide hysteresis"
metadata:
  node_type: memory
  type: reference
---

An auto-hiding dock that reveals on hover over a thin edge strip and then ENLARGES its window input mask (Quickshell `mask: Region`) gets a Leave and an Enter from the X server the moment the mask changes under a stationary pointer. Logged on a live session: hover true, false, true, false within ~100 ms of every reveal; autohide that follows hover directly showed and hid the dock several times (visible flicker) before settling.

Fix: instant show, delayed hide. Keep the raw `hovered` and derive a held flag: set it true immediately on hover, clear it only after a ~350 ms timer started when hover goes false. The blips are absorbed and a reveal is one clean slide. Same trick Omarchy's dock uses (a hide timer).

Found in dwm-quickshell Session 45 (2026-10-23).
