---
name: reference-quickshell-linux-only-no-windows
description: "Quickshell (the Qt/QML shell toolkit) has no Windows port — any cross-platform (Linux+Windows) tool requirement rules it out entirely, not just extra work"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-12T21:42:57.669Z
---

Quickshell is Linux-only (X11/Wayland); there is no Windows build. If a
feature needs to run on both Linux and Windows (e.g. a desktop tool used
both at home on Linux and at work on Windows), building it as a Quickshell
panel/plugin is not an option at all, regardless of how portable the QML
logic itself might otherwise be — this is a hard platform wall, not a
porting-effort tradeoff.

**How to apply**: when a cross-platform requirement surfaces for something
that would otherwise be a natural Quickshell feature, stop recommending a
Quickshell-based build and scope it as a separate standalone app instead
(e.g. Go+Wails, Rust+Tauri — a single compiled binary with no runtime to
install, which also matters if the Windows target is a locked-down work
machine with no admin rights for a Python/Node runtime).
