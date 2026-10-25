---
name: reference_x11_dock_window_needs_input_mask
description: "An X11 dock/panel window anchored to both edges spans the full width and silently eats clicks even when visually hidden — set an input mask (Quickshell: mask: Region { item: ... })"
metadata:
  node_type: memory
  type: reference
---

An X11 dock/panel window anchored to both cross-axis edges spans the full screen width. With `aboveWindows: true` and no input mask it silently swallows every click along its strip, even when autohidden or visually transparent. Symptom seen: apps' bottom-edge UI (Apply buttons, a browser's bottom-left profile menu) looked "frozen".

Fix in Quickshell: `mask: Region { item: hotzone }`, where `hotzone` is the visible card when shown, a ~2px edge strip when autohidden, and zero-size when suppressed (fullscreen).

Found in dwm-quickshell Session 43 (2026-10-19). Fading opacity alone does not stop input capture.
