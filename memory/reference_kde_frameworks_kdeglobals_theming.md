---
name: reference-kde-frameworks-kdeglobals-theming
description: "Apps linking KDE Frameworks (kcolorscheme/kconfigwidgets -- Kate, Dolphin, etc.) theme from kdeglobals' own ColorScheme key and .colors scheme files, not qt5ct/qt6ct's QPalette"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-06T19:55:39.933Z
---

A plain Qt app (no KDE Frameworks dependency -- confirmed live with
`qt5ct` itself and `vlc`) correctly picks up a custom qt5ct/qt6ct
`QPalette` (via `custom_palette=true`/`color_scheme_path=`) automatically,
no extra steps.

Apps that link KDE Frameworks components (`kcolorscheme`,
`kconfigwidgets`, etc. -- e.g. `kate`, `dolphin`) do **not** read that
palette the same way. They theme themselves from a separate mechanism:
`~/.config/kdeglobals`'s own `[General] ColorScheme=<name>` key, pointing
at a `.colors` scheme file (format differs from qt5ct's `colors.conf`)
under `~/.local/share/color-schemes/`. With no `ColorScheme=` key set at
all, these apps fall back to KDE's own Breeze default, independent of
whatever qt5ct/qt6ct/Fusion is configured to do.

Practical implication: if a qt5ct-based custom palette "isn't working,"
check whether the test app actually links KDE Frameworks before assuming
the qt5ct setup itself is broken -- test against a plain Qt app (no KF
dependency) first to isolate which layer is actually failing. Theming KDE
Frameworks apps too requires a separate generator targeting `kdeglobals`
+ a `.colors` file, not an extension of the qt5ct/qt6ct work.

See [[reference_qt_custom_palette_needs_fusion_style]] for the qt5ct/
qt6ct side of this.
