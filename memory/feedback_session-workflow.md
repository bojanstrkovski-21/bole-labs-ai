---
name: feedback-session-workflow
description: "User's standard cross-project convention: CLAUDE.md + memory/PROJECT.md, 'start session' / 'end session' trigger phrases"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
---

This user bootstraps every coding project with the same two files at the repo root: `CLAUDE.md` (rules: overview, stack, conventions, constraints, frozen files, how to run, current state, next steps, recent work) and `memory/PROJECT.md` (a running dated status log — "Status log" / "Recent Work" entries in `YYYY-MM-DD — ...` format, most recent additions appended, not rewritten).

Two trigger phrases drive the workflow:
- **"start session"** (optionally with a topic, e.g. "start session - session topic") → read `memory/PROJECT.md` fully, show a compact summary (what it does, stack, current state, next steps), then confirm or ask the goal for this session.
- **"end session"** → summarize what was accomplished (3–5 bullets), propose updates to `memory/PROJECT.md` (Recent Work / Current State / Next Steps) and to `CLAUDE.md` if any rule needs adding or removing, show the diff, and wait for confirmation before writing anything.

An earlier iteration of this pattern (repo `session-defaults`) used VSCode-Copilot-style `.github/prompts/session-start.prompt.md` / `session-end.prompt.md` files instead — that was superseded once the user moved to Claude Code, where the same rules just live directly in `CLAUDE.md`. Don't reintroduce `.github/prompts/` for Claude Code projects.

**Why:** Established across at least four of the user's projects (`git_init_first_time`, `session-defaults`, `archboki-doom-emacs-project`, `archboki-doom-emacs-config`) and explicitly requested again for [[project_dwm-quickshell]] on 2026-07-16 — this is a deliberate, repeated convention, not a one-off.
**How to apply:** When starting a new project for this user, or when they say "start session" / "end session" in any project, follow this exact pattern unless the project's own `CLAUDE.md` says otherwise.
