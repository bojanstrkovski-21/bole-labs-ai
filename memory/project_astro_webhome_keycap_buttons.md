---
name: project-astro-webhome-keycap-buttons
description: Keycap-style button redesign for .link-item/.service-button/.search-btn — current state and how it was built
metadata: 
  node_type: memory
  type: project
  originSessionId: 539b9399-9f39-4eac-994d-bf7cab3e12ad
---

All clickable link/service/search buttons (`.link-item` on index/institucii/linux, `.service-button` on e-servisi, `.search-btn` on index) were redesigned to mimic the "Keyboard Keys Style Button Dark Color" from css-buttons.com/buttons/136. The original demo's `.btn-136` is sized for an 80px square key — sizes/insets here are scaled down/adapted per button, not copied verbatim.

Markup: each button is `<a>`/`<button>` containing `<span><i>Label</i></span>` (real DOM elements, not `::before` overlapping the anchor) — this real-span approach was adopted after a `::before`-on-the-anchor version caused a z-index/stacking bug (text rendered behind the bevel layer). Span = the lighter inset "bevel" surface (positioned via `::before` insets relative to span, or as the span itself depending on iteration — check current Layout.astro for exact state); `<i>` = the text, styled with `font-family: var(--font-family)` (respects the font toggle) and `font-weight: 600`.

Colors were ported from literal grayscale hex (#282828/#202020 outer, #232323/#4a4a4a bevel, #fff text) to Everforest vars: outer gradient `var(--bg1)`→`var(--bg-dim)`, bevel gradient `var(--bg2)`→`var(--bg4)`, text `var(--fg)`.

Styling is theme-agnostic (no `[data-theme="solid"]` scoping) — applies identically on both themes since it removed the old transparent-theme-specific `.link-item`/`.service-button` overrides (flat blurred backgrounds) that used to exist.

Known tuning so far: `.link-item` min-height 60px, font-size 14px; `.service-button` min-height 80px, font-size 14px (e-servisi explicitly asked to match link-item's font); `.search-btn` width 140px, min-height 44px, font-size 13px. All use font-weight 600.

A backup of one finished iteration was saved to [src/styles/keycap-buttons.backup.css](src/styles/keycap-buttons.backup.css) (not imported, reference only) before the colors were ported to Everforest.

See [[feedback-astro-webhome-iteration-style]] for how the user directs these tweaks.
