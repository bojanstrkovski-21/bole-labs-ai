---
name: reference-codeberg-conventions
description: User hosts personal projects on Codeberg (not GitHub) with a standard bootstrap pattern of scripts/CLAUDE.md/memory folder
metadata: 
  node_type: memory
  type: reference
  originSessionId: d24addad-e30c-4c35-acd3-8a49d16a3360
---

User (bojanstrkovski-21) hosts personal git projects on **Codeberg**
(codeberg.org), not GitHub. Known repos:
- `bojanstrkovski-21/git_init_first_time` — original PowerShell bootstrap
  template (Windows-oriented: git init + initial commit + create/reuse repo
  via Codeberg API + Git Credential Manager + push).
- `bojanstrkovski-21/archboki-doom-emacs-config` — the user's actual Doom
  Emacs config, pushed via SSH remote (`git@codeberg.org:...`) using bash
  scripts (`push.sh`, `set-git-cred.sh`), not the PowerShell ones. `push.sh`
  is adapted from an ArcoLinux/Erik Dubois template: pull, add --all,
  interactive commit message prompt, push to whichever of main/master is
  checked out.
- `bojanstrkovski-21/archboki-doom-emacs-project` — this repo; comparison of
  Doom Emacs vs Spacemacs (see [[project_doom_vs_spacemacs]]).

Convention across all of these: repo name = containing folder's leaf name.
Every project gets a `CLAUDE.md` (session rules: read `memory/PROJECT.md` at
start of session) and a project-local `memory/PROJECT.md` (not to be
confused with Claude's own cross-session memory system) tracking status.

This machine (Arch Linux) has **no SSH auth configured for codeberg.org** —
`~/.ssh/config` only has a `Host github.com` block (key
`~/.ssh/boki-ssh-key-2025`), no ssh-agent running by default, and no
`CODEBERG_TOKEN` env var. The user prefers to handle Codeberg auth and
pushes themselves from their own terminal rather than having Claude push —
see [[feedback_codeberg_pushes]].
