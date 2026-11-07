# Content and routes

Patterns adapted from ChrisTitusTech/website (MIT-licensed repository content
retains its own license; this file paraphrases ideas, not text). Apply only
what the project already does or asks for.

## Content schema

- Define collections in `src/content.config.ts` with a validating schema.
  Required front matter fields fail the build when missing.
- Keep an explicit allowlist, in source and tests, for any legacy exception to
  the schema (for example old posts with no category). Do not widen it
  silently.
- Preserve unknown historical front-matter keys: model them in the schema or
  pass them through; never drop data on parse.
- Keep summary markers such as `<!--more-->` if list summaries depend on them.

## Drafts and future dates

- Production excludes `draft: true` and future-dated content. Capture one build
  instant and reuse it for every content query so a build is consistent.
- Compare offset-bearing timestamps as instants. Treat a date-only value as
  eligible for its whole calendar day in the site's configured timezone.
- Reject timestamps without an offset in the schema.
- Provide a separate local preview mode for drafts. `build` must ignore it and
  always produce the production route set.

## URL contracts

- Published URLs are case-sensitive and must keep a consistent trailing-slash
  policy (`trailingSlash` in `astro.config.*`).
- Keep a framework-neutral file listing every published URL. A validation script
  fails when a listed URL disappears or a new publishable URL is not recorded.
- Detect collisions after normalizing slashes (`/post`, `post/`, `/post//` all
  collide with `/post/`) and with emitted files (`/foo/` vs `/foo/index.html`).
- Check redirect sources against every emitted route, including pagination,
  taxonomy, feed, and alias routes.

## Scaffolding

- Provide one command to create a post (for example `npm run new:post`).
  It should derive a deterministic slug, refuse to overwrite, default to a
  draft, validate categories against the canonical set, and run the same
  route-collision check as validation before writing.
- Serialize titles as quoted YAML scalars and verify the parsed title round
  trips exactly.

## Redirects

- Keep path redirects in `public/_redirects` (Cloudflare Pages) or Astro's
  `redirects` config; do not duplicate a rule in both.
- Canonicalizing `www` is a hosting-zone redirect, not a Pages file rule.
- Validate that a redirect's followed response is correct, not only its status.
