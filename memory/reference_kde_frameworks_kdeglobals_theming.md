---
name: reference-kde-frameworks-kdeglobals-theming
description: "KDE Frameworks apps (Kate confirmed) don't reliably apply kdeglobals' ColorScheme at all outside a full Plasma session -- Kate's real, persisting color-scheme key is its own katerc's [UiSettings] ColorScheme=, which silently overrides kdeglobals regardless of its value"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-10T19:35:00.000Z
---

A plain Qt app (no KDE Frameworks dependency -- confirmed live with
`qt5ct` itself and `vlc`) correctly picks up a custom qt5ct/qt6ct
`QPalette` (via `custom_palette=true`/`color_scheme_path=`) automatically,
no extra steps.

Apps that link KDE Frameworks components (`kcolorscheme`,
`kconfigwidgets`, etc. -- e.g. `kate`, `dolphin`) theme from a separate
mechanism in principle: `~/.config/kdeglobals`'s own
`[General] ColorScheme=<name>` key, pointing at a `.colors` scheme file
(format differs from qt5ct's `colors.conf`) under
`~/.local/share/color-schemes/`.

**Correction, confirmed via extensive live testing on a non-Plasma (dwm)
session, 2026-10-10**: writing `kdeglobals`'s `ColorScheme` key alone did
**not** make Kate apply it, even after a `kbuildsycoca6` cache rebuild and
even when overriding an *already-known* system scheme name (`BreezeDark`)
in place of a brand-new custom one -- ruling out "new scheme not
discovered" as the cause. The actual, persisting mechanism Kate reads is
its **own app-specific** override: `~/.config/katerc`'s
`[UiSettings] ColorScheme=<name>` key, which silently wins over
`kdeglobals` regardless of what that says. Setting this key directly
(e.g. `kwriteconfig6 --file katerc --group UiSettings --key ColorScheme
<name>`) is what actually worked, verified on a clean un-primed fresh
launch with no manual Settings-dialog interaction needed. No
`plasma-integration` package (the real KDE Plasma Qt-platform-theme
integration plugin, confirmed via `pacman -Si` to pull in ~150-200MB of
Plasma Workspace/kwin/etc.) was installed or needed for this to work --
an earlier theory that it was required turned out to be a dead end.

Kate also separately had a stale `[KDE] widgetStyle=qt5ct-style` in its
own `katerc` -- not a real selectable QStyle (see
[[reference_qt_custom_palette_needs_fusion_style]]), fixed to `fusion`
alongside the `UiSettings` key. This alone was NOT sufficient (a
"success" screenshot taken with only this fix applied, before the
`UiSettings` key was found, could not be reproduced on repeated clean
retests and was concluded to be a false positive, likely a stale/
not-yet-repainted window capture) -- both keys are needed together.

No live-reload path was found for either key: `qdbus6` introspection of
a running Kate's own D-Bus service exposes session/document methods
(`openUrl`, `activateSession`, etc.) but no config-reload or
apply-color-scheme method. A full app restart is required after writing
either key.

Whether other KDE Frameworks apps (Dolphin etc.) have the same kind of
per-app `[UiSettings] ColorScheme=`-style override in their own `*rc`
file, separate from `kdeglobals`, is unconfirmed -- worth checking the
same way (write kdeglobals alone first, test; if that fails, diff that
app's own config file before/after manually selecting the scheme in its
own Settings dialog, the same method that found Kate's key here) rather
than assuming kdeglobals alone will work.

See [[reference_qt_custom_palette_needs_fusion_style]] for the qt5ct/
qt6ct side of this.
