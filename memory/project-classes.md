---
name: project-classes
description: Class naming convention and seeded data in the DB
metadata: 
  node_type: memory
  type: project
  originSessionId: 4a254bef-4bdf-4bb8-a85c-7ccb65c673fb
---

All 56 classes are already seeded in `svidetelstva.db`: I-1 through I-14, II-1 through II-14, III-1 through III-14, IV-1 through IV-14.

School has four years (I, II, III, IV), up to 14 sections per year.

**Why:** Classes were missing from DB initially; seeded directly via Python script during session on 2026-06-02.

**How to apply:** Don't re-seed classes — they already exist. If the user mentions adding a new class, use the admin/classes UI or INSERT OR IGNORE.
