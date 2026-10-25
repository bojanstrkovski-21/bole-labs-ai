---
description: "End the current work session — summarize, update project docs, check git state."
---

# End Session

1. **Summarize** what was accomplished this session in 3-5 bullet points.
2. **Propose updates to the project doc(s)**: append to Recent Work
   (`YYYY-MM-DD — what was done`), update Current State, update Next Steps.
3. **If a TODO/TASKS file exists**, propose updates — tick completed items, add newly discovered ones.
4. **Write the durable facts yourself** (no asking, standing rule from the user,
   2026-10-25) to `~/.agents/memory/` (new file, proper frontmatter,
   `name`/`description`/`metadata.type`) and add their `MEMORY.md` index lines.
   Check the existing `MEMORY.md` index first — update instead of duplicating.
5. **Check git state:**
   - Run `git status` (and compare against the remote if one is configured).
   - If there are uncommitted changes, or committed-but-unpushed changes,
     say so explicitly: "You have uncommitted/unpushed changes from this
     session — commit and push before you go."
   - Do not commit or push it yourself. This is a reminder, not an action.
6. Write the project doc updates and the global memory files directly, then report
   exactly what was written. Anything that is not a doc/memory file (code, git)
   still needs the user's go-ahead.

## Rules

- No git commands run automatically at any point in this flow — checking
  `git status` is read-only and fine; commit/push/branch/tag is not.
- Project docs and global memory are written without asking (user's standing
  rule, 2026-10-25); any other file only with the user's confirmation.
