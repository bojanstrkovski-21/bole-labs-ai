---
name: reference_fzf_tag_tiebreak_ranking
description: "Appending a status tag (e.g. \"[installed]\") to fzf candidate lines pushes exact matches to the bottom of results — fzf's default tiebreak favors shorter candidates; fix needs --nth (exclude the tag from scoring) AND --tiebreak=index together, --nth alone isn't enough"
metadata: 
  node_type: memory
  type: reference
  originSessionId: f1b950f0-c1d0-4466-923f-bc56f9964782
  modified: 2026-08-30T23:07:56.348Z
---

Decorating fzf candidate lines with an extra status marker (e.g. turning
`neovim` into `neovim [installed]` to flag already-installed packages in
an install picker) looks harmless but breaks fzf's own result ranking:
typing the *exact* name of a tagged entry still finds it, but buries it
at the bottom of the results instead of at the top, because fzf's default
scoring algorithm treats a shorter overall candidate as a better match
once the matched-character score itself is equal or close — an untagged
near-match like `neovim-qt` (9 chars) beats a tagged exact match like
`neovim [installed]` (19 chars) purely on length, not relevance.

The fix needs **two flags together**, confirmed live that one alone does
not work:
- `--nth=1` (with the default AWK-style whitespace delimiter, or an
  explicit `--delimiter`) restricts what fzf actually *searches/scores*
  to just the first field, correctly excluding the tag from the match
  computation itself — but this alone does **not** fix the ranking, since
  fzf's tiebreak (the *secondary* sort criterion once primary scores tie
  or are close) still defaults to preferring the shorter *whole line*,
  tag included.
- `--tiebreak=index` overrides that default tiebreak to "keep original
  list order" instead of "prefer shorter," which combined with `--nth=1`
  (already making the tagged and untagged candidates score identically on
  the actual match) finally produces the expected ranking.

Verify with `fzf --filter=<query>` non-interactively before trusting a
fix — `printf 'candidates\n' | fzf --filter=x --nth=1 --tiebreak=index`
shows the resulting order directly. When building a synthetic test case
for this, make sure the untagged "competitor" candidates are *shorter*
than the tagged line, not longer — a test with longer untagged
competitors will never actually reproduce the bug at all (the tagged line
already wins on length by default), silently making the test meaningless;
guard against this by also asserting the *un-fixed* candidate set
reproduces the bug before asserting the fix resolves it. Found and fixed
in [[project_dwm-quickshell]]'s `dwm-quickshell-setup` (Control Center's
AUR/pacman install picker), reported by the user testing `neovim` search
directly.
