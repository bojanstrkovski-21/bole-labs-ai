---
name: feedback_test_gui_under_xvfb
description: "Test GUI/QML changes in a scratch copy under Xvfb driven by the app IPC, never on the live display or with models that write real settings files"
metadata:
  type: feedback
---

Exercise GUI changes in a scratch copy under `Xvfb :NN` (`DISPLAY=:NN`), drive it with the app's own IPC (`quickshell ipc --path <copy>/shell.qml call <target> <fn>`) and a temporary `console.log`. `QT_QPA_PLATFORM=offscreen` has no `PanelWindow` backend for Quickshell. Never instantiate a model that has a real save path in a test.

**Why:** a scratch test that instantiated `ControlCenterModel` ran its real `saveSettings()` and overwrote `panelOpacityPercent` in the user's live `~/.cache/dwm-titus/controlcenter-settings.json` (restored at once, avoidable).

**How to apply:** copy the config to scratch, run under Xvfb, stop test instances by their own PID, and afterwards confirm the real shell is alive (see [[feedback_test_cleanup_must_not_leave_live_shell_dead]]).
