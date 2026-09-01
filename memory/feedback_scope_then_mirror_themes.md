---
name: feedback-scope-then-mirror-themes
description: In astro-webhome, default new visual changes to the theme being actively discussed, then expect a later explicit request to port the finished design to the other theme
metadata:
  type: feedback
---

astro-webhome has two color themes (`solid` and `transparent`/wallpaper) toggled via `[data-theme]` on `<html>`. During iterative design work, the user consistently designs against one theme first (usually `transparent`, since it's the more visually interesting one — wallpaper + glass effects), tweaking it through many small rounds, and only once it's finalized says something like "now let's move this design to the other theme."

**Why**: confirmed directly — after several rounds of glass-button/frame tweaks scoped only to `[data-theme="transparent"]`, the user said "nice now in the glass theme lets make buttons glassy" (reconfirming transparent-only scope was correct and expected) and later, separately, explicitly asked to mirror the whole thing to `solid`. No pushback on the single-theme scoping in between — it was the right default.

**How to apply**: When asked for a visual change without an explicit theme named, scope it to the theme most recently being discussed (check the last few turns) rather than applying it to both themes preemptively. Wait for an explicit "do this on the other theme too" / "make them consistent" instruction before porting. When porting, mirror structure and mechanics but adapt effects that don't make sense in the other context (e.g. dropped `backdrop-filter: blur()` on `solid` since there's no wallpaper image behind it to blur — a literal copy would've been a no-op, not a strict "same values" mirror).
