---
name: feedback-astro-webhome-iteration-style
description: "How Bojan directs visual CSS tweaks on astro-webhome — exact pixel values, rapid iteration, expects literal application"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 539b9399-9f39-4eac-994d-bf7cab3e12ad
---

When tweaking visual details (button insets, opacity, font-size, etc.), Bojan gives exact target values directly ("top: 1px left: 1.5px", "make it 0.70", "decrease font to 11px") rather than vague direction. Apply the literal value given — don't round, don't "improve" on it, don't ask for confirmation first.

**Why:** he iterates fast in very small steps (sometimes correcting a typo like "bttom" → bottom, or revising a value he just gave one message later) — treating each message as a precise instruction to execute immediately keeps the loop tight. Re-deriving "what he probably means" or batching changes slows him down.

**How to apply:** For rapid-fire numeric tweaks, just make the edit, rebuild, and give a one-line confirmation — skip the screenshot verification on every single micro-tweak (e.g. "top: 1px"), but do screenshot-verify after a batch of tweaks or when he says something "looks wrong"/"is missing" so you can diagnose visually rather than guessing. See [[reference-astro-webhome-visual-testing]] for the screenshot setup.

When he says a design element should match another element exactly ("same as search input", "same as group headers"), check the actual current CSS values of both rather than assuming — they may already match (e.g. page-header and group-header background opacity), or may turn out to be a different component entirely (e.g. institucii's "tab buttons" aren't the same class as home's "group headers" even though both read as section headers visually) — ask a clarifying scoping question in that case rather than guessing which selector he means.

When asked to "use exact code" from a reference (e.g. css-buttons.com snippet), apply it literally but explicitly flag any deviation needed for practical reasons (e.g. omitting a fixed height that doesn't fit the actual layout) instead of silently changing it.
