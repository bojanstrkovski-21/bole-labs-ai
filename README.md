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
- `copilot/` — ported from session-defaults, plus `set-git-cred.sh`/`push.sh`
  (the user's standard git bootstrap scripts, used in ~20 of their projects).
  Copilot has no user-global instructions file, so this whole directory is
  consumed via `install.sh new-project` instead of a symlink.
- `install.sh` — idempotent installer (same backup-then-symlink pattern as
  titus-ai's) plus a `new-project` bootstrap command that also fills in and
  copies `set-git-cred.sh`/`push.sh`.
- `set-git-cred.sh`, `push.sh` — this repo's own filled-in copies
  (`project=bole-labs-ai`), for the user to run themselves. Not run by
  Claude/Codex/Copilot — see the git-authentication rule below.

## Governing policy

Confirm-first across all three tools: state the intended change, wait for a
go-ahead, never run git commands (init/commit/push/branch/tag/remote)
without being asked. New project directories get an explicit git-init
question; ending a session checks for uncommitted/unpushed work and reminds
rather than acting. Local git steps (init, remote add, branch rename,
commit) are fine once confirmed; **push and authentication are a harder
line** — the user pushes themselves with `set-git-cred.sh`/`push.sh` on any
host, and the agent doesn't reach for `gh auth`/credential-helper/SSH-agent
commands even to check status. Full rationale in
`memory/global-working-agreement.md` and `memory/feedback-codeberg-pushes.md`.

## Current remote state

`~/.agents` itself: local `main` branch, `origin` ->
`github.com/bojanstrkovski-21/bole-labs-ai` (added, not pushed — pending the
user running `./set-git-cred.sh` then `./push.sh`).

## Known follow-ups (not done in the initial merge)

- ~~Near-duplicate memory facts under different filenames~~ — done
  2026-08-09: audited every file's `name:` frontmatter for collisions (not
  just filenames). Found and fixed three: `user-profile.md`/`user_profile.md`
  (same person, merged into one), `project-overview.md`/`project_overview.md`
  (different real projects wrongly sharing a generic slug — renamed to
  `project-overview-svidetelstva.md` / `project-overview-arch-boki-logout.md`),
  and `feedback_session-workflow.md`/`feedback_session_workflow.md`
  (two historical variants of the same convention — consolidated into
  `feedback-session-workflow.md`, updated to point at the current
  `commands/` implementation). All `[[wiki-links]]` referencing the old
  names were repointed. Remaining filename inconsistency (some older facts
  use `snake_case.md`, newer ones use `kebab-case.md`) is cosmetic — no
  further `name:` collisions exist.
- No settings.json permission-layer enforcement (e.g. `ask` on `git push`)
  was added for Claude — the confirm-first rule is instruction-level only
  for now; wiring an actual permission gate is a good next step via the
  `update-config` skill once the exact rule syntax is confirmed.
- `codex/config.toml` is linked as-is; it does not get titus-ai's
  per-machine `~/github` trust-entry rendering. Run titus-ai's own
  `scripts/install.sh` instead if that's needed.
- ~~push.sh's branch-push check grepped the remote URL for "main"/"master"
  instead of the actual branch~~ — fixed 2026-08-09: now uses
  `git rev-parse --abbrev-ref HEAD`. Other repos using this same template
  (~20 of them) likely carry the same latent bug — worth checking if their
  remote URL doesn't literally contain "main"/"master".

## Acknowledgments

Thanks to [Chris Titus Tech](https://github.com/ChrisTitusTech) and
[Erik Dubois](https://github.com/erikdubois) for the neverending
inspiration.
