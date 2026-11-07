---
name: feedback_verify_edit_landed
description: "After a scripted or patched edit, grep the file for the new text and check git status before saying it is done; an "ok" print or a load test on an unchanged file proves nothing"
metadata:
  type: feedback
---

After any scripted or patched edit, grep the target file for the new text (and check `git status`) before reporting the change as made.

**Why:** in dwm-quickshell Session 28 a Python patch printed `ok` without ever calling `write()`, and the follow-up QML load test ran against the *unchanged* file and passed. A feature was reported as done when nothing had changed; only a later patch asserting a missing string exposed it.

**How to apply:** put the file write after all replacement asserts, print only after writing, then grep for the new text. A "clean load" is evidence only if it ran against the changed file. Same family: a linter that prints nothing is not a pass until a known-bad control file is flagged (see [[reference_qt6_qml_tools_path]]).
