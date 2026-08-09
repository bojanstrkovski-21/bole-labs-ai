---
name: reference-push-sh-branch-detection-bug
description: push.sh template has a latent bug picking main vs master by grepping the remote URL
metadata:
  type: reference
---

The `push.sh` git-bootstrap template (used across ~20 of the user's repos,
see [[reference-repo-setup]]) decides whether to `git push -u origin main`
or `...master` by grepping `remote.origin.url` for the literal substring
"main"/"master" — not by checking the actual current branch name. If the
repo name itself doesn't contain either word (e.g. `bole-labs-ai`), both
checks fail silently and `git push` never runs, even though `git commit`
already succeeded. Fixed in `~/.agents/push.sh` on 2026-08-09 by switching
to `git rev-parse --abbrev-ref HEAD`. Other repos' copies of this template
have not been checked/fixed — same bug is likely latent there too.
