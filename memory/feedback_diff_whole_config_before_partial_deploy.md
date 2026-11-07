---
name: feedback_diff_whole_config_before_partial_deploy
description: "Before deploying part of a Quickshell config, diff the whole config against the live one and lint the post-deploy tree with Qt6 qmllint; a missing property fails the whole reload and the old config silently keeps running"
metadata:
  type: feedback
---

Never copy a hand-picked subset of QML into a live Quickshell config without diffing the *entire* config against the live one first, and deploy files that depend on each other together (or use `dwm-quickshell-setup run-update-desktop`).

**Why:** on 2026-11-07 four files were copied to `~/.config/quickshell/`. One of them, `drawer/DrawerWindow.qml`, was repo work from 2026-10-31 that needed a newer `core/ClickAwayPopup.qml` (`screenWidth`, `anchorX`, `anchorY`). Quickshell logged `Failed to load configuration ... Cannot assign to non-existent property "screenWidth"`, kept the old config in memory, and fixing the files did not trigger a retry (only `restart-quickshell` loaded cleanly). I had checked only my own edits, not the live copy; this machine's live config lagged the repo by 13 files.

**How to apply:** (1) `diff -rq` the repo config against live; (2) lint the post-deploy tree with the Qt6 `qmllint` helper (`quickshell-qmllint`) and treat `[missing-property]` as a blocker (it flags exactly this incident, see [[reference_qt6_qml_tools_path]]); (3) read the log by instance (`quickshell log -i <id>` or `--pid`; plain `quickshell log` matches the display string literally, so `:0.0` misses `x11/:0`) and look for `Reloading` then `Configuration Loaded` with no `ERROR`; (4) after a failed reload, restore, check offline, restart. Related: [[project_vm_staged_script_install]], [[reference_quickshell_hot_reload_new_inline_component_fails]].
