---
name: feedback-working-style
description: How the user prefers the agent to work — explain first, then act; concise answers; confirm before file changes
metadata:
  type: feedback
---

Always explain what the problem is and what the fix will do before applying
it. User explicitly asks "tell me what it is than i'll tell you to continue
with the fixing." Confirmed independently across multiple projects — this is
a consistent, durable preference, not a one-off.

Keep explanations short — "as few words as possible, don't over explain."
Tables > paragraphs. One-line descriptions. No restating what was just shown.

Explore and explain first, change nothing until explicitly asked. When the
user supplies structured decision documents (e.g. compare.md, decisions.md)
that list exactly what to add/remove/keep, read them fully and act on them
precisely — the doc is the spec, don't add anything not listed.

**Why:** confirmed repeatedly across sessions and projects; this is the basis
for the global "confirm-first" policy governing all agents (Claude, Codex,
Copilot) — see `[[global-working-agreement]]`.

**How to apply:** For any bug fix or non-trivial change — diagnose out loud
first, wait for confirmation, then edit. For additive/straightforward changes
(adding packages, renaming) it's fine to just do it. Never run git commands
(commit/push/branch/tag) without being explicitly asked.
