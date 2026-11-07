# Omarchy development and contributing (v4.5.0)

Adapted in our own words from Omarchy's `AGENTS.md`, `agents/skills/*.md`, and
`default/agents/skills/omarchy/contributing.md` (omacom/omarchy v4.5.0, MIT). For
changes to Omarchy itself. For configuring an install, use `customization.md`.
The repository's own `AGENTS.md` is the authority; read it first.

## Reporting a bug or suggesting a change

- Verified bugs go to GitHub issues (not support questions). Feature ideas go to
  the repository's Discussions "suggestions" category. "Is this a bug?" and
  support questions go to the community Discord.
- Gather: `omarchy version`, and `omarchy debug --no-sudo --print` (also written
  to `/tmp/omarchy-debug.log`). The interactive `omarchy debug` can upload the log
  and print a shareable URL.
- Capture the problem on screen (a short recording or screenshot, see
  `customization.md`). `gh` cannot upload media: save the capture and hand the
  user the path to attach in the web form.
- Include what happened, what was expected, steps to reproduce, system details,
  the log, and the capture. Filing with `gh issue create` is an external write:
  ask first.

## Submitting a PR

- Never develop against `/usr/share/omarchy`. Fork and clone a working copy.
- Follow the repository's `AGENTS.md` for style, tests, and commits. Keep commits
  atomic and succinct, run the full test script before pushing, and include
  before/after captures for visual fixes. Pushing and opening the PR need the
  user's go-ahead (our global git rules).

## Conventions worth knowing

- Bash style: `#!/bin/bash` shebangs (not `env bash`); `[[ ]]` for string and file
  tests, `(( ))` for numeric tests; quote strings with spaces instead of escaping;
  full `if`/`else` for two-path flow. Scripts under `install/` and `migrations/`
  are sourced and omit shebangs.
- Commands are named `omarchy-<group>-<action>`; the router lists user-facing
  groups. Do not duplicate the group list elsewhere.
- Use helper commands instead of raw tools: `omarchy-pkg-add`/`omarchy-pkg-drop`
  (not raw `pacman`), `omarchy-notification-send` (not `notify-send`),
  `omarchy-cmd-present`/`-missing`. Commands from the default package set are
  invariants: call them directly without presence checks.
- Use `$OMARCHY_PATH` and `$OMARCHY_INSTALL` rather than hard-coded paths.
- Gate platform code on `omarchy-hw-platform` predicates, not `uname -m`.

## Command metadata

Commands in `bin/` declare CLI metadata in comments within the first 80 lines.
Keys: `# omarchy:group=`, `name=`, `summary=` (short help), `args=` (usage),
`examples=` (separated by ` | `, only where args need explaining), `alias=`,
`hidden=true`, `requires-sudo=true`. Prefer explicit metadata for user-facing
commands; tests expect it to stay valid.

## Declaring a managed tool (mise)

Default tools live in `etc/mise/conf.d/omarchy-tools.toml`; Omarchy never writes
the user's `~/.config/mise/config.toml`. Use a registry shorthand (check with
`mise registry <name>`), not an explicit `github:` or `aqua:` backend, and set
`lazy = true` so the first use installs it:

```toml
[tools]
codex = { version = "latest", lazy = true, minimum_release_age = "0s" }
```

If the registry has no entry, request one upstream before adding the tool. After
changing declarations, test in an isolated environment that shims are created and
that first-use installation works, not only an already-installed tool.

## Install scripts and migrations

- Install leaves are sourced (no shebang), avoid `exit`, and are idempotent.
  Per-user setup lives under `install/user/`; root-scoped hardware setup under
  `install/hardware/`.
- Migrations are one-time repair scripts for existing installs, run as the user by
  `omarchy-migrate` after updates. Completion is tracked per user. They must be
  idempotent: a machine-wide repair already applied by another user must no-op.
  At login a notifier only reports pending migrations; it never runs them silently.
