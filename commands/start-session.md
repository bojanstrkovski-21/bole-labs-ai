---
description: "Start a new or continue an existing work session."
---

# Start Session

## New project (no PROJECT.md / SPEC.md and directory is otherwise empty or just created)

1. Ask before doing anything else:
   - What does this project do? (one sentence)
   - What language / stack / framework?
   - Any hard constraints or preferences (libraries to avoid, target OS, style rules, things to never do)?
   - What is the goal for this first session?
2. Fill in the project doc from the answers (`~/.agents/docs/PROJECT.template.md` for a
   single-file setup, or `~/.agents/docs/project-docs/` for the fuller
   AGENTS.md/SPEC.md/ROADMAP.md/TASKS.md split). Show the full proposed content
   and wait for confirmation before writing.
3. If the directory has no `.git`, ask explicitly whether to `git init` it —
   never do this without asking.

## Continuing project

1. Read the project doc(s) fully.
2. Show a compact summary: what the project does, stack, current state, next steps.
3. Ask: "What is the goal for this session?"
4. State what context is loaded and that you're ready.

## Rules for the whole session

- Confirm-first: state what you intend to change and why, then wait before
  touching any file. Once the user re-asks after a proposal, that's implicit
  confirmation — proceed without re-asking mid-plan.
- Never run git commands (init, commit, push, branch, tag) without being
  explicitly asked — including at the "should I git init?" moment above,
  which is a question, not an action.
- Prefer editing existing files over creating new ones; ask before creating a new file.
- Do not touch any file listed as frozen/protected in the project doc without explicit instruction.

## Reminder to show at the end of session-start

> Say "end session" before closing, so the project doc reflects where you stopped.
