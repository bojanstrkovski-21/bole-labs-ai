---
name: reference_webfetch_large_json_hallucination
description: WebFetch summarizing a large JSON/data file can return plausible-looking but wrong values (e.g. wrong codepoints) — verify by downloading and parsing directly for anything safety/correctness-critical
metadata: 
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-09-13T21:32:10.277Z
---

WebFetch converts a page to markdown and answers a prompt against it using a
small fast model — for a large structured data file (confirmed with Nerd
Fonts' ~545KB `glyphnames.json`, ryanoasis/nerd-fonts), this can silently
return plausible-looking but factually wrong values instead of failing
loudly. Caught live: asked WebFetch for specific icon codepoints and got
4-digit hex values matching the old, retired Font Awesome/pre-v2.3.0 MDI
codepoint range (e.g. `f019`) — a real search result had already warned
that current `nf-md-*` codepoints are 5 hex digits in a different range.
Re-verified by `curl`-downloading the actual file and parsing it with
Python's `json` module directly: the real values were completely different
(5-digit codepoints, e.g. `f06b0`). The wrong answer looked completely
normal/plausible on its own — nothing about the response signaled it was
unreliable.

**Why:** the summarizing model is answering from a lossy/partial read of
a huge file, not a real lookup — for something like a table of thousands of
name→value mappings, it can pattern-match toward a wrong-but-similar-shaped
answer instead of admitting the specific entry wasn't found.

**How to apply:** for anything correctness-critical looked up from a large
structured source via WebFetch (icon/glyph codepoints, exact version
numbers, exact config stanza values, precise numeric constants) — especially
when the value will be typed into a codebase, like a PUA glyph codepoint
per [[reference_unicode_pua_glyph_tool_calls]] — don't trust a single
WebFetch answer at face value. Download the raw file directly (`curl`) and
parse/grep it exactly, or cross-check with a second independent source,
before using the value. WebFetch is fine for qualitative summaries/
descriptions of a page; treat exact-value lookups from large files as
needing verification.
