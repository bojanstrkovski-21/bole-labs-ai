---
name: reference_codeberg_relative_href_not_rewritten
description: Codeberg/Forgejo markdown rewrites relative <img src> but not relative <a href> in HTML, so click-through links 404; use absolute /raw/branch/main/ URLs
metadata:
  type: reference
---

In a Codeberg (Forgejo) README, a relative `<img src="screenshots/x.webp">` is rewritten and works, but a relative `<a href="screenshots/x.webp">` in raw HTML is not: it points at `/screenshots/x.webp` and gives a 404. Use `https://codeberg.org/<user>/<repo>/raw/branch/main/<path>` (or `/src/branch/main/`) for link targets. READMEs cannot run JS, so slideshows are out; HTML `<table>` and `<details>` work.

**How to apply:** when building a thumbnail grid in a Codeberg README, make img srcs relative and link hrefs absolute, then curl each href for a 200. See [[reference_codeberg_conventions]].
