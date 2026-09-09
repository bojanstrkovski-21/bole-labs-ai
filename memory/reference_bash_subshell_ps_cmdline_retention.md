---
name: reference_bash_subshell_ps_cmdline_retention
description: "A backgrounded bash subshell `( cmds ) &` shows its parent script's own original argv in ps/cmdline, not what it's actually running inside the parens — can look like a hung process when it's working fine"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f1b950f0-c1d0-4466-923f-bc56f9964782
  modified: 2026-09-07T23:48:54.375Z
---

A backgrounded bash subshell (`( cmds ) &`) forks a new process, but that
process's `ps`/`/proc/PID/cmdline` entry keeps showing the **parent
script's own original invocation** (e.g. `/bin/sh /usr/local/bin/some-script
action foo`), not a description of what it's actually executing inside the
`( )`. There's no re-exec, so the kernel's own argv for that process never
changes.

This can read as a hung/stuck process during debugging: a subshell doing a
completely normal, correctly-working `while ...; do sleep N; done` polling
loop shows up in `ps` looking identical to the top-level script that spawned
it, right down to the same command line — easy to mistake for that
top-level invocation itself being stuck, especially when combined with
`/proc/PID/wchan` showing `do_wait` or similar (which the polling loop's own
`sleep`/`kill -0` calls will genuinely show, just as expected background
work, not a bug).

**Why it matters**: before concluding a process is hung, check whether it's
actually a subshell continuing a `( ... ) &` block from higher up in the
same script — its PPID and lstart usually still line up with when that
`&` was launched, and its behavior (what it's polling, how often) will
match that block's logic, not necessarily anything abnormal.

Complements [[reference_bash_backgrounded_function_ps_cmdline]] (the
sibling case for a backgrounded *function* call rather than a `( )`
subshell — same underlying quirk, different syntax).
