---
name: sentry-sweep
description: Pulls the top unresolved Sentry issues and files them as cards in the Linear "Sentry Bugs" project, in parallel, with dedupe. Use when asked to sweep, sync, or file Sentry bugs into Linear.
---

# Sentry → Linear Sweep

Turn the top unresolved Sentry issues into well-formed Linear cards in the
dedicated **"Sentry Bugs"** project — nowhere else.

## Procedure

1. Fetch the top **N** unresolved issues from the `arabgt` org, project **`backend-prod`** (default; the user may name another env project like backend-qa),
   ordered by users affected (default N = 6; the user may override).
2. **Dedupe first**: list existing cards in the "Sentry Bugs" Linear
   project. If a card already references an issue's Sentry ID/link,
   do NOT create a duplicate — add a short update comment instead
   (new occurrence count / last seen).
3. Split the remaining issues into batches and dispatch **parallel
   agents**, one batch per agent. Each agent, for each issue:
   - Read the issue details and stack trace via Sentry (READ ONLY —
     never resolve, assign, or modify anything in Sentry).
   - Create ONE Linear card in the "Sentry Bugs" project:
     - Title: `[Area] Short problem statement`
     - Body: what happens, affected users count, event count,
       first/last seen, culprit file/function, Sentry link,
       suggested severity (Urgent only for crash/payment/security).
     - Do NOT propose fixes in the card — problem only (team policy).
4. Wait for all agents, then report: cards created, duplicates
   updated, and the board link.

## Hard rules

- Writes go ONLY to the "Sentry Bugs" Linear project. If it does not
  exist or is not accessible, STOP and tell the user — never fall back
  to another team or project.
- Sentry is read-only in this procedure. Always.
- One card per issue. Never merge multiple issues into one card.
