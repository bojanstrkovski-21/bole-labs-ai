---
name: reference-astro-webhome-visual-testing
description: How to spin up a headless browser to screenshot-verify CSS/layout changes in this repo
metadata: 
  node_type: memory
  type: reference
  originSessionId: 539b9399-9f39-4eac-994d-bf7cab3e12ad
  modified: 2026-08-31T15:58:08.383Z
---

This machine has system Chromium at `/usr/bin/chromium` and no global Playwright — install `playwright-core` (lighter than full `playwright`, no bundled browser download needed since we point at system Chromium) per-session in /tmp (not the project) and point `chromium.launch` at the system binary, with `--no-sandbox` in this sandboxed shell environment:

```
mkdir -p /tmp/pw-shot && cd /tmp/pw-shot && npm init -y >/dev/null 2>&1 && npm install playwright-core --no-audit --no-fund
```

```js
const { chromium } = require('playwright-core');
const browser = await chromium.launch({ executablePath: '/usr/bin/chromium', args: ['--no-sandbox'] });
const page = await browser.newPage({ viewport: { width: 420, height: 600 }, deviceScaleFactor: 2 });
await page.goto('http://127.0.0.1:4321/', { waitUntil: 'load', timeout: 15000 });
await page.evaluate(() => { window.switchTheme('solid'); window.switchFont('meslo'); }); // optional
await page.screenshot({ path: '/tmp/pw-shot/out.png' });
```

**Prefer `npm run build && npm run preview -- --port <N> --host 127.0.0.1` over `astro dev` for screenshotting.** Astro 7's `astro dev` (what `npm run dev` runs) daemonizes itself — the npm script process exits immediately after printing `Dev server running at http://localhost:4321 (pid ..., background)`, but the server keeps running (`npx astro dev status`/`stop`/`logs` to manage it). The catch: this daemon binds only `[::1]:4321` (IPv6 loopback), not `127.0.0.1` — `curl http://localhost:4321` still works (resolves to `::1` and the native client connects fine), but Playwright's Chromium in this environment fails to reach `::1` (`page.goto` times out on `localhost`, `ERR_CONNECTION_REFUSED` on `127.0.0.1`). `npm run preview` doesn't have this problem — pass `--host 127.0.0.1` explicitly and it binds there reliably. If you need to screenshot against a live `astro dev` daemon specifically, `curl` it fine but don't expect Playwright to reach it without extra work.

`window.switchTheme('solid'|'transparent')` and `window.switchFont('inter'|'meslo')` are exposed globally by Layout.astro's inline script — use them in `page.evaluate` to force a theme/font without clicking the UI toggle.

`/tmp` gets wiped between sessions — the playwright install and any saved scripts/screenshots need to be recreated each new session.
