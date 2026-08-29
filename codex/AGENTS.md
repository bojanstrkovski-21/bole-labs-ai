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

- Run commands directly. Keep output manageable with narrow command scope and
  tool-specific filtering flags when the complete output is unnecessary.
- Preserve exact stdout, stderr, exit status, quoting, and pipeline behavior
  when validating Bash or command-line automation.
- When a task requires multiple SSH commands to the same remote host, use
  persistent client multiplexing when possible: establish one authenticated
  master with `ControlMaster`, `ControlPath`, and `ControlPersist`, verify it,
  and reuse its channels for every sequential or concurrent command. Close a
  task-scoped master when the remote work is complete.
- If required multiplexed concurrency exceeds the server's authenticated
  channel limit, confirm the limit before changing it. Raise `MaxSessions` only
  with rollback and validation, and do not weaken unauthenticated connection
  limits or per-source abuse penalties to improve command throughput.
- Before changing a remote OpenSSH server configuration, determine the trusted
  workstation's current public IP from server-observed connection data. When
  `PerSourcePenalties` is supported, add only that exact `/32` or `/128` to
  `PerSourcePenaltyExemptList` in a dedicated early `sshd_config.d` drop-in,
  preserve any existing exemptions, and set the file mode to `600`.
- Keep the authenticated session open and prepare rollback before applying the
  SSH exemption or any other server change. Run `sshd -t`, reload or restart
  the correct SSH service, verify the effective exemption with `sshd -T`, and
  prove a new multiplexed connection works before closing the original session.

## Working style

- Use simple ASCII punctuation unless a file format requires otherwise.
- Inspect repository instructions and existing changes before editing.
- Preserve unrelated user changes.
- Prefer small, reviewable changes with relevant validation.
- Do not expose credentials, tokens, private keys, or secret file contents.
- Do not perform destructive operations without explicit authorization.
- Do not create or leave a pull request in draft state unless the user
  explicitly requests a draft. If the work is not ready for review, stop
  before opening the pull request and report the blockers. When authorized to
  publish completed work, open a ready-for-review pull request or mark the
  existing draft ready for review.
- Use subagents only when the user or applicable `AGENTS.md` or skill
  instructions explicitly request subagents, delegation, or parallel agent
  work.
- When the Superpowers plugin is installed, skip its full development
  methodology for trivial, low-risk edits. Use the relevant workflow for
  non-trivial features, debugging, planning, and review work.
- Treat explicit user stop points as hard boundaries. Stop at the requested
  milestone and wait before starting the next phase.

## Task interpretation

- Match the requested action mode. `Inspect`, `review`, `diagnose`, and `report`
  authorize investigation and reporting, not implementation. `Fix`, `update`,
  `address`, and `implement` authorize completing the requested change and
  relevant validation.
- Treat an explicit sequence of actions as one authorized workflow. Complete
  every named step without pausing for repeated confirmation unless blocked or
  a new materially risky choice is required.
- Commit, push, pull-request, merge, release, deployment, and external-message
  actions require explicit authorization. When authorized, complete them rather
  than returning instructions or status only.
- When asked to check logs for other issues, inspect the complete relevant run,
  not only the first reported symptom. Separate benign or idempotent conditions
  from genuine failures.
- Never report full success when a required operation, test, validation, or
  requested step failed. Report partial completion and the exact remaining
  blockers.

## Acceptance evidence

- Treat user-provided screenshots and runtime observations as acceptance
  evidence. Reconcile visible failures even when automated checks pass, then
  revalidate.
- When setting up a development environment, install the required tooling and
  prove the actual build, lint, and test commands work on that machine.
- Preserve user-supplied publication-ready commands, links, examples,
  verification steps, and update procedures unless the user asks to condense
  them.

## Scope selection

- Use `AGENTS.md` for durable repository conventions.
- Use `.codex/config.toml` for trusted project-specific Codex settings.
- Use skills for reusable task workflows.
- Always use the `youtube-thumbnail` skill whenever a user mentions a YouTube
  thumbnail or asks to create, edit, review, or improve one.
- Treat files under `docs/` as references, not automatic instructions.
