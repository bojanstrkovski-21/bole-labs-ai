---
name: feedback-git-security-discipline
description: "User's standard git/file-safety rules: never auto-git, confirm everything, never write secrets to a file in the repo"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
---

Rules observed consistently across this user's projects (`git_init_first_time`, `session-defaults`, `archboki-doom-emacs-project`, `archboki-doom-emacs-config`), and applied again to [[project_dwm-quickshell]]:

- Never run git commands (status is fine to inspect, but commit/push/branch/tag) unless the user explicitly asks.
- Never suggest committing, pushing, branching, or tagging on your own initiative.
- When a commit/push *is* requested: show `git status`, get explicit confirmation of the file list and commit message before running anything. Never force-push. Never amend a published commit. Never create tags unless asked.
- Ask before creating any new file; prefer editing existing files. Don't over-engineer — no unrequested comments, docstrings, or error handling.
- **Never write credentials, tokens, or secrets into any file in a project repo, even a scratch/junk-looking one.** Prompt-only or an environment variable outside the repo, never a file.

**Why:** The security rule has a real incident behind it — in `git_init_first_time`, a plaintext Codeberg access token was saved to `codeberg_stuf.txt` in the project root (the user put it there themselves, outside any script), got committed via a `push.sh` that ran `git add -A`, and was pushed to the public remote before being caught. The user had to revoke the token. A later project (`archboki-doom-emacs-config`) had a similarly-named `stuf.txt` file flagged proactively as a possible repeat — that one turned out to be harmless placeholder junk, confirmed by the user, but the flag-it-first instinct is the right one.
**How to apply:** Treat any file in a user project whose content looks like a bare token/hash/credential as worth flagging before assuming it's fine, even if the filename looks like junk. Never add a "skip the prompt, reuse a cached token" convenience feature for credential-handling scripts — the user explicitly declined that once, preferring the script to ask every time since it's meant to be a rare, one-time-per-project step.

**Known environment limitation**: this sandbox has no working Codeberg auth — HTTPS push fails with "could not read Username" (no credential helper) and SSH fails with "Permission denied (publickey)" (no usable key/agent here). Confirmed independently in at least two projects (`archboki-doom-emacs-project`, `dwm-quickshell`). Don't spend time debugging this or trying workarounds — `git init`/`add`/`commit`/`remote add` all work fine locally; only the final `git push` needs to happen from the user's own terminal. Tell them the exact command and stop there.
