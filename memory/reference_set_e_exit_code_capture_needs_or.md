---
name: reference_set_e_exit_code_capture_needs_or
description: "Under set -e, `cmd; rc=$?` exits on cmd's failure before rc is read; use `rc=0; cmd || rc=$?`"
metadata:
  type: reference
---

In a script running with `set -e`, a failing command followed by `rc=$?` on the
next line never reaches the assignment: the script exits with the command's own
status. A function meant to return 1 for "exit 4 = no code found" returned 4
instead (zbarimg in dwm-quickshell-capture `qr`). Write `rc=0` then
`cmd || rc=$?`.

Related: a test stub whose last line is `[ -n "$VAR" ] && exit 1` exits 1 when
VAR is unset, which breaks every call of the stub; use
`if [ -n "$VAR" ]; then exit 1; fi`.
