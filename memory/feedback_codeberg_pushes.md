---
name: feedback-codeberg-pushes
description: "User authenticates and pushes git remotes themselves (any host: Codeberg, GitHub, ...), not Claude"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d24addad-e30c-4c35-acd3-8a49d16a3360
---

**Reconfirmed 2026-08-09, generalizes beyond Codeberg:** same pattern hit
again setting up `~/.agents`' GitHub remote (`origin` ->
`github.com/bojanstrkovski-21/bole-labs-ai`) — Claude added the remote and
renamed the branch (both asked/confirmed first), then reached for `gh auth
status`/credential-helper commands to push, and was stopped: "no ill do it
with my scripts." This is not Codeberg-specific; treat it as the default for
any remote host.

When a new project needs to be created and pushed anywhere, the user
prefers to create the repo and run the push themselves from their own
terminal, rather than handing Claude a token or setting up SSH/credential
auth in this sandbox.

**Why**: this sandbox's shell has no working SSH auth for codeberg.org
(confirmed: `ssh -T git@codeberg.org` → permission denied, no ssh-agent, no
`CODEBERG_TOKEN`) — see [[reference_codeberg_conventions]]. Rather than
walking through setting up a token/SSH just for the agent, the user says
"I'll do it myself" and reports back once done.

**How to apply**: prepare everything up to the push (git init/remote
add/branch rename, commit, `set-git-cred.sh`/`push.sh` scripts pointing at
the right repo name/URL) with each step confirmed first — then stop and
either ask how they want to authenticate, or just don't run the push/auth
step at all if a "do it myself" pattern is already established for this
user. Don't assume push access exists in this sandbox for any host. If they
push themselves, trust their report; don't try to verify via `git fetch`
since it may fail on auth in this sandbox (not a sign the push didn't
happen).

**Standing rule (explicit, 2026-07-12; reconfirmed 2026-08-09 across a
different project and a different host):** never run git push, and don't
reach for credential/auth setup commands (`gh auth`, credential helpers,
SSH agent), myself — the user handles authentication and pushing everywhere,
with their own scripts. This is global, not scoped to one project or one git
host. Still fine to do the local, non-network parts (init, add remote,
rename branch, commit) once each is confirmed. Always remind them to push
whenever there's uncommitted or unpushed work, especially at natural
stopping points (end of a work session, after a batch of file writes) —
don't wait for them to ask.
