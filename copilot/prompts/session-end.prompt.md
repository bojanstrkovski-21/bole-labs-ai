---
description: "End the current work session. Use when done working and want to wrap up, summarize what was accomplished, and update project context."
agent: "agent"
---

# Session End

Wrap up the current work session.

## Steps

1. **Summarize** what was accomplished this session in 3–5 bullet points

2. **Propose updates to `PROJECT.md`:**
   - Add an entry to the **Recent Work** section: `YYYY-MM-DD — [what was done]`
   - Update **Current State** if it changed
   - Update **Next Steps** to reflect what remains or what comes next

3. **If `TODO.md` exists** in the workspace root, propose updates to it as well — tick completed items, add newly discovered tasks

4. **Propose 1-2 durable facts** learned or reinforced this session as new
   files under `~/.agents/memory/` (proper frontmatter: `name`, `description`,
   `metadata.type`). Check `~/.agents/memory/MEMORY.md` first — do not
   duplicate an existing fact.

5. **Check git state:** run `git status` (read-only) and compare against the
   remote if one is configured. If there are uncommitted changes, or
   committed-but-unpushed changes, say so explicitly: "You have
   uncommitted/unpushed changes from this session — commit and push before
   you go." Do not commit or push it yourself.

6. Show all proposed changes and ask for confirmation before writing anything

---

## Rules

- `git status` (read-only) is fine for the check above; no other git command runs automatically
- Do NOT suggest committing, pushing, branching, or tagging beyond the reminder in step 5
- Do NOT perform any git write operation
- Only update files the user confirms
