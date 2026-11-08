---
name: feedback_write_global_memory_automatically
description: "When a durable fact belongs in global memory, write it yourself; do not ask whether to sync"
metadata:
  type: feedback
---

When a durable, reusable fact belongs in `~/.agents/memory/`, write the file
and its `MEMORY.md` index line yourself. Do not ask whether it should be
synced. If nothing new qualifies, skip it. Do not ask in that case either.

The phrase the user types is "end session" or "end-session". After checking what the session did, write the project log and the global facts. Do not ask whether to write them. `end-session.md` step 2 still says "propose"; steps 4 and 6, and the Rules section, are the ones that apply. Confirmed 2026-11-09 for boki-webapps. The same write-without-asking outcome is already in dwm-quickshell's end-session steps 5 and 6.

**Why:** the user said on 2026-10-25 (dwm-quickshell Session 47): "you should
write to global memory automatically not asking me if you can set as rule or
whatever is needed to do from now on". Reconfirmed 2026-11-09 on
boki-webapps: "always sync whats needed in global memory without asking me
if you should if there is anything to sync in there". This overrides step 6
of `~/.agents/commands/end-session.md` for the global memory pool only.

**How to apply:** still check `MEMORY.md` first and update an existing file
instead of duplicating it; still keep project-bound detail in the project's own
doc. The project doc updates (`memory/PROJECT.md`, `CLAUDE.md`) and proposed
rule changes are also written directly; just report what was written. Git
commits and pushes stay forbidden unless asked ([[feedback_git-security-discipline]]).
See [[feedback-session-workflow]].
