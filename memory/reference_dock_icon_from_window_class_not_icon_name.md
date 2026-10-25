---
name: reference_dock_icon_from_window_class_not_icon_name
description: "A dock that draws an icon from the window class shows a blank tile for apps whose class is not an icon name (web apps with absolute Icon= paths) — take the icon from the .desktop entry"
metadata:
  node_type: memory
  type: reference
---

Looking up `iconPath(windowClass.toLowerCase())` only works when the class equals an icon-theme name. Web-app launchers (e.g. `Claude-AI.desktop` with `Icon=/abs/path/Claude-AI.png`) have a class like `claude-ai`, so the tile is blank. Resolve the pin's `.desktop` entry first and use its `Icon=` (absolute paths work), falling back to the class for running apps with no entry.

Also: an app grid that shares another model's app list must trigger that model's rescan on open, or it stays stale until the hourly timer (grid showed new apps ~2 min late). Found in dwm-quickshell Session 45.
