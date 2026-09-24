---
name: reference_text_elide_direction_matches_meaningful_part
description: "Text.ElideLeft vs ElideRight must match which end of the string carries the meaningful/distinguishing content, not be a single fixed default reused for every kind of truncated text"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-09-24T21:22:37.504Z
---

Found in dwm-quickshell (2026-09-24): a shared row component's detail
text used `Text.ElideLeft` for all truncated right-side text. That's
correct for breadcrumb-style strings ("Setup > Install > Fonts > Nerd
Fonts") where the rightmost, most-specific segment is what matters and
the root is redundant context. It's backwards for a plain name like an
installed app ("Thunar File Manager"): eliding from the left kept the
generic tail ("File Manager") and cut the one word that actually
identifies which app it is ("Thunar"), rendering as "…File Manager" for
every row regardless of which app was really set.

**Why:** a single shared component picks one elide direction because
it's usually invoked for one kind of content at a time — but reusing it
for a second, structurally different kind of text (a plain proper name
vs. a hierarchical breadcrumb) silently inherits the wrong assumption.
The bug is invisible in isolation (the text still elides "successfully,"
just to the wrong substring) and only shows up as "why can't I tell which
one is selected."

**How to apply:** before reusing a shared truncating-text component for
a new kind of label, ask where the *identifying* part of that string
typically sits — start (proper names, app names) or end (breadcrumbs,
paths, file extensions). Add an explicit per-use elide-direction flag
(defaulting to whatever the component's original/majority use case
needs) rather than assuming one direction fits every future caller.
