---
name: reference_unicode_pua_glyph_tool_calls
description: Private-use-area Unicode glyphs (Nerd Font icon codepoints) silently become empty strings when typed directly through Edit/Write tool calls
metadata: 
  node_type: memory
  type: reference
  originSessionId: a1ef345b-4266-40ee-a890-c039b99ee333
  modified: 2026-08-14T16:59:05.715Z
---

Private-use-area Unicode characters (e.g. Nerd Font icon codepoints like
U+F4BC, U+EAB0) do not reliably survive being typed as literal text in an
Edit or Write tool call — they can silently come out as empty strings in
the written file, with no error. Confirmed repeatedly in
[[project_dwm-quickshell]] while adding icon glyphs to QML files.

**How to apply:** never trust a PUA glyph typed directly into a tool
call. Write it via a small Python script that computes the character
from its codepoint (`chr(0xF4BC)`) and patches the file directly (open,
string-replace, write), then immediately verify by re-reading the file's
actual bytes back out (`[f'U+{ord(c):04X}' for c in extracted_string]`)
before trusting it landed correctly. Same applies to embedding a glyph
via Bash echo/heredoc — verify the codepoint landed, don't assume.
