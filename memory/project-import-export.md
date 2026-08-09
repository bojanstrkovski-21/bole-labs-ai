---
name: project-import-export
description: "Student Excel import/export feature — fields, routes, normalization"
metadata: 
  node_type: memory
  type: project
  originSessionId: 4a254bef-4bdf-4bb8-a85c-7ccb65c673fb
---

Added in session 2026-06-02. Routes in `app.py`, logic in `database.py`.

**Export:** `GET /admin/students/export` → downloads `uchenici.xlsx` with all students.

**Import:** `POST /admin/students/import` → uploads `.xlsx`, inserts students.

**Import normalization:** headers and class names are NFC-normalized + stripped. Class names also have spaces and dashes removed before lookup (`norm_class`), so `IV 1`, `IV1`, `IV-1` all match `IV-1` in DB.

**Excel columns (exact headers):**
1. `Презиме` — required
2. `Ime` — required
3. `Ime на родител`
4. `Паралелка` — class name, flexible format (IV-1, IV 1, IV1 all work)
5. `Роден/а на`
6. `Место на раѓање`
7. `Општина на раѓање`
8. `Држава на раѓање` — defaults to Република Северна Македонија
9. `Државјанство` — defaults to македонско

**Other features added same session:**
- "Исчисти ученици" button (clears all students, admin only, confirmation required) — `POST /admin/students/clear`
- "Без паралелка" option in certificate form class dropdown (loads students with NULL class_id)
- Edit modal on admin/students page for updating individual students
- Flash warning shows unmatched class names after import
