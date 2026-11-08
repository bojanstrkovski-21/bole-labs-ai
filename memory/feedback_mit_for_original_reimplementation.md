---
name: feedback-mit-for-original-reimplementation
description: An original reimplementation of a GPL program's behavior can be MIT; do not copy that program's source into the MIT tree
metadata:
  type: feedback
---

When a project studies a GPL program and writes its own code, the new
repository can be MIT. Studying the behavior does not by itself require
GPL-3.0-or-later. Do not copy the GPL source, or CSS taken from it, into
the MIT tree. Files that are only copied at runtime from an installed
package keep their own license.

**Why:** On 2026-11-09, for boki-webapps, the user chose MIT after
webapp-manager (GPL-3.0-or-later) had been the layout reference. The Go
code is original. gotk4 stays MPL-2.0. The Firefox profile copied from
an installed webapp-manager, including firefox-csshacks CSS, stays under
those licenses.

**How to apply:** Recommend MIT for the new code when the source was not
copied. Name the studied project and its license in the README. Add
`LICENSE` only after the user picks the license.
