---
description: "End the current work session — summarize, update project docs, check git state."
---

# End Session

1. **Summarize** what was accomplished this session in 3-5 bullet points.
2. **Propose updates to the project doc(s)**: append to Recent Work
   (`YYYY-MM-DD — what was done`), update Current State, update Next Steps.
3. **If a TODO/TASKS file exists**, propose updates — tick completed items, add newly discovered ones.
4. **Propose 1-2 durable facts** worth saving to `~/.agents/memory/` (new file,
   proper frontmatter, `name`/`description`/`metadata.type`). Check the
   existing `MEMORY.md` index first — don't duplicate an existing fact.
5. **Check git state:**
   - Run `git status` (and compare against the remote if one is configured).
   - If there are uncommitted changes, or committed-but-unpushed changes,
     say so explicitly: "You have uncommitted/unpushed changes from this
     session — commit and push before you go."
   - Do not commit or push it yourself. This is a reminder, not an action.
6. Show all proposed changes and wait for confirmation before writing anything.

## Rules

- No git commands run automatically at any point in this flow — checking
  `git status` is read-only and fine; commit/push/branch/tag is not.
- Only update files the user confirms.
