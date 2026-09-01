---
name: feedback-clean-up-completed-todos
description: Remove finished items from TODO.md and their related memory entries immediately, rather than leaving checked-off or stale references — TODO.md and memory should always show current state, not history
metadata:
  type: feedback
---

When a `TODO.md` item (repo root) gets implemented, delete its line from `TODO.md` — don't just tick a checkbox and leave it sitting there. Also update or remove any memory entry that referenced it as outstanding/not-yet-done (e.g. `reference_chris_titus_website_repo.md` currently says its three borrowed ideas are "tracked as unchecked boxes in TODO.md" — once one ships, that sentence needs to stop claiming it's still outstanding).

**Why**: Bojan wants `TODO.md` and memory to answer "where are we right now" at a glance, not accumulate a mix of done and not-done items he has to mentally filter. He explicitly asked for this as a standing rule right after the to-do list and its cross-referencing memory entry were created, so it applies to that list from day one, not just future lists.

**How to apply**: Any time you finish work that TODO.md or a memory file references as pending, in the same turn: (1) remove/update the TODO.md line, (2) grep memory for cross-references to that item and fix them too, (3) keep both the tool's own memory store and the `memory/` mirror in the repo root in sync (see [[feedback-sync-project-memory-mirror]]). Git history and commit messages are where "what we did" lives — TODO.md and memory should only describe current/future state.
