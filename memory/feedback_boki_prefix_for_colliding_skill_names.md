---
name: feedback_boki_prefix_for_colliding_skill_names
description: "When a new skill name collides with an existing public skill or with a tool-shipped official skill, prefix it with boki- (boki-code-scout, boki-omarchy)"
metadata:
  type: feedback
---

Own skills whose natural name already exists elsewhere get the `boki-` prefix: `code-scout` exists as a public GitHub skill, so it became `boki-code-scout`; Omarchy installs its own official skill named `omarchy`, so ours is `boki-omarchy`.

**Why:** two skills with the same directory name fight over the same install path in `~/.claude/skills`, `~/.agents/skills` and the other agents' dirs, and a tool-shipped skill is version-matched and would silently shadow or be shadowed.

**How to apply:** before naming a skill, check the name against GitHub and the skills.sh index and against skills that a tool installs by itself; use `boki-` on a collision. See the skill inventory in `docs/SKILLS.md`.
