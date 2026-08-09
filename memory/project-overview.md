---
name: project-overview
description: "What this project is, stack, directory roles, and current DB state"
metadata: 
  node_type: memory
  type: project
  originSessionId: ebf93ac3-d274-4682-856d-848ac493590b
---

Flask + SQLite app for generating and managing Macedonian school certificates (свидетелства/сведителства) — used by teachers and admins at a Macedonian high school (СОУ „Таки Даскало" - Битола).

**Directories (all inside /home/bojanstrko/Projects/Svidetelstva/):**
- `svidetelstva/` — main working directory, git-tracked. Edit and run this one.
- `svidetelstva-o/` — exact mirror of svidetelstva/, kept manually in sync. Same code, same DB structure.
- `/home/bojanstrko/Projects/sv/Svidetelstva-2026/` — external older copy. **Ignore entirely.**

**Sync rule:** After any code change, copy changed files to svidetelstva-o/ as well to keep them identical.

**Stack:** Python/Flask, Flask-Login, SQLite (`svidetelstva.db`), Jinja2 templates, Tailwind CSS (CDN), openpyxl for Excel, flatpickr (CDN) for date pickers.

**Key files:**
- `app.py` — all routes
- `database.py` — all DB logic + init (DB_PATH is absolute via `os.path.dirname(__file__)`)
- `templates/` — Jinja2 templates
- `templates/admin/` — admin pages: students, classes, users, subjects, settings, ministries

**Roles:** admin (full access), teacher (limited to assigned classes).

**Git / pushing:**
- `.gitignore` excludes `__pycache__`, `*.pyc`, `*.pyo`, `.env` — databases are NOT ignored, they are committed and pushed
- Use `./push.sh` to commit and push — it auto-detects the branch via `git rev-parse --abbrev-ref HEAD`
- Remote: `git@github.com:bojanstrkovski-21/Svidetelstva-2026` (SSH, key: `~/.ssh/boki-ssh-key-2025`)

**DB state (as of 2026-06-03):**
- 147 students imported
- Settings: school_name=СОУ „Таки Даскало" - Битола, municipality=Битола, verification_act=1235468/1999, verification_date=1999-06-04, ministry_name=Министерство за образовани и наука на Република Северна Македонија
- `ministries` table exists (empty — user adds entries via /admin/ministries)

**Why:** School needs to print official certificates for students each year. The app fills in student data, grades, and prints formatted certificates.
