---
name: feedback-credit-palette-sources
description: Always verify licensing and credit the original author when porting a third-party color palette
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 00d4e5d4-4210-415c-ae00-f8b9baac1f08
---

When porting a third-party color scheme/palette into a project
(theme, terminal config, etc.), always: (1) verify it's actually free
to use — check for a paid product being circumvented before touching
it — and (2) explicitly credit the original author/project by name,
both in code comments and in any README, even when no license file
is published upstream.

**Why:** confirmed repeatedly in [[project-archboki-themes]]'s
2026-07-05 session — the user asked this for every single palette
ported (Everforest, Evergarden, Dracula Pro), unprompted each time,
and separately asked to be refused when a request would have meant
circumventing payment for the actual paid Dracula Pro product (a
different, free "inspired by" theme by another author was fine once
verified independent and free).

**How to apply:** don't wait to be asked — when a task involves
adopting someone else's palette/config, proactively check upstream
license/payment status first, then bake attribution into whatever
you produce (commentary header, README table/section) without being
asked.
