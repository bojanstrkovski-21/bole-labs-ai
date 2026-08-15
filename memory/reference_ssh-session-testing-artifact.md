---
name: reference_ssh-session-testing-artifact
description: "Manually spawning/restarting a process over SSH to test session/cgroup-dependent behavior binds it to the SSH connection's own session, not the target session — a real testing pitfall, not a code bug"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-12T21:51:18.519Z
---

When testing behavior that depends on a systemd-logind session (e.g.
`XDG_SESSION_ID`, `loginctl terminate-session`, cgroup-scoped process
cleanup), manually spawning or restarting a process over SSH makes that
process inherit **the SSH connection's own session**, not whatever
target session (a real graphical login, etc.) you're trying to
simulate. Setting an env var like `XDG_SESSION_ID` by hand before
spawning does *not* fix this — that only changes what the process's own
code believes, not its actual cgroup membership, which the kernel/
systemd assigns based on which PAM session really forked it.

**Symptom**: a process that should be cleaned up (or should react to a
signal) tied to a specific session appears to "survive" or "not work,"
looking exactly like a real bug, when it's actually just bound to the
wrong (often already-stale) session from your own test spawn.

**How to verify before trusting a test result**: check
`/proc/PID/environ` (for the env-var-derived belief) *and*
`/proc/PID/cgroup` (for the actual session binding) — they can disagree.
Only a genuine login/logout cycle proves session-dependent behavior
correctly; a manually-relaunched-via-SSH process is not a valid stand-in
for it, no matter how carefully the environment is spoofed.

**Real-world cost**: this caused several rounds of false "it's broken"
diagnoses in one debugging session (dwm-quickshell project,
2026-08-12) before being caught — worth checking this early whenever a
session-cleanup or session-ID-dependent test looks inexplicably flaky
after manual SSH-based process restarts.
