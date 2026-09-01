---
name: reference_backgrounded_child_inherits_parent_process_group
description: "A plain `foo &` inherits its parent's process group unless setsid'd — a \"kill the whole group\" cleanup elsewhere can silently kill an unrelated long-running process that happened to be launched that way"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f1b950f0-c1d0-4466-923f-bc56f9964782
  modified: 2026-09-01T21:50:02.030Z
---

Backgrounding a process with a bare `foo &` does **not** give it its own
process group — it inherits the PGID of whatever shell/process launched
it. If that launcher is itself a child of some other long-running process
(e.g. a script invoked as a subprocess of an app, itself run via `setsid`
to be its own group leader), the backgrounded child ends up sharing that
same outer process group, several levels removed from anything that looks
related at a glance.

This becomes a real, hard-to-spot bug when something elsewhere implements
a "reap orphaned children" mechanism via `kill -- "-$pgid"` (a `kill`
against a *negative* PID targets the whole process group, not just that
one PID) keyed off some *other* long-running process's exit — e.g. "when
the app that owns this process group exits, sweep everything left in that
group." That mechanism is correct for its own stated purpose (cleaning up
things the app itself spawned), but it will also silently kill any
*unrelated* long-lived process that happened to get backgrounded without
its own `setsid` somewhere in that ancestry — the two features can be
built sessions apart, by different intentions, and never notice they
interact until something the second script launches mysteriously dies
every time the first app restarts.

Diagnose with `ps -o pid,pgid,ppid,cmd -C <name>` — compare the suspect
process's PGID against the app whose restarts seem to correlate with it
disappearing; a match confirms it. Fix: wrap the background launch in
`setsid` (`setsid foo >/dev/null 2>&1 &` or `command -v setsid && setsid
"$@" || "$@"` as a small reusable wrapper) so it becomes the leader of its
own fresh process group, immune to any sweep of the group it used to
share. Found in [[project_dwm-quickshell]]: `dwm-quickshell-compositor`
backgrounding xcompmgr/picom/fastcompmgr with a bare `&` when triggered
through Quickshell (itself a child of Quickshell's own `setsid`-launched
process group) meant the active compositor was silently killed by a
Session-11-built orphan-reaping mechanism (`watch_quickshell_group()`)
every time Quickshell itself restarted — confirmed via matching PGIDs,
fixed by routing the launch through this project's existing
`setsid`-wrapped `launch_background()` helper, the same one already used
everywhere else in the project for exactly this reason.

The opposite-direction sibling of this issue —a script's *own* cleanup
not reaching far enough into what it spawned, rather than someone else's
sweep reaching too far— is [[reference_pipeline_child_survives_parent_kill]].
