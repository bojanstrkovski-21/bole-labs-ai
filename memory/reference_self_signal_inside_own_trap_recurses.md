---
name: reference_self_signal_inside_own_trap_recurses
description: "Sending a signal to your own process from inside that same signal's bash trap handler recursively re-enters the handler forever (bash doesn't mask it) — can crash the process with a real stack-overflow SIGSEGV, not just loop"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f1b950f0-c1d0-4466-923f-bc56f9964782
  modified: 2026-09-01T21:49:26.456Z
---

`trap 'cleanup; exit N' TERM` followed by `cleanup()` itself sending a
self-directed signal (e.g. a process-group-wide `kill -TERM -- -$$` from
inside the same process, which is a member of its own group) is a real
crash bug, not a theoretical one. Bash does **not** mask/block a signal
while its own trap handler for that signal is still executing — a
self-directed re-delivery of the same signal lands *while already inside*
`cleanup()` and re-enters it, which re-sends the signal, which re-enters
it again, forever, until the call stack is exhausted. Confirmed live:
`bash -c 'trap "cleanup; exit 100" TERM; cleanup(){ kill -TERM -- "-$$"; }; kill -TERM $$'`
prints the trap body's own echo hundreds of times before crashing —
in a real script this manifested as a genuine `Segmentation fault (core
dumped)`, reproduced 3/3 times before the fix, gone 8/8 times after.

Fix, in order:
1. **Reset every trap first**, before doing anything else in the handler:
   `trap - EXIT INT TERM` as literally the first line of `cleanup()`. This
   is the actual fix — once there's no trap left, a redelivered signal
   just takes its default action (process termination), which is fine
   since the process is exiting anyway.
2. Do the rest of the real cleanup work (removing state files, releasing
   locks, etc.) **before** the self-inclusive signal, not after — once
   the trap is gone, that self-signal's default action can end the
   process almost immediately (signals are delivered at the next
   opportunity between simple commands, not "later"). Putting the
   self-signal early risks it winning a race against cleanup steps that
   haven't run yet — confirmed live as a second, related bug: an
   identity/lock file the script was supposed to remove on shutdown
   sometimes survived because the self-kill outraced the removal.
3. Put the self-inclusive group/self kill as the **last** statement in
   the handler.

Found in [[project_dwm-quickshell]]: `dwm-status`'s `cleanup()`, while
fixing a separate real bug (see
[[reference_pipeline_child_survives_parent_kill]]) where the fix required
adding a group-wide `kill -TERM -- "-$$"` to actually reach every
descendant process.
