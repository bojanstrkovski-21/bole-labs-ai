---
name: feedback-mirror-memory-in-project-root
description: In every project, keep a visible copy of Claude's per-project memory at memory/ in the project root and keep both in sync
metadata:
  type: feedback
---

Bojan wants the per-project memory (Claude's hidden store under `~/.claude/projects/<project>/memory/`) mirrored in a `memory/` folder in the project root, same as astro-webhome ([[feedback-sync-project-memory-mirror]]). Asked again for the Mame project on 2026-11-01 ("same as for every project we work on"), so treat it as the default for all projects, not a one-off.

**Why:** he wants the memory readable and versionable next to the project files, not tucked away in the tool's app data.
**How to apply:** at the start of a project that has no `memory/` in its root, create it. Whenever writing, editing or deleting a project memory file, make the identical change in both places (same filenames, content, frontmatter, and `MEMORY.md` index). Do not commit it unless asked. Also keep a short project doc (`PROJECT.md`, from `~/.agents/docs/PROJECT.template.md`) with Current State, Next Steps and Recent Work.
