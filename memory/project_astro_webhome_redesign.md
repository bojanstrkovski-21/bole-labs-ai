---
name: project-astro-webhome-redesign
description: State of the astro-webhome wallpaper/solid theme redesign as of 2026-08-31 — glass buttons, unified frames, header/search merge, page-title removal, tab redesign, solid-theme background image
metadata:
  type: project
---

As of 2026-08-31, did a full visual redesign pass on both themes of the astro-webhome bookmark dashboard (repo: `/home/bojanstrko/DATA/astro-webhome` on this machine, deployed via Cloudflare Pages).

**What changed**, in order:
1. Pulled in a prior "buttons redesign" commit (`e0d518e upd buttons and headers`) that local had been behind on.
2. Moved the search bar out of `index.astro` page content and into `Layout.astro`'s shared `<nav>` as a second row (`.nav-search-row`) — now shows on every page, not just Home.
3. Restyled `.link-item`/`.service-button` as frosted-glass "keycaps" on the wallpaper (`transparent`) theme: translucent gradient, `backdrop-filter: blur(14px) saturate(140%)`, light border, soft shadow, scale-down press effect (not a vertical slide — user explicitly rejected the slide-down/toggle feel).
4. Consolidated per-button-group frames into one frame per section: `.groups-container` (home page) or `.group`/`.button-grid` (other pages) is the single glass panel; individual `.group` divs inside `.groups-container` are plain cells, not their own mini-frames. `.group-header` titles are centered and live inside the same frame as their button grid, no separate pill background.
5. Established a "squared meeting corners + visible gap" pattern between the nav header and whatever sits below it (search row or next frame) — both themes duplicate this per `[data-theme]` block.
6. Mirrored the entire above structure to the `solid` theme too (same frame/title/button treatment, minus `backdrop-filter` since there's no wallpaper to blur).
7. Normalized the GitHub/GitLab link labels in `linux.astro`'s `gitlabGithub` array to one consistent `PascalCaseUsername Platform` style, fixing a mislabeled entry (`Kiro-iso` → `KiroDubes`, matching the real username) and a duplicate-label ambiguity (`Chaotic Git-Repo` used for two different URLs → `ChaoticAUR Repo` / `ChaoticAUR GitHub`).
8. Fixed `git-push.ps1`: it used to manually prompt for a GitHub username + PAT and embed them in the push URL every time, even though the repo's `credential.helper = manager` already handles auth transparently. Simplified to a plain `git push origin main`, no more credential prompts.

**Why**: user is iterating live on the site's visual design via conversational back-and-forth, one small tweak at a time, on both a local dev server and eventually pushed to `main` (no PR workflow observed — pushes go straight to `main`).

**How to apply**: Full details of the current frame/button/theme conventions are written into the project's own `CLAUDE.md` (Styling section) — read that first for anything touching Layout.astro's CSS, rather than re-deriving from scratch. See also [[feedback-verify-css-selectors-hit-real-dom]] and [[feedback-scope-then-mirror-themes]].

**Continued same day, later session** (uncommitted as of this writing — CLAUDE.md and code reflect it, git history doesn't yet):
9. Fixed a CI break: `package-lock.json` had lost its `@emnapi/core`/`@emnapi/runtime` entries (and picked up a stray `"peer": true` on vite) in an earlier commit, so `npm ci` failed in the GitHub Actions build with "can only install packages when lock file is in sync." Fix was `npm install` to resync the lock file — local `node_modules` already had the packages, so it was purely a stale-lockfile issue, not a real dependency change.
10. Bumped the deploy workflow's actions (`.github/workflows/deploy.yml`) off Node 20 to clear GitHub's "forced to run on Node 24" deprecation warning: `checkout@v4→v7`, `setup-node@v4→v5`, `upload-pages-artifact@v3→v5`, `deploy-pages@v4→v5` — all confirmed to declare `node24` natively in their current majors.
11. Removed the `<h1 class="page-header">` title from e-servisi/institucii/linux — the frame that used to sit below it (`.button-grid`, or the merged tabs frame, see #12) is now the element directly under the nav and got the squared-top-corner treatment `.groups-container` already had, so the nav→frame "adjacent panels with a gap" pattern (item 5 above) now applies uniformly across all four pages. Deleted the now-orphaned `.page-header` CSS (all three usages were removed) rather than leaving dead rules behind.
12. Redesigned Institucii/Linux tabs: the tab-nav row and its content grid used to be two separate elements; they're now one merged card frame (`.institutional-tabs`/`.linux-tabs` is the card, the tab-nav is its top strip with a `border-bottom` divider), and the tab buttons were restyled from solid pill buttons to look like the navbar's own `.nav-tab` (transparent background, green underline on hover, green bordered box when active) — confirmed with the user via an explicit merged-vs-two-frames choice before building.
13. `.search-btn` (the nav search bar's button) got the same per-theme keycap treatment `.link-item`/`.service-button` already had — frosted glass on `transparent`, same shape without blur on `solid` — closing the gap where it used to sit on an older unscoped base style even after item 3/6 above.
14. Added a background image to the `solid` theme, which previously had none (flat gradient only): `public/solid-bg.jpg` (a teal/green "futuristic waves" vector the user supplied, resized from 5000×3333/9.7MB down to 2070×1164/416K via `magick ... -resize 2070x1164^ -gravity center -extent 2070x1164 -quality 85` to match `wallpaper.jpg`'s footprint), wired in through the same `--bg-image` custom-property pattern the `transparent` theme uses. Then, per explicit follow-up ask, gave `solid` theme's `--primary-bg`/`--secondary-bg`/`--accent-bg`/`--card-bg`/`--hover-bg` 90% opacity (rgba alpha 0.9, i.e. "10% transparency") so the image bleeds through surfaces slightly — with **no** `backdrop-filter`/blur and no glass border-shadow treatment added, since the user explicitly said solid theme should stay non-blurred/non-glassy even with the image behind it.

**Pending**: none of this is committed yet — user handles `git add`/commit/push themselves (see [[feedback_git-security-discipline]] in the main memory store), likely via `git-push.ps1`.
