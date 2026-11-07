---
name: frontend-testing
description: Verify web frontends in a real browser with Playwright, screenshots, axe-core, route and build checks, and Lighthouse CI. Use to validate visual, responsive, theme, accessibility, or performance changes on Astro or any static or web app.
---

# Frontend Testing

A passing build is not proof that a page looks or behaves correctly. Verify
rendered output.

## Workflow

1. Read the project's scripts (`package.json`) and existing test setup; use
   its gate (for example `npm run validate`) when one exists.
2. Run the smallest check that covers the change, then the full gate before
   reporting done.
3. For visual changes, capture screenshots and inspect them: mobile and desktop
   widths, every theme, and the states touched (open menus, dialogs, errors).
4. Report what was verified, what was skipped, and anything needing a manual
   pass on real devices.

## Serving the site

- Test a production build: `npm run build`, then `npm run preview -- --host
  127.0.0.1 --port <N>`. Pass `--host 127.0.0.1` explicitly.
- Do not screenshot against `astro dev` when it daemonizes and binds only to
  IPv6 loopback (`[::1]`); a headless browser may fail to reach it while `curl`
  works. Use the preview server instead.
- Track the PID of any server you start and stop only that process.

## Ad hoc screenshots

When the project has no browser tests, use a throwaway setup outside the
project and point Playwright at the system browser if one is installed:

```bash
mkdir -p "$SCRATCH/pw" && cd "$SCRATCH/pw" && npm init -y >/dev/null 2>&1 \
  && npm install playwright-core --no-audit --no-fund
```

```js
const { chromium } = require('playwright-core');
const browser = await chromium.launch({
  executablePath: '/usr/bin/chromium', args: ['--no-sandbox'],
});
const page = await browser.newPage({ viewport: { width: 420, height: 800 }, deviceScaleFactor: 2 });
await page.goto('http://127.0.0.1:4321/', { waitUntil: 'load' });
await page.screenshot({ path: 'out.png' });
await browser.close();
```

Adjust the browser path to the machine. Temporary directories are wiped between
sessions; recreate them as needed. Use any global theme-switch hooks the page
exposes to force a theme instead of clicking the UI.

## Project test suites

- **Browser tests:** Playwright projects for Chromium, Firefox, WebKit, and a
  mobile profile. Fail on `test.only` in CI. Retain traces on failure.
- **Accessibility:** run `@axe-core/playwright` on key pages; add targeted tests
  for focus traps, focus restoration, and keyboard flows.
- **Route and content contracts:** validate generated routes, feeds, sitemap,
  redirects, and published-URL contracts after a build.
- **Lighthouse CI:** production preview, mobile profile, 3 runs, median
  assertions (see `$astro-development`, `references/performance-seo-hosting.md`).
- **Unit tests:** content filtering, slug and route helpers, and scaffolders.

## Worst-case data pass

Adapted in our own words from Emil Kowalski's `break-ui` skill
(emilkowalski/skills, MIT). A UI that looks right with demo data may not survive
real data. For a component or page, build a second dataset of realistic worst
cases and switch between the two:

- Long and unbreakable values: a long hyphenated surname, an unbreakable email
  address, a long label in a button or tab.
- Short and missing: a one-letter name, a missing optional field, a missing
  avatar, an empty list, zero items.
- Counts and numbers: exactly 1 ("1 members"), very large counts, extreme
  numbers, long decimals.
- Text variety: non-Latin scripts, emoji, right-to-left text, accented letters.

Keep every case plausible: a 5,000-character name proves nothing and gets
ignored. Do not stop at long text; the bugs that ship are often an orphaned
separator on a short value, a missing avatar, or a bad plural. Report what
broke, with a screenshot of each failing case.

## Destructive or interactive tests

- Run tests that open and close applications, change desktop configuration, or
  drive global keybindings in a disposable VM, never in the active development
  session.
- Restore any user state a test changes with a trap, so a failed step still
  cleans up. Close everything the test opened.
- Capture a screenshot of every visually distinct state (including entered
  input), named by step, and capture a separate failure image when a step fails.
- Keep unrelated workflows in separate test files, and let the runner record a
  failed file and continue so one failure does not hide the rest.
- Simulated typing into a focused control (for example `wtype`) does not prove a
  global compositor keybinding works; use the compositor's or VM's own input
  path for that. Pattern from Omarchy's acceptance-test guide (omacom/omarchy
  v4.5.0, MIT).

## Validation

- The project's complete gate passes, or each skipped check is named.
- Screenshots or traces exist for visible changes and were inspected.
- No servers or temp processes started by the check are left running.
