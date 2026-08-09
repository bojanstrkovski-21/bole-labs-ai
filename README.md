# ~/.agents

Single source of truth for Bojan's coding-agent setup, shared across Claude
Code, Codex, and GitHub Copilot. Built 2026-08-09 by merging `titus-ai`
(Codex config) and `session-defaults` (Copilot config) with Claude's own
per-project memory.

## Layout

- `skills/<name>/SKILL.md` — 12 reusable skills, agent-agnostic. This is
  already Codex's native `AGENTS_HOME/skills` path; Claude reaches it via a
  per-skill symlink into `~/.claude/skills/`.
- `memory/` — global fact pool, shared across every project (not per-repo).
  `MEMORY.md` is the index. Backfilled from 12 Claude projects and
  session-defaults' notes; originals backed up under
  `~/.claude/backups/agents-memory-merge-*/`.
- `docs/` — two project-doc styles: `project-docs/` (titus's
  AGENTS.md/SPEC.md/ROADMAP.md/TASKS.md split) and `PROJECT.template.md`
  (session-defaults' lighter single-file version).
- `commands/` — shared start-session/end-session workflow definitions.
- `claude/` — `CLAUDE.md`, linked to `~/.claude/CLAUDE.md`.
- `codex/` — ported from titus-ai, dormant until Codex is reinstalled.
  `install.sh` links it automatically once `~/.codex` exists.
- `copilot/` — ported from session-defaults. Copilot has no user-global
  instructions file, so this is consumed via `install.sh new-project`
  instead of a symlink.
- `install.sh` — idempotent installer (same backup-then-symlink pattern as
  titus-ai's) plus a `new-project` bootstrap command.

## Governing policy

Confirm-first across all three tools: state the intended change, wait for a
go-ahead, never run git commands (init/commit/push/branch/tag) without being
asked. New project directories get an explicit git-init question; ending a
session checks for uncommitted/unpushed work and reminds rather than acting.
Full rationale in `memory/global-working-agreement.md`.

## Known follow-ups (not done in the initial merge)

- Several near-duplicate memory facts exist under different filenames
  (e.g. `feedback_session-workflow.md` vs `feedback_session_workflow.md`,
  `user-profile.md` vs `user_profile.md`) — collisions on identical
  filenames were merged, near-duplicates under different names were not.
- No settings.json permission-layer enforcement (e.g. `ask` on `git push`)
  was added for Claude — the confirm-first rule is instruction-level only
  for now; wiring an actual permission gate is a good next step via the
  `update-config` skill once the exact rule syntax is confirmed.
- `codex/config.toml` is linked as-is; it does not get titus-ai's
  per-machine `~/github` trust-entry rendering. Run titus-ai's own
  `scripts/install.sh` instead if that's needed.
