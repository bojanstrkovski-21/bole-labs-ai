---
name: reference_daemon_kill0_kills_test_launcher
description: "A daemon cleanup kill 0 (process group) also kills the test script that launched it; run the daemon as its own group leader via setsid"
metadata:
  type: reference
---

Cleanup that signals the whole process group takes the launching test script down too. Re-exec the daemon through `setsid`, stop it by pid file, and give a fake event source (e.g. a stubbed `udevadm`) a long `sleep` so it does not exit the way a real one never would. See [[reference_self_signal_inside_own_trap_recurses]].
