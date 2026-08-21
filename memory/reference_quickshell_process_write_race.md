---
name: reference_quickshell_process_write_race
description: "Quickshell QML's Process.write() is a no-op until the process has actually spawned, and stdinEnabled is a plain mutable property that doesn't reset itself between runs — calling write() right after running=true, then closing stdinEnabled, is a real race that silently drops data and hangs the child process"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-20T22:21:33.881Z
---

Quickshell's `Process` QML type (`Quickshell.Io`) has two related pitfalls
around feeding it stdin data, confirmed against the real API docs and
reproduced directly (not guessed):

1. **`write()` is a no-op until the process has actually spawned.**
   `running = true` starts the process asynchronously — calling `.write()`
   synchronously right after setting `running = true` races the real
   fork/exec. A lost race silently drops the data with no error. If the
   backend command then reads stdin expecting that data (e.g. a `cat >
   file` pattern), it hangs forever waiting for input that will never
   arrive.
2. **`stdinEnabled` doesn't reset itself between runs.** It's a plain
   mutable property, not tied to `running`'s lifecycle. Setting it to
   `false` after one run's write (the standard way to signal EOF) leaves
   it `false` for the *next* run too — so a second use of the same
   `Process` element silently no-ops its own `write()` call as well,
   hanging deterministically every time after the first.

**Fix**: write from the `Process`'s `onStarted` signal handler (fires once
the process has genuinely spawned) instead of synchronously after setting
`running = true`, and explicitly reset `stdinEnabled = true` at the start
of every invocation, before setting `running = true` again.

**Symptom this produces**: a UI status like "Saving..." that just hangs
forever with no error, no timeout, no stderr output — the child process
(visible via `ps`/`/proc/PID/wchan` showing `do_wait` or similar, blocked
in the kernel) is alive and waiting, not crashed. Easy to misdiagnose as
something else entirely (a different recent change gets blamed) since the
bug is silent and only sometimes wins the race.
