---
name: feedback_test_gui_under_xvfb
description: "Test GUI/QML changes in a scratch copy under Xvfb driven by the app IPC, never on the live display or with models that write real settings files"
metadata:
  type: feedback
---

Exercise GUI changes in a scratch copy under `Xvfb :NN` (`DISPLAY=:NN`), drive it with the app's own IPC (`quickshell ipc --path <copy>/shell.qml call <target> <fn>`) and a temporary `console.log`. `QT_QPA_PLATFORM=offscreen` has no `PanelWindow` backend for Quickshell. Never instantiate a model that has a real save path in a test.

**Why:** a scratch test that instantiated `ControlCenterModel` ran its real `saveSettings()` and overwrote `panelOpacityPercent` in the user's live `~/.cache/dwm-titus/controlcenter-settings.json` (restored at once, avoidable).

**How to apply:** copy the config to scratch, run under Xvfb, stop test instances by their own PID, and afterwards confirm the real shell is alive (see [[feedback_test_cleanup_must_not_leave_live_shell_dead]]).

**Keyboard needs a window manager:** on a bare Xvfb the keys (xdotool key / type) never reach a Quickshell popup because nothing hands over focus. Build the project's WM from the repo into the scratchpad (`cp` the sources, `cp config.def.h config.h`, `make dwm`; nothing built in the repo) and run it on the same display; then real right-clicks on the root window and key presses work. Isolate the test shell with `HOME`, `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_CACHE_HOME` pointing into the scratchpad (its settings JSON then lands there, not in the user's). Never trigger a menu action that signals processes by NAME (`pkill -x chadboki-qswm`): it would hit the user's live session.

**Cleanup and deploy pitfalls (Session 52):** (1) killing the test Quickshell/WM/Xvfb by PID is not enough: its watcher children (`nmcli monitor`, `playerctl --follow`, `inotifywait -m`, `xprop -spy`, shell scripts with pipelines) survive as orphans, dozens per session. Stop them all by finding every process whose `/proc/<pid>/environ` has the test `DISPLAY=:NN` (never by name or `pkill -f`, which can hit the live session or your own command line). (2) After `. ./env.sh` in a command, `~` and `$HOME` are the TEST home for the rest of that command: a `cp ... ~/.config/...` there silently lands in the scratch tree. Deploy in a separate command with absolute paths. (3) A live Quickshell can die while you test beside it ("X11 connection broke"); check `pgrep` for it after every test round and restart it with the project's own restart action.
