---
name: feedback-approach
description: Preferences and corrections the user has given about how to work
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c8fe6678-7b2d-41fb-bce5-c45821d8bb7e
---

Check references before proposing fixes. When the user says "check X first", research that source before presenting a solution.

**Why:** User rejected an initial pkexec fix and asked to check Erik Dubois's repo first — the validated approach came from studying that reference.

**How to apply:** If a fix involves a tool or pattern the user knows well (pkexec, polkit, pacman internals), ask or research before assuming the standard approach is correct.

---

Don't add sudo prefix to commands in the GUI's bash strings — the whole app runs as root via pkexec.

**Why:** Every command runs with root already; adding sudo is redundant and confusing.

**How to apply:** All bash command strings in actions.py and inline in the GUI use no sudo prefix.
