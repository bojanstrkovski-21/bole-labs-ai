---
name: reference_scp_multifile_flattening
description: scp with multiple source files from different subdirectories and one directory destination silently flattens every path to its basename
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-14T16:59:31.906Z
---

`scp file1 dirA/file2 dirB/file3 host:dest/` copies every source file
into `dest/` using only its basename — it does not preserve source
subdirectory structure. A file that should land at `dest/dirB/file3`
instead lands at `dest/file3`, silently, with no error. Hit in
[[project_dwm-quickshell]]: `scp panel/DwmPanel.qml shell.qml
core/Commands.qml host:~/.config/quickshell/` put `Commands.qml`
straight in `~/.config/quickshell/` instead of `~/.config/quickshell/
core/`, leaving the real `core/Commands.qml` stale and causing a
runtime error that looked unrelated (a function the file was supposed
to define appeared not to exist).

**How to apply:** never `scp` multiple files that come from different
subdirectories to one flat destination directory. Either scope each
`scp` call to files from a single subdirectory (matching one destination
directory), or pass explicit full per-file destination paths. After any
multi-file deploy, worth spot-checking that the file landed where
expected, not just that the copy command exited 0.
