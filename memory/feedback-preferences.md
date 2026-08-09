---
name: feedback-preferences
description: How this user likes to work and communicate
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 4a254bef-4bdf-4bb8-a85c-7ccb65c673fb
---

Before implementing, tell the user what fields/columns/requirements they need to prepare — they appreciate knowing this upfront so they can prepare data on their end (e.g. Excel column names before import).

**Why:** User asked "tell me what fields i need in my excel document" before implementation — they want to be informed before doing work on their side.

**How to apply:** For any feature that requires user-prepared data (files, formats, naming conventions), lead with the requirements before writing code.

---

When something isn't working, user gives concise problem statements without much detail ("nope no class again"). Diagnose proactively with debug output rather than asking many questions.

**Why:** Observed pattern — user doesn't explain deeply, expects the fix to come from investigation.

**How to apply:** Add debug output / logging first to diagnose, then fix.
