---
name: feedback-verify-css-selectors-hit-real-dom
description: Before claiming a CSS merge/fix is done, trace the actual DOM sibling/parent structure — don't assume selector targets match visually-adjacent elements
metadata:
  type: feedback
---

When writing a CSS rule meant to visually merge or adjust two elements that *look* adjacent on the page, verify what the real DOM sibling/child relationship is before writing the selector — don't infer it from visual layout alone.

**Why**: In astro-webhome, `<nav class="navigation">` and the page content are not actually siblings — `<main><slot /></main>` sits between them. A rule written as `.navigation + *` (intending to target the visible search bar / page header) silently matched the empty, unstyled `<main>` wrapper instead. It had zero visual effect, but nothing errored, so it looked like a normal committed fix. The user only caught it several turns later ("why are you not removing it") when a *different* leftover artifact (divider lines) turned out to trace back to the same class of mistake — sibling-combinator rules that were never actually reaching the intended element.

**How to apply**: Before shipping a sibling-combinator (`+`, `~`) or `:has()`-based rule intended to bridge two visually-adjacent pieces of UI, actually read the surrounding markup (Read the layout file, don't just infer from what renders) to confirm the selector's target is the real element carrying the background/border/whatever the rule touches. If the fix is for something structural like this, prefer restructuring the DOM directly (as was eventually done — moving the search bar markup into `<nav>` itself) over a sibling-selector hack, since it's less fragile and easier to verify.
