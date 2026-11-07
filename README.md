# ~/.agents

Single source of truth for Bojan's coding-agent setup, shared across Claude
Code, Codex, and GitHub Copilot. Built 2026-08-09 by merging `titus-ai`
(Codex config) and `session-defaults` (Copilot config) with Claude's own
per-project memory.

## Install

Keep this repository checked out at `~/.agents`: installed links point into it,
so a `git pull` updates every linked skill and instruction file immediately.

```bash
git clone https://github.com/bojanstrkovski-21/bole-labs-ai.git ~/.agents
cd ~/.agents
./scripts/validate.sh        # optional: checks skills, TOML, shell, and the installer
./install.sh --dry-run       # preview the links it would create
./install.sh
```

- Run `install.sh` from `~/.agents`, not from another checkout. It treats the
  folder it lives in as the source and would repoint existing links there.
- Claude Code: links `~/.claude/CLAUDE.md` and every skill into
  `~/.claude/skills/`.
- Grok, Gemini, Copilot: skills are linked into each tool's skills directory
  when that tool's config directory exists. Add `--create-missing` to also
  create the directory and links for tools that are not installed yet
  (`./install.sh --create-missing`; combine with `--dry-run` to preview).
- Codex: instructions, rules, and profiles are linked once `~/.codex` exists
  (or created with `--create-missing`);
  `config.toml` is copied only when absent and never overwritten. Codex reads
  skills from `~/.agents/skills` directly.
- Rerunning is safe: correct links are skipped, and anything in the way is
  moved to `~/.claude/backups/agents-install-*` first.

After pulling updates, rerun `./install.sh` only when new skills or supported
tools were added; existing links already see the new file contents.

## Layout

- `skills/<name>/SKILL.md` — 21 reusable skills, agent-agnostic. This is
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
- `codex/` — own Codex instructions, command rules (`rules/default.rules`,
  enforcing the git and auth policy), local-model profiles, and a minimal
  `config.toml` (seeded once, never overwritten). Dormant until Codex is
  installed; `install.sh` links them once `~/.codex` exists. Structure
  inspired by titstack; see Acknowledgments.
