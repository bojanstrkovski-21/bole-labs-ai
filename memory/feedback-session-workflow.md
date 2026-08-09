---
name: feedback-session-workflow
description: "User's start-session/end-session convention — now implemented globally via ~/.agents/commands/"
metadata:
  type: feedback
---

The user has independently re-invented the same "start session" / "end
session" ritual across at least five projects (`git_init_first_time`,
`session-defaults`, `archboki-doom-emacs-project`, `archboki-doom-emacs-config`,
`arch-boki-logout`, and explicitly requested again for
[[project_dwm-quickshell]] on 2026-07-16) — a deliberate, repeated
preference, not a one-off. Two literal trigger phrases the user types in
chat (not slash commands, not hooks) drive it:

- **"start session"** → re-orient by reading the project's doc/status log,
  show a compact summary (what it does, stack, current state, next steps),
  then confirm or ask the goal for the session.
- **"end session"** → summarize what was accomplished, propose updates to
  the project doc/status log, confirm before writing anything.

Two variants existed before this was unified:
- The common one: a `CLAUDE.md` (rules) + `memory/PROJECT.md` (dated status
  log, entries appended not rewritten) pair at the project root.
- `arch-boki-logout`'s variant: a `project_overview.md` (architecture) +
  `session_log.md` (dated history) pair instead of a single `PROJECT.md`.
- `session-defaults` (Copilot) used `.github/prompts/session-start.prompt.md`
  / `session-end.prompt.md` files with the same logic.

**Superseded 2026-08-09:** all of the above are now one shared
implementation — `~/.agents/commands/start-session.md` and
`end-session.md` — used by Claude, Codex, and Copilot alike (Copilot via
`install.sh new-project`, which copies the equivalent prompt files). It also
adds two things none of the originals had: an explicit ask before `git init`
on a new project, and an uncommitted/unpushed-changes reminder at
session-end. See [[global-working-agreement]].

**How to apply:** when the user says "start session" / "end session" in any
project, follow `~/.agents/commands/start-session.md` /
`end-session.md` — don't reintroduce a project-specific variant or
`.github/prompts/` for a Claude Code project.
