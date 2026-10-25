---
name: feedback_write_global_memory_automatically
description: "Write durable cross-project facts to global memory on your own at end-session (and when learned); do not ask the user first"
metadata:
  type: feedback
---

At "end session" (and whenever a durable, reusable fact is learned), write the
global memory files in `~/.agents/memory/` and their `MEMORY.md` index lines
yourself. Do not show them as proposals and wait for approval.

**Why:** the user said on 2026-10-25 (dwm-quickshell Session 47): "you should
write to global memory automatically not asking me if you can set as rule or
whatever is needed to do from now on". This overrides step 6 of
`~/.agents/commands/end-session.md` for the global memory pool only.

**How to apply:** still check `MEMORY.md` first and update an existing file
instead of duplicating it; still keep project-bound detail in the project's own
doc. The project doc updates (`memory/PROJECT.md`, `CLAUDE.md`) and proposed
rule changes are also written directly; just report what was written. Git
commits and pushes stay forbidden unless asked ([[feedback_git-security-discipline]]).
See [[feedback-session-workflow]].
