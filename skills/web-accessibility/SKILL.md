---
name: web-accessibility
description: Audit and implement WCAG 2.2 AA behavior in web pages: semantic HTML, headings, landmarks, keyboard navigation, focus management, labels, alt text, contrast, ARIA, and reduced motion. Use when building, reviewing, or fixing accessibility of HTML, Astro, or CSS.
---

# Web Accessibility

Target WCAG 2.2 AA unless the project states otherwise. Automated tools catch
only part of the problems; keyboard and screen-reader behavior needs a manual
pass.

## Workflow

1. Identify the pages and interactive components in scope. Read their markup
   and styles.
2. Fix structure first (semantics, headings, landmarks, labels), then
   keyboard and focus, then visual issues (contrast, motion).
3. Run the automated check the project provides (axe-core via Playwright, or
   Lighthouse accessibility) and fix the cause of each finding.
4. Do a manual keyboard pass and report what was and was not tested.

## Checklist

- **Semantics:** use native elements (`button`, `a`, `nav`, `main`, `form`
  controls) before ARIA. One `h1` per page, no skipped heading levels,
  landmarks for header, nav, main, footer, and a skip link to main content.
- **Keyboard:** every control is reachable and operable by keyboard in a logical
  order; no keyboard traps except intentional focus traps in dialogs, which
  must release on close and restore focus to a visible trigger.
- **Focus:** visible focus indicator on every focusable element, never removed
  without a replacement with enough contrast. Check it after layout or
  breakpoint changes.
- **Labels:** every input has a programmatic label; icon-only buttons have an
  accessible name; links make sense out of context.
- **Images and media:** meaningful `alt` text; empty `alt=""` for decorative
  images; embeds have descriptive titles; captions or transcripts where speech
  carries information.
- **Contrast:** 4.5:1 for body text, 3:1 for large text and UI boundaries, in
  every theme.
- **Motion:** honor `prefers-reduced-motion: reduce` by cutting animations and
  transitions to near zero; avoid flashing content.
- **Dynamic content:** loading, results, empty, and error states are announced
  (live regions or focus management) and usable by keyboard.
- **ARIA:** add it only when native semantics cannot express the pattern, and
  keep state attributes (`aria-expanded`, `aria-current`) in sync with the UI.
- **Responsive:** content reflows at narrow widths without horizontal
  scrolling; text can be resized; targets are large enough.

## Validation

- Automated accessibility check passes with no unresolved violations.
- Keyboard-only walkthrough of changed flows succeeds in each theme.
- Report manual checks not performed (screen reader, real devices).
