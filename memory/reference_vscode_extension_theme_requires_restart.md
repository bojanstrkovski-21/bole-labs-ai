---
name: reference-vscode-extension-theme-requires-restart
description: "A VS Code theme shipped as a fake/local extension needs a full window reload to take effect on every switch — extensions and their contributed themes are scanned once per session. workbench.colorCustomizations/editor.tokenColorCustomizations in settings.json apply live instead, with no reload."
metadata:
  type: reference
---

VS Code scans an extension's `package.json` (including its
`contributes.themes` list) **once per session**, at startup/activation.
Rewriting that same extension's manifest on disk while VS Code is still
running — even bumping its `version` field specifically to defeat the
theme-registry cache, and even pointing `workbench.colorTheme` at a
brand-new theme label each time — is invisible to the already-running
window. Nothing short of "Developer: Reload Window" or a full
close/reopen makes it pick up the change. No external CLI/API exists to
trigger "Reload Window" from outside VS Code itself (confirmed via
`code` CLI docs and a search of forum/issue threads — no supported remote
trigger as of 2026-10). This is the actual root cause behind "VS Code
doesn't update live, I have to reopen it" for any script-generated theme
using the fake-extension technique (the one Omarchy's own
`omarchy-theme-set-vscode` uses).

**Better mechanism, confirmed via VS Code's own current theming docs
(code.visualstudio.com/docs/configure/themes)**: `workbench.
colorCustomizations` and `editor.tokenColorCustomizations` are plain
`settings.json` keys, and settings.json edits apply live with zero
reload — because they're read on every settings change, not scanned once
like extensions. They also apply *on top of* whatever theme is currently
active, rather than requiring you to own/switch to a whole fake theme
identity — a better fit whenever the real goal is "recolor to match an
external palette," not "register a real selectable theme."

If `settings.json` itself is JSONC (comments/trailing commas — common,
e.g. a user-added comment), a plain `jq '.key = $value'` call will
silently fail to parse it and no-op every time; see
[[reference_json5_jsonc_tool_parsing_silent_noop]] for the general
version of that pitfall and the brace-depth-aware text-replacement
workaround that doesn't require a JSON5 parser dependency.
