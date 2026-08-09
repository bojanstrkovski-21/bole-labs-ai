---
name: reference-repo-setup
description: Where this project is hosted and how the user publishes changes
metadata: 
  node_type: memory
  type: reference
  originSessionId: 43779ef8-f1e0-457e-af7b-8b6e0fa24172
---

GitHub remote: `git@github.com:bojanstrkovski-21/arch-boki-logout.git`
(origin, both fetch/push). Default branch in use locally: `master`.

Two helper shell scripts at the repo root (boilerplate from an ArcoLinux
tutorial template, user-authored repo otherwise):
- [set-git-cred.sh](set-git-cred.sh) — one-time setup: sets global git
  user.name/user.email, pull.rebase false, push.default simple, and points
  `origin` at this repo via SSH. Not something to re-run casually since it
  sets *global* git config and `sudo git config --system core.editor nvim`.
- [push.sh](push.sh) — interactive commit+push helper: `git pull`, `git add
  --all .`, prompts for a commit message on stdin, commits, then pushes to
  main or master (whichever the remote config mentions). This is the user's
  own manual publish flow; do not invoke it non-interactively or replace it
  with direct git commands unless asked.

See [[project-overview-arch-boki-logout]] for what the project itself does.
