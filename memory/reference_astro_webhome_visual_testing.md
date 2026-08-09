---
name: reference-astro-webhome-visual-testing
description: How to spin up a headless browser to screenshot-verify CSS/layout changes in this repo
metadata: 
  node_type: memory
  type: reference
  originSessionId: 539b9399-9f39-4eac-994d-bf7cab3e12ad
---

This machine has system Chromium at `/usr/bin/chromium` and no global Playwright — install it per-session in /tmp (not the project) and point `chromium.launch` at the system binary:

```
cd /tmp && npm init -y >/dev/null 2>&1 && npm install playwright
```

```js
import { chromium } from 'playwright';
const browser = await chromium.launch({ executablePath: '/usr/bin/chromium' });
const page = await browser.newPage({ viewport: { width: 420, height: 600 }, deviceScaleFactor: 2 });
await page.goto('http://localhost:4321/', { waitUntil: 'networkidle' });
await page.evaluate(() => { window.switchTheme('solid'); window.switchFont('meslo'); }); // optional
await page.screenshot({ path: '/tmp/out.png' });
```

Dev server: `npx astro dev --port 4321` (run in background; check `npx astro dev status` before starting another one — it persists across turns in the same shell session but not across fresh Claude Code sessions/process restarts).

`window.switchTheme('solid'|'transparent')` and `window.switchFont('inter'|'meslo')` are exposed globally by Layout.astro's inline script — use them in `page.evaluate` to force a theme/font without clicking the UI toggle.

`/tmp` gets wiped between sessions — the playwright install and any saved scripts/screenshots need to be recreated each new session.
