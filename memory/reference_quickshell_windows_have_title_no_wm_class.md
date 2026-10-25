---
name: reference_quickshell_windows_have_title_no_wm_class
description: "Quickshell PanelWindow/FloatingWindow expose _NET_WM_NAME but no WM_CLASS (popups have neither) — a window picker or rule matcher must accept title-only windows"
metadata:
  node_type: memory
  type: reference
---

On X11, Quickshell's own windows (the panel and dock are `_NET_WM_WINDOW_TYPE_DOCK`, Control Center is a FloatingWindow) carry `_NET_WM_NAME` (panel and dock both literally "quickshell", Control Center "dwm control center") but no `WM_CLASS` at all — `xprop` prints `WM_CLASS:  not found.`. PopupWindow-based popups are override-redirect with neither class nor title. A click-to-pick tool or window-rule matcher that requires `WM_CLASS` silently rejects every Quickshell window; it must fall back to title-only. Rules for these have to match by title, and the panel and dock share one title, so a title rule hits both.

Related test gotcha: Quickshell's IPC socket path is capped at ~108 chars, so a long `XDG_RUNTIME_DIR` (e.g. a deep scratchpad path) makes `quickshell ipc` fail with "Failed to start IPC server"; use a short dir like `/tmp/<user>/qr`.

Found in dwm-quickshell Session 44 (2026-10-19).
