---
name: reference-qt-custom-palette-needs-fusion-style
description: "A custom qt5ct/qt6ct QPalette has little visible effect under Kvantum; qt5ct-style/qt6ct-style exist but aren't selectable from qt5ct's own Style dropdown -- use Fusion instead"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-06T19:55:28.945Z
---

qt5ct/qt6ct's own `colors.conf` (a full `QPalette` written from scratch)
only visibly changes an app's look if the *style* actually paints from
that palette. Kvantum is a separate QStyle that draws widget chrome from
its own SVG-templated theme files, mostly ignoring the configured
`QPalette` regardless of what it says -- so setting a custom palette while
`style=kvantum-dark` (or a global `QT_STYLE_OVERRIDE=kvantum`, which takes
priority over qt5ct.conf's own `style` key) stays active has little to no
visible effect.

The per-tool bundled plugins (`qt5ct-style`/`qt6ct-style`, confirmed
registered via `strings` on the installed `.so` -- the literal keys
`qt5ct-style`/`qt6ct-style` are present) are **not** selectable from
qt5ct's own Style dropdown (confirmed live: only `kvantum`, `kvantum-dark`,
`fusion`, `windows` were listed). The correct choice to make a custom
palette actually render is **Fusion** -- Qt's own built-in cross-platform
style that paints every widget directly from the active `QPalette`.
Fusion is bundled with Qt itself, so the same `style=fusion` value is
valid for both qt5ct and qt6ct, no extra plugin dependency needed.

Also note: `QT_STYLE_OVERRIDE` (an env var) takes priority over
qt5ct.conf's/qt6ct.conf's own `style=` setting whenever it's set -- clear
or unset it (not just change the ini file) for the ini's `style` value to
actually take effect. See [[reference_lightdm_xsession_login_shell_env_scoping]]
for how to scope that per-session rather than editing `/etc/environment`
globally.

[[reference_kde_frameworks_kdeglobals_theming]]
