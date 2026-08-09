---
name: feedback-toml-over-json
description: Prefer TOML over JSON for hand-edited config/preset files this user maintains
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 7c2f9ced-6117-47e1-9428-1c59460af66c
  modified: 2026-07-21T16:13:20.792Z
---

For config or preset files a non-programmer user hand-edits directly (not machine-generated-and-consumed-only data), prefer **TOML over JSON**.

**Why:** JSON has no comment support, which matters when a file stores opaque values (hex colors, magic constants) the user needs to annotate to remember what each key means. JSON is also less forgiving to hand-edit — a stray trailing comma breaks the whole file. TOML supports `# comment` lines, expresses flat/sectioned key-value data (`[section]` tables) more naturally than nested `{}`, and Python 3.11+ reads it with the stdlib `tomllib` (no dependency needed for read; writing flat TOML doesn't need a library either since it's simple key=value text).

Confirmed in [[project-celestial-theme-builder]]: recommended TOML for the color-preset schema, user agreed ("ok lets do it in toml then").

**How to apply:** Default to TOML for any new hand-maintained config/preset file for this user, unless the consuming tool specifically requires JSON (e.g. a JS-only frontend with no TOML parser) or YAML's extra structure (deep nesting, anchors) is actually needed.
