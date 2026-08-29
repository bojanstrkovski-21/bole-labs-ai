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

**Recurrence, gone further (2026-08-22)**: this time it wasn't just a
misleading test result — an SSH-invoked `restart_quickshell()` (testing
a new feature) actually left the *live* Quickshell instance permanently
rebound to the SSH connection's own (tty-type) session instead of the
real graphical (x11-type) one, and stayed that way after the SSH
connection ended. Everything Quickshell subsequently spawned inherited
the wrong `$XDG_SESSION_ID`, which silently broke the Power Menu's real
Log Out button (`loginctl terminate-session "$XDG_SESSION_ID"` was
terminating an unrelated stale session, leaving the actual desktop
session untouched — "press Log Out, confirm, nothing happens"). Confirmed
via `/proc/PID/environ` showing the mismatched session id, same
diagnostic as above. The durable fix here wasn't "retest more carefully"
but a real code change: never trust a session-identity env var for an
action like this at all, even in normal (non-test) operation — instead
enumerate actually-live `x11:user` sessions via `loginctl list-sessions`
+ `show-session` at the moment the action runs (see
[[project_dwm-quickshell]]'s `dwm-quickshell-power` `end_all_sessions()`)
and act on whichever session(s) are real, rather than trusting an
inherited identity that testing (or any other relaunch path) could have
silently invalidated. Related: [[reference_systemd_abandoned_session_scope]]
covers a different but adjacent session-hygiene failure mode from the
same debugging arc.
