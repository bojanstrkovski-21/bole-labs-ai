---
name: reference-adw-gtk-theme-headerbar-background-shorthand
description: "adw-gtk3-dark's own headerbar/.titlebar rule paints via the CSS `background` shorthand with a linear-gradient() image layer, which a background-color-only override never displaces; its main toolbar also uses a separate .primary-toolbar class that a plain .toolbar selector never matches"
metadata:
  type: reference
---

Confirmed by reading `/usr/share/themes/adw-gtk3-dark/gtk-3.0/gtk-dark.css`
directly (the real file-based Adwaita port for GTK3, used because GTK
3.24's own bundled resource CSS uses `var()`-based custom properties this
project's actual installed GTK3 fails to parse — see
[[reference_qt_custom_palette_needs_fusion_style]] for the equivalent Qt
side of "the obvious override doesn't actually render").

Two real, non-obvious gotchas found only by reading the real stock CSS
and confirming via live screenshots (an `xwd`-based GTK3 app theming
generator), not by guessing selector names:

1. **`headerbar`/`.titlebar` background**: the real rule is
   `.titlebar:not(headerbar), headerbar { background:
   @headerbar_bg_color linear-gradient(to top, @headerbar_bg_color,
   @headerbar_bg_color); ... }` — the `background` *shorthand*, which sets
   both `background-color` and `background-image` (a gradient, here a
   flat-color one) in one declaration. A custom theme's own override that
   only sets `background-color: @my_color;` on the same selector does
   **not** displace the stock theme's `background-image` layer, which
   keeps painting over the color regardless (a `background-image` layer
   always paints over `background-color` when both are present). The
   visible symptom: the headerbar/titlebar strip stays stuck on the stock
   theme's own near-black color no matter what color is set, even with
   correct selector specificity and source order. Fix: explicitly add
   `background-image: none;` to the override rule.

2. **Main toolbar uses `.primary-toolbar`, not just `.toolbar`**: the real
   rule is `.primary-toolbar, .toolbar { background-color:
   @window_bg_color; }`. A real app's actual main application toolbar
   (confirmed live: Xed's and Geany's own File/Edit/View menu+icon strip)
   commonly carries only the `.primary-toolbar` class, not `.toolbar` —
   a widget-toolkit convention from the GNOME-app-toolbar era still used
   by many GTK3 apps outside full GNOME. An override selector list that
   only includes `.toolbar` (a very natural, reasonable-looking choice)
   silently never matches such a widget at all, leaving it on the stock
   theme's own color with nothing competing (not a specificity loss — a
   selector that plain doesn't match anything).

A third, related but structurally separate gotcha in the same family:
`notebook > header` (the open-file TAB ROW CONTAINER itself) has its own
background rule (`background-color: @view_bg_color;`), distinct from
each individual `notebook > header tab` (one tab). Styling only the
per-tab rule leaves the row's own background/padding area — visible
behind and around the tabs — on the stock color.

General lesson: when a `background-color`-only override "doesn't work"
against a real, well-established base theme (Adwaita-family or
otherwise), check the base theme's own actual rule for that selector
before assuming a specificity problem — it may use the `background`
shorthand (needing `background-image: none` too) or may key off a more
specific/different class than the one assumed.
