---
name: web-design
description: Design and refine web UI: layout, typography, spacing, color, dark and light themes, CSS design tokens, responsive breakpoints, and restrained motion. Use when building or restyling pages, components, or themes; pair with astro-development for Astro sites.
---

# Web Design

Good design is not the same as working code. A page can build, pass tests, and
still look wrong on a phone. Design decisions are verified by looking at
rendered output.

## Workflow

1. Read the project's existing tokens, theme mechanism, and components before
   proposing anything. Match them unless the user asks for a redesign.
2. State the design intent in one or two lines (audience, tone, constraints)
   and any reference being followed.
3. Work from tokens: define or reuse custom properties, then build components
   from them. Do not hard-code one-off colors, sizes, or radii.
4. Build mobile first, then widen. Check the narrowest and widest supported
   widths, not only a mid-size desktop.
5. Render and inspect (see `$frontend-testing`) in every theme before calling
   the change done.

## Design system

- Tokens as CSS custom properties on `:root`: background, surface, text, muted
  text, accent, border, shadow, radius, content max width, reading width.
- Two-layer color model: raw palette variables defined once, then semantic
  variables (`--card-bg`, `--accent-bg`) redefined per theme.
- Themes via `[data-theme]` on the root element, with `color-scheme: dark` or
  `light` set per theme so form controls and scrollbars match. Respect the
  stored user preference and default sensibly.
- Scope component styles; avoid global selectors that depend on page structure.

## Typography and layout

- Limit to one or two typefaces. Self-host fonts when practical and keep a
  system fallback so layout survives a font failure.
- Constrain reading width (about 60-75 characters), use a consistent spacing
  scale, and keep a clear heading hierarchy.
- Prefer CSS grid and flexbox with fluid sizing (`clamp()`, `min()`, `max()`)
  over many fixed breakpoints. Add breakpoints where the content breaks.
- Make touch targets comfortably large and avoid hover-only interactions.
- Use restrained effects: modest shadows, subtle borders, no stacked glows.
  Respect `prefers-reduced-motion`.

## Contrast and color

- Text contrast of at least 4.5:1 (3:1 for large text and UI boundaries) in
  every theme. Verify the light theme separately; do not assume it mirrors dark.
- Do not rely on color alone to convey state.
- When porting a third-party palette, check its license and credit the author.
- If a design copies a brand or reference site, record the source, observed
  values, and asset provenance (a `DESIGN.md`) so adaptations are explicit.

## Iteration

- Apply user-given values (pixels, opacity, sizes) literally; flag any needed
  deviation instead of silently changing it.
- For a "match X exactly" request, read both elements' real CSS values first;
  they may already match or be different components.
- Scope a change to the theme under discussion; port it only when asked.
- Fast micro-tweaks need a rebuild and a one-line confirmation. Take a
  screenshot after a batch or when something "looks wrong".

## Validation

- Screenshots at mobile and desktop widths, each theme, show no overflow,
  clipping, or overlap.
- Contrast and keyboard focus checks pass (`$web-accessibility`).
- No hard-coded values that bypass the tokens.
