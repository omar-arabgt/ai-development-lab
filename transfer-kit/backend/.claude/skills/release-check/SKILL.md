---
name: release-check
description: Pre-release GO/NO-GO check — Django checks, full tests, migration sanity, and a scan that the diff never touches env files or committed migrations. Use before promoting any backend release.
---

# Release Check (GO / NO-GO)

Run every gate below, then give ONE verdict: **GO** or **NO-GO** with reasons.

1. `python manage.py check` — zero issues.
2. `python manage.py test` — FULL suite against the LOCAL stack, all green.
3. Migration sanity: `python manage.py makemigrations --dry-run` shows no
   unexpected pending migrations; the diff must not EDIT any committed
   migration (new migrations are fine, edits are not).
4. Diff scan vs `dev`: must NOT touch `.env*`, `env_varaibles/`, or committed
   migration files. Any hit = automatic NO-GO.
5. Boundary check: changed endpoints stay on their side (mobile -> api/,
   website -> web/) per project memory.

## Hard rules

- This skill NEVER deploys, never touches remote databases, and never runs
  against prod/staging settings (hooks block it anyway).
- A NO-GO must list every failed gate with exact evidence. Never soften it.
