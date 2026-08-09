---
name: project-db-path
description: DB_PATH must be absolute — relative path caused silent wrong-database bugs
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ebf93ac3-d274-4682-856d-848ac493590b
---

`DB_PATH` in `database.py` must use an absolute path:
```python
DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'svidetelstva.db')
```

**Why:** When the app was launched from the project root (`python svidetelstva/app.py`), a relative `'svidetelstva.db'` opened the root-level DB (0 students) instead of `svidetelstva/svidetelstva.db` (147 students). Students appeared to vanish.

**How to apply:** Any new database file references in this project must use `os.path.dirname(os.path.abspath(__file__))` as the base.
