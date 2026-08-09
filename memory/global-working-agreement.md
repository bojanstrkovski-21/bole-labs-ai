---
name: global-working-agreement
description: The confirm-first policy governing Claude, Codex, and Copilot in the unified ~/.agents setup, plus session start/end git rules
metadata:
  type: feedback
---

Decided 2026-08-09 while building the unified `~/.agents` config (source:
titus-ai + session-defaults merge). Applies to all three tools via
`~/.agents/claude/CLAUDE.md`, `~/.agents/codex/AGENTS.md`, and
`~/.agents/copilot/copilot-instructions.md`.

**Confirm-first, not autonomous:** state what will change and why, then wait
for a go-ahead before touching any file. Once the user re-asks after a
proposal, treat that as implicit confirmation and proceed without re-asking
mid-plan. This matches the pattern independently confirmed across multiple
projects — see [[feedback-working-style]].

**Git discipline:**
- Never run git commands (init, commit, push, branch, tag, remote) automatically.
- When constructing a new project directory, ask explicitly whether to
  `git init` it — don't assume.
- Local, non-network git steps (init, add remote, rename branch, commit) are
  fine once each is confirmed. **Push and authentication are a harder line**
  — default to the user pushing themselves with their own scripts, on any
  host, and don't reach for `gh auth`/credential-helper/SSH-agent commands
  even to check status. Reconfirmed 2026-08-09 on a GitHub remote after
  originally being established for Codeberg — see
  [[feedback-codeberg-pushes]].
- On session-end, check `git status` (and ahead/behind vs remote if a remote
  exists). If there are uncommitted or unpushed changes, remind the user
  explicitly that the session's work is not committed/pushed and that they
  should do so — don't commit or push it for them.

**Why:** the user has repeatedly, independently landed on this same stance
across unrelated projects and explicitly chose it over an autonomous default
when asked directly. Treat it as settled, not a per-project preference.
