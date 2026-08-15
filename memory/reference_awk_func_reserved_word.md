---
name: reference_awk_func_reserved_word
description: "In awk, `func` is a reserved word (synonym for `function`) — using it as a plain variable name causes a cryptic syntax error, not a clear \"reserved word\" message"
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-13T22:29:09.644Z
---

Naming an awk variable `func` (e.g. `func = "spawn"`) causes a syntax
error like:

```
awk: cmd. line:30: 				func = seg
awk: cmd. line:30: 				^ syntax error
```

with no indication that `func` itself is the problem — most awk
implementations treat `func` as a synonym for the `function` keyword
(used when defining functions), so it can't be used as a plain variable
name even outside a function-definition context.

**Fix**: rename the variable (e.g. `fname`, `fn`) — nothing else needs to
change.

**Why this is easy to hit and easy to miss**: `func` reads as a totally
ordinary abbreviation to reach for when a script is extracting a
"function name" field from parsed text (e.g. parsing C struct literals,
API definitions, etc.) — the error message gives no hint that the
identifier itself is reserved, so it looks like a bracket/quote mismatch
elsewhere in the script.

**Real-world cost**: cost real debugging time in the dwm-quickshell
project (2026-08-13) writing an awk-based parser for dwm keybind array
entries — worth checking for this specifically whenever an awk script
throws a syntax error on an otherwise-unremarkable assignment line.
