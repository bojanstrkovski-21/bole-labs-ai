---
name: feedback-verb-matches-action-scope
description: "In a batch of per-item instructions, match the verb per item — \"diff it\"/\"compare it\"/\"check it out\" means show findings only; \"do it\"/\"implement\"/\"port it\" means actually apply changes."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-07-28T21:37:08.700Z
---

When the user gives a long list of per-item verdicts in one message (e.g.
triaging many upstream changes at once), don't default to "implement
everything" momentum. Read each item's verb literally:
- "diff it" / "compare it" / "check it out" / "look it up" → research and
  present findings only, do not touch files.
- "do it" / "implement" / "port it" / explicit "yes, build this" → actually
  make the change.

**Why**: caught live in [[project_dwm-quickshell]] (Session 7, 2026-07-28)
— given a batch of 12 items with mixed verbs, started actually editing
`chadwm-boki/dwm.c` to apply an EWMH diff because the user said "diff it,"
which in context meant "show me the diff," not "apply it." The user had to
stop the edit and redirect back to write-first. This is an easy mistake
specifically when several items in the same message DO say "implement"/"do
it" — the momentum from those bleeds into the ones that only asked for
research.

**How to apply**: before touching any file in a multi-item triage response,
re-check the specific verb used for *that* item, not the general tone of
the message. When genuinely ambiguous, default to presenting findings and
asking, rather than assuming implementation is wanted.
