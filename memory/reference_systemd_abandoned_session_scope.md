---
name: reference_systemd_abandoned_session_scope
description: "an \"abandoned\" systemd session-N.scope (login leader died without a real logout) has no active stop job, so loginctl terminate-session and stop-timeout configs don't touch it — needs systemctl stop <scope> directly"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-22T12:59:47.658Z
---

When a login session's leader process dies without a proper logout ever
being triggered (a crash, a forced kill, a VM/display hiccup), systemd
marks its `session-<id>.scope` unit `SubState=abandoned` while
`ActiveState` stays `active` — the processes still inside the scope's
cgroup keep running indefinitely, because nothing has ever actually issued
a stop job against it (`systemctl show session-N.scope -p Job` reads
empty). This looks identical, from `loginctl list-sessions`, to a session
that's genuinely mid-teardown (`State=closing` either way) — but
`loginctl terminate-session <id>` on an abandoned scope does *not* start a
new stop job (there's no tracked leader left for logind to signal), so it
silently no-ops and the orphaned processes survive. A stop-timeout
shortened via `DefaultTimeoutStopSec`/a unit's `TimeoutStopSec` (see
[[project_dwm-quickshell]]'s own fix for a *different*, related problem —
an *active* stop taking too long) is equally irrelevant here: a timeout
only fires against an in-progress stop job, and there isn't one. The fix
is to bypass logind and stop the systemd unit directly:
`sudo systemctl stop session-<id>.scope` — this does start a real job and
correctly SIGTERMs/SIGKILLs everything in the scope. Confirmed live: this
is exactly what finally reaped a `dwm-lock-watch`/`dwm-status` cluster
that `terminate-session` left untouched.
