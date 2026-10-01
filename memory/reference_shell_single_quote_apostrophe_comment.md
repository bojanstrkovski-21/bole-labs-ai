---
name: reference_shell_single_quote_apostrophe_comment
description: "An apostrophe inside a comment within a single-quoted embedded script (awk/sed one-liner, etc.) prematurely closes the shell's quote and silently breaks the script"
metadata:
  node_type: memory
  type: reference
  originSessionId: cbbd5321-fcc6-4201-b0e7-2343827e57dc
  modified: 2026-10-01T21:19:34.214Z
---

A comment added inside an `awk`/`sed`/similar one-liner that's itself
embedded in a shell script as a single-quoted string (e.g.
`awk '...'`) will break the script if the comment contains an
apostrophe/single-quote character ("VS Code's real class", "don't do
X"). The apostrophe closes the shell's single-quoted string early;
everything after it gets parsed as raw shell syntax instead of staying
protected inside the quote, usually producing a cryptic `syntax error
near unexpected token` far from the actual cause. Caught live: a
one-word fix note inside an `awk` program embedded in a POSIX shell
script broke the live script, confirmed via `sh -n` after the fact.

**How to apply:** before handing over any edit to a shell script that
embeds another language's code (awk/sed/perl one-liners) inside single
quotes, grep the diff for apostrophes in added comments/strings, or
just run `sh -n <script>` (or the matching shell for its shebang) to
verify syntax before deploying — do this *before* reporting a change
as done, not after a user reports something broke. Prefer rewording to
avoid the apostrophe entirely over the POSIX `'\''` escape trick, since
the escape is easy to get wrong and harder to read later.
