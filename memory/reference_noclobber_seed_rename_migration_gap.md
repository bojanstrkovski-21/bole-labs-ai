---
name: reference_noclobber_seed_rename_migration_gap
description: "a \"seed a default config file only if it doesn't already exist\" install step is correct for a fresh install but silently leaves stale/default content instead of real user data when the deploy path itself gets renamed — has to be migrated by hand"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-22T14:27:35.780Z
---

A common install-time pattern is `test -f "$dest" || cp default "$dest"`
(seed a starter config only if nothing's there yet, never clobber real
customization on a repeat install). This is correct for its intended case
but has a blind spot: if the *deploy path itself* changes (a project
rename, a version-bump that changes the config directory name, etc.), the
new path has never had anything installed to it before, so the seed step
faithfully installs the generic default — with no awareness that an
*old-named* directory sitting right next to it holds real, live-customized
versions of the exact same files. Nothing errors; the install "succeeds";
the user just silently loses their real settings back to defaults (a
theme, a hand-edited keybinds file, a chosen wallpaper/display config all
reverted). The fix is procedural, not a code change to the seed logic
itself (which is doing its job correctly for what it knows): after any
rename/path-migration, explicitly `diff` every no-clobber-seeded file
against its old-path counterpart and manually copy over anything that
differs from the generic default, before considering the migration
complete. Found live in [[project_dwm-quickshell]]'s chadwm-boki→
chadboki-qswm rename — `hotkeys.conf`, `theme-colors.conf`,
`screen-layout.sh`, and `wallpaper-layout.sh` were all caught this way.
