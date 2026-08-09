---
name: project-kniga-za-posta
description: kniga-za-posta — postal package log web app (Flask + SQLite), built via Copilot/session-defaults, not currently tracked elsewhere
metadata:
  type: project
---

Postal package log web app replacing manual paper records. Flask + SQLite
backend (`app.py`), single-page vanilla HTML/CSS/JS frontend
(`static/index.html`). Pushed to GitHub:
https://github.com/bojanstrkovski-21/postal-log-system

Features: full CRUD, live search, year/date-range filters, table view,
group-by-recipient view, CSV/Excel export. Bilingual UI (Macedonian
default + English, toggled in-app, persisted in localStorage). Dual themes:
Dawnfox light (default, bg `#b8cece`) + Nightfox dark, toggled with a
sun/moon button. `start.bat` launches the server and auto-opens the browser
after a 10s delay.

Auth: Flask session-based login with `werkzeug` password hashing. Two roles —
`admin` (full CRUD + user management) and `user` (add packages only). `users`
DB table added; default admin `admin/admin123` created on first run —
**change this password**, it was never rotated as of the last recorded
session.

**Known workaround:** dates stored `yyyy-mm-dd` in DB, displayed `dd.mm.yyyy`
via `fmtDate()`. Date inputs need `lang="mk"` to force correct format in
US-English Chrome on an MK-locale Windows machine — Chrome's native date
picker ignores `lang="mk"` in some builds, so the UI uses a text field with
auto-dot insertion + an SVG calendar button + a hidden `type="date"` input
triggered via `showPicker()` as a workaround.
