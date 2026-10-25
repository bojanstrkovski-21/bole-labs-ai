---
name: reference_quickshell_children_inherit_sigchld_ignored
description: "Processes spawned by Quickshell inherit SIGCHLD ignored, so paru/yay fail with ECHILD (exit 1, empty result); bash resets it for itself but passes SIG_IGN to its children"
metadata:
  type: reference
---

A Quickshell `Process` child starts with SIGCHLD set to ignore. A program that
waits on its own children (paru, `wait4`) then gets ECHILD and exits 1 with no
output, so a pill that counts AUR updates silently shows 0 while the same
command works in a terminal.

A bash script resets an ignored SIGCHLD for itself at startup, but still passes
SIG_IGN down to the commands it runs, so fixing it inside the script does not
help the command. Run the command as `env --default-signal=CHLD <cmd>`.

To test: `env --ignore-signal=CHLD sh script`, with a Python stub for the
command (a shell stub cannot observe the ignored signal). Found in
dwm-quickshell Session 47 (Updates pill, `dwm-quickshell-setup`).
