---
name: feedback_test_cleanup_must_not_leave_live_shell_dead
description: "After Xvfb test runs and live QML deploys, confirm the user's real Quickshell is alive (DISPLAY=:0) — a pattern-based kill loop left stray test instances and a reload left the real panel dead"
metadata:
  node_type: memory
  type: feedback
---

Stop test processes only by their own PID, checked via `/proc/<pid>/environ` DISPLAY or full cmdline, never a pattern loop. After any live deploy or test cleanup run `pgrep -x quickshell` (one process with `DISPLAY=:0`) and `quickshell log` ending in `Configuration Loaded`.

**Why:** dwm-quickshell Session 45 — a cleanup loop did not stop the Xvfb test Quickshell instances, then a `touch`-triggered reload was never checked, and the user reported "quickshell is down" (no panel). Recovery: `DISPLAY=:0 dwm-quickshell-controlcenter action restart-quickshell`.

**How to apply:** treat "the live desktop is still up" as part of finishing any live QML change. See [[reference_quickshell_hot_reload_new_inline_component_fails]].
