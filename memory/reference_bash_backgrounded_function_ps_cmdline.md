---
name: reference_bash_backgrounded_function_ps_cmdline
description: "Backgrounding a bash function (funcname &) forks a child that still shows the parent script's own cmdline in ps -- can look like the script recursively spawning copies of itself when it's really just its own normal watcher/pipeline children"
metadata:
  type: reference
---

When a bash script backgrounds one of its own functions (`some_func &`,
common for a daemon spawning watcher subprocesses), the forked child is
not an `exec` of anything new — it's just a fork continuing execution
inside the same script. `ps`/`/proc/PID/cmdline` for that child still
shows the parent script's own invocation line (e.g. `bash /usr/local/bin/
dwm-status`), not the function name. A pipeline inside that function
(`cmd | while read ...`) forks again for each stage, so a healthy daemon
with 3 backgrounded watcher functions plus one pipeline each can
legitimately show up as 5-6 processes all sharing the identical `bash
/path/to/script` cmdline, several levels deep in the process tree.

Read cold, a `ps -eo pid,ppid,cmd` of this looks exactly like the script
recursively spawning copies of itself — the pitfall is treating a
normal, single-instance process tree as a fork-bomb-in-progress and
reacting accordingly (killing everything, alarming the user) without
first checking whether it's actually *multiple overlapping top-level
launches* (e.g. from repeated manual test invocations without cleaning
up the previous one) rather than one instance behaving badly. Check
`ppid`/`pid` relationships carefully — one real top-level launch has
exactly one process with `ppid` outside the tree, plus its own known
number of children/grandchildren; more than that many "root" processes
means multiple overlapping instances, not a spawning bug. Found and
initially misdiagnosed in the [[project_dwm-quickshell]] project's own
`dwm-status` daemon — corrected before it led to any wrong fix.
