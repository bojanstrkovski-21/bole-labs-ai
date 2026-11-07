# Performance, SEO, and hosting

Targets and patterns adapted from ChrisTitusTech/website and
ChrisTitusTech/dcuo-wiki. Use as defaults; the project's own spec wins.

## Lighthouse CI

- Run against a local production preview (`astro preview`), never the dev server.
- Use the mobile profile, 3 runs per route, and assert the median.
- Cover representative routes: home, an article, a taxonomy page, a
  data-heavy page.
- Thresholds: performance, accessibility, best-practices, and SEO each >= 0.9;
  largest contentful paint <= 3000 ms; cumulative layout shift <= 0.1.

## SEO metadata

- Canonical URL on every page; previous/next links on paginated lists.
- Open Graph and Twitter card tags.
- JSON-LD where it fits: `WebSite`, `WebPage`, `BlogPosting`, `BreadcrumbList`.
- Feed discovery link, XML sitemap (`@astrojs/sitemap`), RSS (`@astrojs/rss`).
- Descriptive page titles and meta descriptions; one `h1` per page.

## Performance habits

- Static output, small local JavaScript, no client framework by default.
- Inline small critical CSS if the project chooses it
  (`build.inlineStylesheets`).
- Lazy-load media, embeds, comments, ads, and search indexes; load search data
  on first use.
- Use privacy-enhanced embed URLs and give embeds descriptive titles.
- Keep a build-output budget when the host has a file-count limit (Cloudflare
  Pages allows 20,000 files): fail the build above a safety margin.

## Cloudflare Pages `_headers`

```text
/*
  X-Frame-Options: SAMEORIGIN
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: camera=(), microphone=(), geolocation=()

/_astro/*
  Cache-Control: public, max-age=31536000, immutable
```

- Immutable caching applies only to fingerprinted `/_astro/*`. Copied CSS/JS
  without a hash must revalidate.
- HTML: `max-age=0, must-revalidate`. Fonts and images without a hash: long TTL,
  not immutable. Feeds and sitemap: short TTLs.
- Pages reads `_headers` and `_redirects` from the build output; no server
  code is needed. Preview a deployment before production and keep the previous
  deployment for rollback.

## Supply chain

- Commit the lockfile and install with `npm ci`.
- Run `npm audit` with a reviewed waiver file for accepted exceptions
  (reason, owner, review date).
- Pin GitHub Actions by commit SHA, run CodeQL, and keep `contents: read` as
  the default workflow permission.
