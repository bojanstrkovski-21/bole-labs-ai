---
name: feedback-session-workflow
description: "User's \"start session\" / \"end session\" convention for this project"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 43779ef8-f1e0-457e-af7b-8b6e0fa24172
---

The user works on this project in distinct sessions and wants a lightweight
ritual around them, triggered by literal chat messages (not slash commands,
not hooks — these are plain text the user types):

- When the user types **"start session"**: treat it as the beginning of a
  fresh work session. Re-orient by reading [[project_overview]] and
  [[session_log]] (recent entries) so you have current context before doing
  anything else. Briefly summarize where things stand and ask what they want
  to work on, rather than assuming.
- When the user types **"end session"**: write a summary of everything done
  in the conversation to memory before ending. Concretely:
  1. Append a new dated entry to [[session_log]] (newest on top) covering
     what changed and why — not a full diff dump, just the substance.
  2. If anything surfaced during the session that belongs in
     [[project_overview]] (new component, changed architecture) or
     [[reference_repo_setup]] (new publishing step, new remote, etc), update
     those files too.
  3. Confirm to the user that memory was updated before considering the
     session closed.

**Why:** the user explicitly asked for this at project memory setup
(2026-06-30) so that returning to this project later — even in a new
conversation — picks up with full context without them having to re-explain
the project each time.

**How to apply:** This is a manual, conversational trigger phrase, not an
automated hook — Claude must actively recognize the literal phrases "start
session" / "end session" in the user's messages within this project's
conversations and perform the steps above. There is no settings.json hook
for this (hooks can't write memory; only the agent's own reasoning/tool
calls can), so it depends on Claude noticing the phrase each time.