- `copilot/` — ported from session-defaults, plus `set-git-cred.sh`/`push.sh`
  (the user's standard git bootstrap scripts, used in ~20 of their projects).
  Copilot has no user-global instructions file, so this whole directory is
  consumed via `install.sh new-project` instead of a symlink.
- `install.sh` — idempotent installer (same backup-then-symlink pattern as
  titus-ai's) plus a `new-project` bootstrap command that also fills in and
  copies `set-git-cred.sh`/`push.sh`.
- `install.sh` flags: `--dry-run` previews; `--create-missing` also creates the
  config dir and skills links for skills-only tools that are not installed yet
  (Grok, Gemini, Copilot) and for Codex. Skills-only tools are listed in
  `SKILLS_ONLY_TOOLS` at the top of the script.
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

- **Omarchy v4.5.0 scan, split by skill** (pinned to tag v4.5.0, repo `omacom/omarchy`;
  `basecamp/omarchy` redirects there). Read so far and already applied: `AGENTS.md`,
  `CLAUDE.md`, `motion.md`, `shell-dev.md`, `visual-verification.md`.
  - `find-skills` (skills and agent instruction files: find, vet, adapt rules):
    unread dev guides `agents/skills/{command-metadata,install-scripts,mise-tools,migrations,icon-font,acceptance-tests}.md`;
    user skills `default/agents/skills/omarchy/{hyprland,plugins,hooks,capture,contributing}.md`,
    `omarchy-app/SKILL.md`; the rest of Emil Kowalski's skills (`review-animations`,
    `animation-performance`, `break-ui`); the unread `house-skills` and `omarchy-plugin-marketplace`
    listings. The GitLab, Codeberg, Bitbucket, and open-web recipes were run on 2026-11-07
    (topics: Astro, Bash, Quickshell, Python) and the lessons written into the skill.
    Not yet applied: the extra `diagnose-crash` ideas for `linux-sysadmin`/`podman-operator`.
  - `boki-code-scout` (source code study, untested): system reference `docs/{omarchy-shell,file-layout,
    update-process,testing,menu,notifications,regions,i18n}.md` and `docs/theming.md` in full; QML under
    `shell/` (`Commons/Style.qml`, `Color.qml`, `Ui/KeyboardPanel.qml`); theme files and
    `default/themed/*.tpl`; and the design repos `omarchy-theme-registry`, `omarchy-theme-marketplace`,
    `aether`, `omarchy-theme-sync`, `omarchy-site-crt`, `omarchy-osaka-jade-theme` (all MIT) plus
    `omarchy-site` (no license: reference only). `oligarchy-tests.md` exists only on a newer commit.
  - `boki-code-scout` hostile-file test 2026-11-07 passed (a crafted repo with seven injection attempts; canary
    file, `~/.bashrc`, git remotes and `~/.cache` unchanged; not blind, since the same agent wrote and studied it).
  - `boki-code-scout` was tested 2026-11-07 (T1-T5, all passed): Omarchy motion docs against
    `Style.qml` and its test, a repo with its own `AGENTS.md` (read as data), a licensed and an
    unlicensed Quickshell repo, a large Astro repo without cloning, and the Cloudflare adapter
    change (dropped Pages in `@astrojs/cloudflare` 13.0.0). Lessons are in the skill.
- ~~`quickshell-qmllint` exited 255 silently on a live-config copy~~ — resolved 2026-11-07: the bare `qmllint` here is
  the Qt 5 binary (`qmllint 1.0`). The helper now prefers Qt 6 locations and skips `1.x`; with it, the 2026-10-23
  `ClickAwayPopup` + current `DrawerWindow` mismatch reports `[missing-property]`, and a consistent tree is silent.
  See `skills/quickshell/references/linting.md`.
- **Qt QML skills vetted 2026-11-07** (`theqtcompanyrnd/agent-skills`, BSD-3-Clause option): all six read;
  rules, performance triage, and a review procedure adapted into `quickshell`. Not adopted: `qt-qml-docs`;
  deferred: `qt-qml-profiler` (use on a shell needs checking), `qt-qml-test` and `qt-qml-test-run`
  (Qt Quick Test; Quickshell types may need the shell). The Qt linter was audited but not run.
- **Recipe test runs (Astro, Bash, Quickshell, Python), split by skill** (2026-11-07):
  - `find-skills` (vet and adapt): Qt's official `qt-qml`, `qt-qml-review`, `qt-qml-profiler` skills and
    `theqtcompanyrnd/agent-skills`; `anasgets111/dotfiles` Quickshell frontend-design skill; Cloudflare's
    agent-skills docs; `Soborbo/claudeskills` deployment and `siviter-xyz/dot-agent` astroflare skills; an
    Astro static-site AGENTS.md template; Bash skills `rmyndharis` bash-pro, `philoserf` bash-audit,
    `89jobrien` shell-scripting, `thebushidocollective` shell-best-practices; Python skills
    `akmalovaa/python-skill`, `philoserf` python-quality-gate, `beshkenadze` python-uv; forge finds
    (GitLab `agent-skills` projects, Codeberg `paperbyte/agent-skills`, `dominicsayers/my-coding-agent-skills`,
    `x-cmd/skill`; Bitbucket `intlayer/intlayer` and `atlassian/sovereign` AGENTS.md); GitLab's agent-skills
    docs; and the papers on SKILL.md supply-chain risks (vetting input).
  - `boki-code-scout` (source study, parked): Quickshell shells and dotfiles (Codeberg `inerM/quickshell`,
    `kitkat1424/dynamic-pill-quickshell`, `charlesrocket/topbar`, `belim_faux/qsdots`, `blx/blx-shell`,
    `Fel/NoctaliaV5-KdeConnect-plugin`; GitLab `Alucherdi/quickshell`, `Gakuseei/Ricelin`,
    `JonathanTroyer/burrow`); Astro sites (Codeberg `Trombach/astro-homepage`, `DI-Day/website`) and
    Cloudflare's docs repo structure; and checking the Astro 6 Cloudflare adapter (Workers-only?) claim
    against Astro's changelog and source.
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
- ~~`codex/config.toml` is linked as-is~~ — done 2026-11-07: it is now our own
  minimal file, seeded to `~/.codex/config.toml` once and never overwritten or
  linked. Trusted projects are added through Codex itself.
- ~~push.sh's branch-push check grepped the remote URL for "main"/"master"
  instead of the actual branch~~ — fixed 2026-08-09: now uses
  `git rev-parse --abbrev-ref HEAD`. Other repos using this same template
  (~20 of them) likely carry the same latent bug — worth checking if their
  remote URL doesn't literally contain "main"/"master".

## Acknowledgments

Thanks to [Chris Titus Tech](https://github.com/ChrisTitusTech) and
[Erik Dubois](https://github.com/erikdubois) for the neverending
inspiration.

Structure and ideas for skills, validation, and workflow docs are adapted from
[titstack](https://github.com/ChrisTitusTech/titstack) (MIT) and Chris's Astro
[website](https://github.com/ChrisTitusTech/website). Those repositories are
reference clones only; their configuration is not used as-is.

The `boki-omarchy` skill summarizes Omarchy's agent guides (omacom/omarchy v4.5.0, MIT).
The motion, shell-practice, and testing references are adapted in our own words from
Omarchy ([omacom/omarchy](https://github.com/omacom/omarchy), MIT) and Emil
Kowalski's [skills](https://github.com/emilkowalski/skills) (MIT). The QML rules
are adapted from The Qt Company's
[agent-skills](https://github.com/theqtcompanyrnd/agent-skills)
(BSD-3-Clause option, copyright (c) 2026 The Qt Company Ltd.). The
`CLAUDE.md` -> `@AGENTS.md` import pattern is documented in 37signals'
[house-skills](https://github.com/basecamp/house-skills) (MIT).
