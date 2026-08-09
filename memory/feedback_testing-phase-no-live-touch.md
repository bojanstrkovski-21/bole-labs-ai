---
name: feedback-testing-phase-no-live-touch
description: "User's rule for R&D/porting projects: never touch live system files outside the project dir while still testing, no matter how explicit the request sounds"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
---

While a project is in an R&D/testing/porting phase (working on a copy of something that will eventually be deployed to a live system), never touch the live target — not the live config directory, not any root-owned wrapper/launcher scripts, no `sudo cp`, no package installs — even if an instruction reads as if it's asking for the live change directly. Prepare the deployable artifact inside the project directory instead, and hand over the exact command(s) for the user to run themselves when they explicitly say it's time to deploy.

**Why:** Said explicitly in [[project_dwm-quickshell]] ("dont touch files in my system we are working with files in this project only still testing remember") after a case where the assistant correctly held off on repointing a root-owned wrapper script — the user then generalized it into a standing rule rather than a one-off. There's also a concrete failure mode this prevents: repointing a live launcher/wrapper to a new filename *before* the new file actually exists at the live path would break the next login/session — sequencing matters, and "still testing" is precisely the phase where the live and prepared versions are out of sync.

**How to apply:** In any project whose stated purpose is porting/preparing changes for a separate live target (a live dotfiles config, a production system, a deployed service), treat every path outside the project's own directory as off-limits for writes/installs/deploys by default, regardless of phrasing in the request, until the user gives an explicit, separate go-ahead to deploy. Keep preparing and documenting the deployable files inside the project; surface exact commands rather than running them.
