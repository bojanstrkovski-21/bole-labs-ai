---
name: reference-vscode-claude-code-terminal-relaunch-prompt
description: "Claude Code's VSCode extension makes VSCode prompt to relaunch the integrated terminal on every launch — fix with two terminal.integrated settings"
metadata:
  type: reference
---

**Symptom**: every time Claude Code is launched inside VSCode's integrated
terminal, VSCode pops a "relaunch terminal" prompt.

**Cause** (confirmed via GitHub issues
anthropics/claude-code#3301 and #55486, no official Anthropic fix as of
2026-10): the Claude Code VSCode extension injects environment variables
into the integrated terminal (reportedly `CLAUDE_CODE_SSE_PORT` among
others) and picks a fresh random port + auth token on every activation.
Any terminal already open, or restored/reattached from a previous VSCode
session, sees stale env values against the new activation, so VSCode asks
to relaunch it.

**Fix that worked** (confirmed on this user's machine, 2026-10-10): add to
VSCode's `settings.json` (`~/.config/Code/User/settings.json` on Linux):

```json
"terminal.integrated.environmentChangesRelaunch": false,
"terminal.integrated.enablePersistentSessions": false,
"terminal.integrated.hideOnStartup": "always"
```

`environmentChangesRelaunch: false` alone was tried first and did **not**
stop the prompt. Adding `enablePersistentSessions: false` (stops VSCode
reattaching old terminal sessions across a reload — the actual trigger for
the stale-env mismatch) + `hideOnStartup: "always"` together fixed it.
Requires a full VSCode **restart** (not just "reload window") to take
effect, since persistent-session behavior is set up at startup.

**Trade-off**: `enablePersistentSessions: false` means terminal
tabs/history don't survive a VSCode reload — each reload starts fresh
terminals instead of reconnecting to old ones.
