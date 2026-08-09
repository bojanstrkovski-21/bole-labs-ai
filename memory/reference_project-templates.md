---
name: reference-project-templates
description: "Where the user's project-bootstrap conventions/templates live (links.txt precedent repos)"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
---

The user tracks four small repos that together define their project-bootstrap conventions (see `links.txt` in a new project's root, or ask):

- `https://codeberg.org/bojanstrkovski-21/git_init_first_time.git` — git/Codeberg bootstrap toolkit + the origin of the token-leak security lesson (see [[feedback_git-security-discipline]]).
- `https://github.com/bojanstrkovski-21/session-defaults.git` — original cross-project bootstrap kit and `PROJECT.md`/session-prompt templates (see [[feedback_session-workflow]]).
- `https://codeberg.org/bojanstrkovski-21/archboki-doom-emacs-project.git` — example of the CLAUDE.md + `memory/PROJECT.md` pattern in an actual Claude Code project (no `.github/prompts`).
- `https://codeberg.org/bojanstrkovski-21/archboki-doom-emacs-config.git` — another live example of the same pattern, hosting the user's real Doom Emacs config.

**Why:** Useful as ground truth if asked to bootstrap another new project the same way, or to check whether these conventions have since changed.
**How to apply:** Before reusing anything from these, re-clone/re-fetch and check dates — they may have moved on since 2026-07-16 when this was last reviewed (for [[project_dwm-quickshell]]).
