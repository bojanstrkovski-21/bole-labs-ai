---
name: project-ministries
description: "Ministries admin feature — table, routes, how it connects to certificate form"
metadata: 
  node_type: memory
  type: project
  originSessionId: ebf93ac3-d274-4682-856d-848ac493590b
---

Added 2026-06-03. Replaces the old JSON-in-settings approach for managing verification ministries.

**DB table:** `ministries` — columns: `id, name, act_number`. No date column (date stays on the certificate form itself).

**Routes in app.py:**
- `GET/POST /admin/ministries` → `admin_ministries()` — list, add, delete
- Accessible via Администрација dropdown in nav

**Template:** `templates/admin/ministries.html` — add form (name + act_number), list table with delete.

**Certificate form integration:**
- Верификација section has a ministry dropdown (populated from `ministries` table via `ministries=db.get_all_ministries()` passed to both `certificate_new` and `certificate_edit`)
- Selecting a ministry auto-fills `verification_act` (act number) and `verification_issued_by` (readonly text) via `fillMinistryFields()`
- `verification_date` remains a manual flatpickr field

**Legacy settings:** `ministry_name`, `verification_act`, `verification_act_entries_json`, `ministry_entries_json` still exist in settings table but are no longer used by the certificate form — the ministries table takes over.
