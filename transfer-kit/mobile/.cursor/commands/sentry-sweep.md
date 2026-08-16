Sweep the top N (default 6) unresolved Sentry issues from org `arabgt`, project **`mobile-prod`** (this repo's production project — the user may name another env like mobile-qa), ordered by users affected, into Linear cards — ONLY in the "Sentry Bugs" project.

Steps: 1) list existing "Sentry Bugs" cards and dedupe by Sentry link — update a comment instead of duplicating. 2) For each new issue: read details + stack trace (Sentry is READ-ONLY — never resolve/assign/modify). 3) Create one card per issue: `[Area] Problem` title; body with what happens, users affected, event count, first/last seen, culprit file, Sentry link, suggested severity (Urgent only for crash/payment/security). Problem only — no fixes. 4) Report: created, duplicates updated, board link.

If the "Sentry Bugs" project is missing or inaccessible: STOP and say so — never fall back to another team/project.
