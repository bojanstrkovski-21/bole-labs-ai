---
name: feedback-sync-project-memory-mirror
description: This project keeps a visible mirror of the memory system at memory/ in the repo root — keep both copies in sync on every write
metadata:
  type: feedback
---

Bojan asked for a full copy of Claude's persistent memory for this project to live in the repo itself, at `memory/` in the project root (`d:\My Backups\Bojan\astro-webhome\memory\`), mirroring the hidden per-project memory store at `C:\Users\User\.claude\projects\d--My-Backups-Bojan-astro-webhome\memory\`.

**Why**: he wants the memory visible/versionable alongside the code (e.g. so it can be reviewed, committed, or read without digging into the Claude Code app-data folder), not just tucked away in the tool's own storage.

**How to apply**: Whenever writing, editing, or deleting a memory file for this project, mirror the exact same change to `memory/` in the project root — same filenames, same content, same frontmatter. The `memory/MEMORY.md` index must also be kept in sync between the two locations. This applies to future sessions too, not just the one where this was requested — check `memory/` in the repo root exists and matches before assuming it's stale. The project-root copy is not git-tracked/committed automatically; only commit it if explicitly asked.
