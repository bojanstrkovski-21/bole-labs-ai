---
name: astro-development
description: Build, edit, validate, and deploy Astro static sites, including routes, layouts, components, content collections, scoped CSS, Markdown, redirects, headers, feeds, sitemap, and Cloudflare Pages. Use for Astro repositories (astro.config.*, src/pages, src/content).
---

# Astro Development

## Workflow

1. Read the project's `AGENTS.md`/`CLAUDE.md`, `package.json` scripts, and
   `astro.config.*` first. Project rules override this skill.
2. Identify the owning layer before editing:
   - routes and endpoints: `src/pages/`
   - document shell: `src/layouts/`; reusable UI: `src/components/`
   - content queries, route helpers, metadata: `src/lib/`
   - design tokens and shared CSS: `src/styles/`
   - content: `src/content/` (check `content.config.ts` for the schema)
   - copied-as-is files, `_headers`, `_redirects`: `public/`
3. Make the smallest change in the existing pattern. Prefer Astro components
   with TypeScript, scoped styles, and a small amount of vanilla JavaScript.
   Do not add a client UI framework, CSS framework, or server adapter unless
   the project documents an architecture decision for it.
4. Validate with the project's own scripts, in order: type check
   (`astro check`), tests, `build`, then preview the built output.
5. For visible changes, verify in a real browser at mobile and desktop widths
   in every theme (see `$frontend-testing`). A passing build is not proof a
   layout is correct.

## Rules

- Never edit or commit generated output: `dist/` and `.astro/`.
- Files in `public/` are copied without processing; use `src/assets` and
  Astro's image handling when optimization is needed.
- Default to static output. Do not add an SSR adapter to a static site.
- Treat head metadata, structured data, feeds, sitemap, redirects, and the
  base layout as high-impact code: change them deliberately and diff the
  generated output.
- Published URLs are contracts. Do not rename or re-case a published route;
  add a redirect when a move is unavoidable.
- Do not rewrite archived content broadly as part of unrelated work.
- Load media, comments, ads, and search data lazily. Do not add third-party
  scripts without noting privacy, performance, and security impact.
- Keep credentials out of source; read them from environment variables only.
- Before asserting an Astro feature or config option exists or is missing,
  check the installed Astro version (`package.json`, lockfile) and its docs.

## CSS pitfalls

- Before shipping a sibling-combinator (`+`, `~`) or `:has()` rule meant to join
  two visually adjacent elements, read the real markup. A slot wrapper such as
  `<main>` between them silently makes the selector match the wrong element.
  Prefer restructuring the DOM over selector hacks.
- Scope a visual change to the theme being discussed; port it to the other
  theme only when asked, adapting effects that do not apply (for example
  `backdrop-filter` with no image behind it).
- Apply user-given pixel and opacity values literally.

## Resources

- Read `references/content-and-routes.md` for content schemas, drafts and
  future dates, URL contracts, scaffolding, and redirects.
- Read `references/performance-seo-hosting.md` for Lighthouse targets, SEO
  metadata, `_headers` caching, and Cloudflare Pages deployment.
- Use `$web-design` for tokens, themes, and typography, `$web-accessibility`
  for WCAG behavior, and `$frontend-testing` for Playwright and Lighthouse.

## Validation

- `astro check`, tests, and the production build pass.
- Generated routes, feeds, and sitemap match intent; no unexpected diffs.
- Visual evidence exists for changed pages at mobile and desktop widths.
- Report skipped checks and anything needing a manual browser pass.
