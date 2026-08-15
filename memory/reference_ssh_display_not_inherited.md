---
name: reference_ssh_display_not_inherited
description: "A GUI-launching action script called over a bare SSH command silently fails with \"could not connect to display\" unless DISPLAY is exported explicitly first — the login session's DISPLAY isn't inherited"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-15T17:43:02.140Z
---

Running a command like `ssh host 'some-tool action restart-gui-app'`
does not inherit the target machine's graphical login session's
`DISPLAY` env var — a bare SSH shell has none set, so any Qt/X11 tool it
launches fails immediately with `qt.qpa.xcb: could not connect to
display` / "no Qt platform plugin could be initialized." Running the
same command interactively at a real desktop terminal works fine, which
makes this easy to misdiagnose as a code bug rather than an environment
gap.

**Symptom**: a restart/relaunch action appears to succeed (exit 0, no
error surfaced) but the target GUI process is simply not running
afterward — screenshots taken right after look identical to before, or
show just the bare desktop/wallpaper.

**Fix**: explicitly prefix the call with `DISPLAY=:0` (or whatever the
real display number is) every time a GUI-launching command is invoked
over a fresh non-interactive SSH session. Always re-verify the process
actually came up (e.g. `pgrep -x <processname>`) before trusting a
screenshot taken right after — don't assume success from the restart
command's own exit code.

**Real-world cost**: caused a rapid multi-size icon-comparison sweep
(4 sizes, 4 SSH-triggered restarts in a row) to silently leave the
target process dead after the last iteration — all 4 "comparison"
screenshots looked identical because the process was never actually
running for most of them. Caught by checking the crash log directly
(`.qslog`) rather than guessing. Related to but distinct from
[[reference_ssh-session-testing-artifact]] (that one is about a spawned
process binding to the wrong systemd session/cgroup; this one is a
missing env var, no session-binding involved).
