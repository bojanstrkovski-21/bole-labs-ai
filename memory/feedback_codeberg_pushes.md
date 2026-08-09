---
name: feedback-codeberg-pushes
description: "User wants to create Codeberg repos and push/authenticate themselves, not have Claude do it"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d24addad-e30c-4c35-acd3-8a49d16a3360
---

When a new project needs to be created and pushed to Codeberg, the user
prefers to create the repo and run the push themselves from their own
terminal, rather than handing Claude a token or setting up SSH auth in this
sandbox.

**Why**: this sandbox's shell has no working SSH auth for codeberg.org
(confirmed: `ssh -T git@codeberg.org` → permission denied, no ssh-agent, no
`CODEBERG_TOKEN`) — see [[reference_codeberg_conventions]]. Rather than
walking through setting up a token/SSH just for the agent, the user says
"I'll do it myself" and reports back once done.

**How to apply**: prepare everything up to the push (git init, commit,
`set-git-cred.sh`/`push.sh` scripts pointing at the right repo name/URL),
then ask how they want to authenticate rather than assuming — offer SSH key,
token, or "you do it" as options. If they choose to push themselves, trust
their report; don't try to verify via `git fetch` in this sandbox since it
will fail on auth (not a sign the push didn't happen).

**Standing rule (explicit, 2026-07-12)**: never run `git add`/`commit`/push
myself in this project — the user handles all git operations via their own
`push.sh`. Instead, always remind them to commit/push (with their script)
whenever there's uncommitted or unpushed work, especially at natural
stopping points (end of a work session, after a batch of file writes) —
don't wait for them to ask. This is a standing instruction, not a one-off.
