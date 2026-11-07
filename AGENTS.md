# Repository instructions

## Scope

This repository is the source of truth for the shared coding-agent setup used
by Claude Code, Codex, Copilot, and other agents: global instructions, skills,
memory, session commands, and project-doc templates. `README.md` describes the
layout. Global behavior rules live in `claude/CLAUDE.md` and `codex/AGENTS.md`;
this file covers maintaining the repository only.

## Layout and ownership

- `skills/<name>/SKILL.md`: reusable, agent-agnostic workflows.
- `claude/`, `codex/`, `copilot/`: per-tool instructions and configuration.
- `memory/`: global fact pool; `MEMORY.md` is the index.
- `commands/`: start-session and end-session workflow definitions.
- `docs/`: project-doc templates and `SKILLS.md` (skill authoring rules and
  inventory). Docs are references, not loaded automatically.
- `scripts/`: `validate.sh` and `test-install.sh`.
- `install.sh`: idempotent installer; links managed files, never overwrites
  without a backup.
- `titstack/`, `website/`: local reference clones, gitignored. Do not edit them
  or copy their text; adapt ideas and record the source.

## Editing rules

- Put a reusable workflow in a skill, a cross-project rule in the global
  instruction files, and a project-specific rule in that project's docs. Do not
  duplicate a rule across scopes.
- Read `docs/SKILLS.md` before creating or changing a skill. Keep descriptions
  short with the use case first.
- Keep credentials, tokens, sessions, history, and caches out of the
  repository. Check memory files for secrets before saving.
- Add a memory fact only if it is not derivable from the repository; update an
  existing file instead of duplicating it, and keep `MEMORY.md` in sync.
- Machine-specific values (home paths, trusted project lists) do not belong in
  portable configuration files.

## Verification

- Run `./scripts/validate.sh` after changing skills, `install.sh`, the
  instruction files, configuration, or the layout. It checks skill front matter,
  the inventory in `docs/SKILLS.md`, TOML syntax, shell syntax and ShellCheck,
  and runs the installer in an isolated temporary HOME.
- Test installer changes only against a temporary HOME, never the real one.
- Fix the cause of a failing check instead of weakening it.
