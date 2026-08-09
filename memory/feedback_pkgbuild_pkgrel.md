---
name: feedback-pkgbuild-pkgrel
description: Bump pkgrel (not pkgver) in Build-arch/PKGBUILD after syncing new upstream rofi commits
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a0aeda18-9c42-4589-a5c3-bd8633198a3b
  modified: 2026-07-28T20:14:58.337Z
---

When the user syncs their rofi fork with upstream (davatorium/rofi) and the
underlying source changes but upstream's `meson.build` project version
string doesn't change, bump `pkgrel` in `Build-arch/PKGBUILD` (not `pkgver`)
to mark the rebuild. `pkgver` should only change if it stops matching
upstream's `meson.build` version.

**Why:** the package is git-VCS-sourced (`source=("rofi-categories::git+...#branch=next")`)
with no `pkgver()` function, so nothing else signals that the build content
changed between package builds.

**How to apply:** after confirming a sync is clean (see [[project-categories-fork]]),
suggest incrementing `pkgrel` by 1 from its last committed value before the
user rebuilds/publishes the package.
