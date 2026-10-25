---
name: reference_inotifywait_monitor_debounce_in_consumer
description: "Watching dirs for a rescan: run one long-lived `inotifywait -m` and debounce in the consumer; per-event inotifywait relaunch loses events, and a package install fires dozens"
metadata:
  node_type: memory
  type: reference
---

For "rescan when files appear/disappear" (e.g. .desktop files after a pacman install): run a single `inotifywait -m -q -r -e create -e delete -e moved_to -e moved_from -e close_write --format changed DIRS` that prints a line per event, and debounce on the reading side (a QML Timer restarted per line, ~1.5s). Relaunching inotifywait per event loses events in the gap; one install touches dozens of files. Pair it with a per-file cache keyed by path+mtime+size so the repeated rescans are cheap (330 .desktop files: 1.6s cold, 0.03s warm). Fall back to a cksum-of-`find -printf` poll when inotify-tools is missing. In shell tests the watcher helper `exec`s inotifywait, so kill the child first (`pkill -x -P`), then the wrapper subshell, or it is orphaned.

Found in dwm-quickshell Session 45 (2026-10-24).
