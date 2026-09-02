---
name: reference_argb_hex_alpha_byte_parsing
description: "A luminance/contrast helper written for #RRGGBB silently misparses an #AARRGGBB string if fed one directly — reads alpha as red, red as green, green as blue, dropping blue"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f1b950f0-c1d0-4466-923f-bc56f9964782
  modified: 2026-09-02T21:23:28.496Z
---

A hand-rolled WCAG relative-luminance/contrast-ratio function that assumes
a plain 6-digit `#RRGGBB` hex string (`substr(0,2)`/`substr(2,2)`/
`substr(4,2)` as R/G/B) will silently misparse an 8-digit `#AARRGGBB`
string if one is passed in without stripping the alpha byte first — it
reads the alpha byte as red, the real red as green, the real green as
blue, and drops blue entirely. This doesn't crash or error; it produces a
plausible-looking but wrong luminance/contrast value, so the bug hides
until a specific color combination makes the result visibly wrong (e.g. a
contrast check that should fail instead passes on a coincidentally
favorable misread).

Found in [[project_dwm-quickshell]]'s `Theme.qml`: `bg` and `barBackground`
are both stored as translucent 8-digit ARGB strings (either a plain
default, or a theme's optional alpha-carrying override), but
`relativeLuminance()` only ever handled 3-digit and 6-digit input. The bug
had been silently breaking an *existing*, already-shipped contrast check
for one release before a second, newly-added check surfaced it via a
visibly-broken result.

**How to apply:** when writing or reviewing a luminance/contrast helper
that takes a hex color string, either strip a leading alpha byte
explicitly when the string is 8 (or 9-with-`#`) characters long, or
document that the function requires a pre-stripped 6-digit input and
audit every call site to confirm none of them ever pass an ARGB string.
Prefer fixing it once inside the helper itself (matches how this project
also derives `bg`'s alpha from `barBackground`'s own alpha elsewhere —
alpha-aware color math already has an established convention there) over
patching every call site individually.
