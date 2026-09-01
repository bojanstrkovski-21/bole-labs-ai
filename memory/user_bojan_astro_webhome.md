---
name: user-bojan-astro-webhome
description: Who Bojan is and how he works on the astro-webhome project
metadata:
  type: user
---

Bojan (bojanstrkovski.21@gmail.com, GitHub `bojanstrkovski-21`) owns and personally maintains `astro-webhome`, a personal bookmark/dashboard homepage (Astro, deployed to Cloudflare Pages). He works on it solo — pushes go straight to `main`, no PR/review workflow.

He iterates on UI/CSS changes conversationally, one small visual tweak at a time (e.g. "decrease that gap by half", "center titles", "remove those lines") rather than describing a full spec up front. Expect a design to evolve through many short corrective turns on a single theme before he asks to port it elsewhere — see [[feedback-scope-then-mirror-themes]].

He notices when a claimed fix didn't actually work and says so plainly ("why are you not removing it") — worth double-checking CSS selectors actually hit the intended DOM element before reporting a visual fix as done, see [[feedback-verify-css-selectors-hit-real-dom]].

He runs Windows, uses PowerShell scripts (e.g. `git-push.ps1`) for repo workflows, and already has Git Credential Manager configured and working for GitHub auth — don't assume manual token entry is needed for git operations in this repo.
