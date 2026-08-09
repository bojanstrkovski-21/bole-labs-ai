# Global Codex instructions

Source of truth: `~/.agents/`, shared across Codex, Claude, and Copilot. See
`~/.agents/README.md` for the layout. Skills live in `~/.agents/skills/`
(already Codex's native `AGENTS_HOME/skills` path), memory in
`~/.agents/memory/`, project-doc templates in `~/.agents/docs/`, session
workflow in `~/.agents/commands/`.

## Confirm-first

State what you intend to change and why, then wait before touching any file.
If the user re-asks after you proposed something and asked for confirmation,
that counts as implicit confirmation — implement it, don't ask again. Once a
plan is approved, execute all its steps without further mid-plan check-ins.

## Git

- Never run git commands (init, commit, push, branch, tag, remote) automatically.
- When constructing a new project directory, ask explicitly whether to
  `git init` it.
- `git status` (read-only) is fine to run proactively; anything that mutates
  history or a remote needs an explicit ask first.
- Push and authentication are a harder line than the rest: default to the
  user pushing themselves with their own scripts, on any host. Don't reach
  for `gh auth`, credential-helper, or SSH-agent commands even to check
  status — if pushing is blocked on auth, say so and stop, don't
  troubleshoot credentials.
- Never force push. Never amend a published commit. Never create tags without
  being asked.

## Session workflow

- On "start session": follow `~/.agents/commands/start-session.md`.
- On "end session" / "wrap up": follow `~/.agents/commands/end-session.md`.

## Command execution

- Use `rtk` when command output is likely to be large or repetitive and a
  filtered summary is sufficient. Good candidates include test suites, builds,
  linters, logs, broad searches, dependency listings, and infrastructure
  status commands.
- Use raw commands when output is expected to be short, when exact or complete
  output matters, or when inspecting a specific file or narrowly scoped result.
- In command chains, apply `rtk` only to segments that benefit from filtering.
- If RTK hides needed detail, rejects a command or flag, or complicates
  debugging, rerun the command raw. Do not use `rtk proxy` merely to satisfy an
  RTK convention.
- If a task is primarily Bash or command-line automation, consider RTK for
  noisy validation commands, but keep commands raw when validating exact
  stdout, stderr, exit-status, quoting, or pipeline behavior.

## Working style

- Use simple ASCII punctuation unless a file format requires otherwise.
- Inspect repository instructions and existing changes before editing.
- Preserve unrelated user changes.
- Prefer small, reviewable changes with relevant validation.
- Do not expose credentials, tokens, private keys, or secret file contents.
- Do not perform destructive operations without explicit authorization.
- Use subagents only when the user or applicable `AGENTS.md` or skill
  instructions explicitly request subagents, delegation, or parallel agent
  work.
- When the Superpowers plugin is installed, skip its full development
  methodology for trivial, low-risk edits. Use the relevant workflow for
  non-trivial features, debugging, planning, and review work.
- Treat explicit user stop points as hard boundaries. Stop at the requested
  milestone and wait before starting the next phase.

## Scope selection

- Use `AGENTS.md` for durable repository conventions.
- Use `.codex/config.toml` for trusted project-specific Codex settings.
- Use skills for reusable task workflows.
- Treat files under `docs/` as references, not automatic instructions.
