---
name: reference-json5-jsonc-tool-parsing-silent-noop
description: "Many real app config files (Zed settings.json, Sublime Text Preferences, VS Code settings.json) are JSONC/JSON5 (comments and/or trailing commas) by default, not strict JSON — jq and other strict-JSON tools silently fail to parse them, so a `jq '.key = $value' file` call no-ops every time with no visible error unless stderr is checked"
metadata:
  type: reference
---

Confirmed live across multiple real apps' own self-generated default
config files, not assumed:
- **Zed's** `~/.config/zed/settings.json` ships with a leading `//`
  comment banner and trailing commas by default (e.g. `"dark": "One
  Dark",` before a closing `}`).
- **Sublime Text's** self-generated `Preferences.sublime-settings` has a
  trailing comma after the last array element by default (e.g. after
  `"ignored_packages": ["Vintage",]`).
- **VS Code's** `settings.json` supports `//` comments too (JSONC), though
  a fresh/GUI-edited one is often strict JSON in practice.

`jq` (and any strict-JSON parser) rejects all of these outright. A script
doing `jq --arg v "$x" '.key = $v' "$file" > tmp && mv tmp "$file"` will
have the `jq` call fail, `$tmp` end up empty/missing, and (depending on
how the failure is handled) either silently no-op or leave the target
file unchanged — with the bug only visible by checking `jq`'s exit code
or stderr, not by visual inspection of the script's logic.

**Fix that doesn't require a JSON5 parser dependency**: a small
brace-depth-aware `awk` text replacer that finds a top-level `"key":
<value>` entry (tracking `{`/`}` nesting via `gsub` to handle a
multi-line/nested value, e.g. Zed's own `"theme": {mode, light, dark}`
object) and replaces just that span, leaving every comment and all other
keys untouched. Falls back to inserting a new `"key": value,` line right
after the file's first bare `{` when the key doesn't exist yet. This
preserves the file's own comments/formatting instead of stripping them
(which a strip-then-reparse-as-JSON approach would do), and needs no new
runtime dependency beyond `awk`/`grep`, already present everywhere `jq`
itself would be.

See [[reference_vscode_extension_theme_requires_restart]] for one real
context this bit (a VS Code `settings.json` theming script).
