---
name: reference_pipeline_child_survives_parent_kill
description: "Killing a tracked child PID that runs `cmd1 | while read...; done` doesn't touch cmd1 itself (a separate process on the other end of the pipe) — it becomes a real orphan unless you own your own process group and kill the whole group"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f1b950f0-c1d0-4466-923f-bc56f9964782
  modified: 2026-09-01T21:49:44.406Z
---

A common daemon-cleanup pattern is: background a few watcher functions,
track their PIDs in an array, and `kill "${pids[@]}"` on shutdown. This
silently misses anything those functions themselves spawned as part of a
pipeline. `watch_x() { some_long_running_cmd | while IFS= read -r line;
do ...; done; }` run as `watch_x &` forks one process for the function
call, but the pipeline *inside* it forks `some_long_running_cmd` as its
own separate process (the write end of the pipe), parented to that
subshell, not to the top-level script. `kill $tracked_pid` only signals
the subshell (the read end); the write-end command — often something that
blocks forever by design, like `pactl subscribe` or `udevadm monitor` —
is never touched and becomes a real orphan, reparented to init, running
indefinitely.

This is easy to miss because a *single* clean shutdown looks fine (the
tracked pids do exit) — the leak only shows up as accumulating background
processes across many restart/shutdown cycles, exactly the class of bug
this project has hit more than once (see
[[reference_backgrounded_child_inherits_parent_process_group]] for the
sibling issue — an *external* sweep killing something it shouldn't; this
one is the opposite direction, a script's *own* cleanup not reaching far
enough).

Fix: make the daemon its own process-group leader (a `setsid` re-exec
guard at the top: `[ "$(ps -o pgid= -p $$)" != "$$" ] && exec setsid "$0"
"$@"` — `setsid` only forks if the caller is *already* a group leader, so
this specific ordering never causes a PID change), then in cleanup, do a
**group-wide** kill (`kill -TERM -- "-$$"`) instead of killing individual
tracked PIDs. This is only safe to do once the process actually owns its
group — doing a group kill while still sharing a parent's group (e.g. a
script backgrounded with a bare `&` from another script, no `setsid`)
would also hit unrelated sibling processes. See
[[reference_self_signal_inside_own_trap_recurses]] for the crash this
specific fix can introduce if the group kill is sent while still inside
that same signal's own trap handler.

Found in [[project_dwm-quickshell]]: `dwm-status`'s `cleanup()` only
killed its 3 tracked `watch_*()` subshells, never the real
`pactl subscribe`/`udevadm monitor` processes those subshells' own
pipelines spawned — confirmed this had been leaking two real orphan
processes on every single logout since the script was built, reproduced
directly against the unfixed script (not assumed from reading the code).
