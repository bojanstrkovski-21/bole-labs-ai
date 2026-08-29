---
name: reference_pkill_comm_15char_truncation
description: "pkill/pgrep -x silently matches nothing against a process name longer than 15 characters, because Linux truncates comm (task_struct->comm) to 15 chars + null"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-22T12:59:36.268Z
---

Linux's `comm` field (`/proc/<pid>/comm`, what `ps`'s default `comm`/`ucomm`
columns and `pkill -x`/`pgrep -x` match against) is hard-limited to 15
characters + a null terminator. A script or binary with a longer name gets
silently truncated at the kernel level — `pkill -x` against the full name
then matches nothing, with no error (modern `pgrep`/`pkill` do print a
warning: "pattern that searches for process name longer than 15 characters
will result in zero matches"). Two same-prefixed long names truncate to the
identical string and become indistinguishable at the comm level (e.g.
`dwm-quickshell-controls` and `dwm-quickshell-network` both truncate to
`dwm-quickshell-`). Fix: use `-f` instead (matches the full command line,
unaffected by the comm limit). This is a different bug from — but rhymes
with — [[reference_x11_hotkey_keysym_vs_keycode]]'s sibling issue in the
same project: a bash-shebang script's `comm` stays `bash` regardless of its
own filename (interpreter-dependent, not length-dependent), so `-x` fails
there for a completely different reason and needs the same `-f` fix. Found
in [[project_dwm-quickshell]] auditing `chadwm-boki/scripts/autostop.sh`'s
kill-list, which had used broken `-x` matches for both `dwm-quickshell-*`
scripts since the line was first written — confirmed live via
`/proc/<pid>/comm` and `pgrep`'s own warning before fixing.
