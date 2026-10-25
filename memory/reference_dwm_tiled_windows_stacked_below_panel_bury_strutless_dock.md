---
name: reference_dwm_tiled_windows_stacked_below_panel_bury_strutless_dock
description: "dwm restack() places tiled clients directly below the panel window, so a strut-less dock that sits lower in the stack ends up behind them"
metadata:
  node_type: memory
  type: reference
---

dwm's `restack()` does `stack_mode = Below, sibling = m->barwin` for tiled clients. With an external panel as `barwin`, every tiled window lands just under the panel. A second dock-type window without a strut (a Quickshell dock, `exclusiveZone: 0`) is not `barwin`; if the panel is raised past it (every Quickshell reload re-creates and re-raises the panel) the windows end up between panel and dock, and the dock slides in invisibly behind them. `aboveWindows: true` does not help: dwm only re-raises Clients (`raisealwaysontop`), not adopted bars.

Fix in `restack()`: after the tiled/floating loops, `XRaiseWindow` every adopted ExtBar that is not `m->barwin`. Reproduce with `xdotool windowraise <panel>` then focus a tiled window; check with `xwininfo -root -tree` (top-to-bottom order) or a pixel probe over a white xterm.

Found in dwm-quickshell Session 45 (2026-10-23).
