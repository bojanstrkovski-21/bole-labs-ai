---
name: reference-chris-titus-website-repo
description: github.com/ChrisTitusTech/website is a much larger sibling Astro/Cloudflare-Pages project worth borrowing concrete patterns from (security headers, AGENTS.md structure, reduced-motion CSS)
metadata:
  type: reference
---

`https://github.com/ChrisTitusTech/website.git` is the source for christitus.com — a full Astro + Cloudflare Pages content site (articles, live-stream archive, feeds), much larger in scope than astro-webhome but the same core stack (Astro static output, Cloudflare Pages, custom CSS design tokens, dark/light theme via `[data-theme]` on root).

Reviewed 2026-08-31 at the user's request for anything reusable. Concrete, directly-transferable things astro-webhome is currently missing:

- **`public/_headers`** — astro-webhome has none. Their file sets baseline security headers (`X-Frame-Options`, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`) on `/*`, plus a tiered `Cache-Control` policy (immutable long-cache for fingerprinted `/_astro/*`, shorter revalidate windows for copied CSS/JS/fonts/images, `max-age=0, must-revalidate` for HTML). Cloudflare Pages reads this file automatically, no server code needed.
- **`prefers-reduced-motion: reduce` media query** in their global CSS, forcing `animation-duration`/`transition-duration` to near-zero for users who've opted out of motion. astro-webhome has accumulated several `transition:` properties (button press effects, theme toggle) this session with no such override.
- **`color-scheme: dark` / `color-scheme: light`** set alongside their `[data-theme]` custom properties — a native browser hint (form control/scrollbar theming) that costs one line and astro-webhome doesn't currently set.
- Their `AGENTS.md` (with `CLAUDE.md` as a one-line pointer to it: "Read AGENTS.md before doing anything else") is a much more detailed operating-instructions doc than astro-webhome's `CLAUDE.md` — not worth copying wholesale (very content-site-specific: post front-matter contracts, livestream automation, redirect rules), but the *pattern* of "CLAUDE.md just points at one canonical instructions file" is clean and could be worth adopting if astro-webhome's CLAUDE.md ever needs to serve multiple agent tools (there's also a `GEMINI.md` there doing the same one-line redirect).

Not relevant to astro-webhome's scope (skip): their content-collection/blog schema contracts, livestream JSON automation, Playwright/Lighthouse CI validation gate, post scaffolder — all built for a publication site with ongoing editorial content, not a static bookmark dashboard.

See [[project-astro-webhome-redesign]] for what's already been done. The three items above are tracked as unchecked boxes in `TODO.md` at the repo root (user wants to explore them one at a time in a future session, not all at once) — check that file for current status rather than assuming these are still outstanding.
