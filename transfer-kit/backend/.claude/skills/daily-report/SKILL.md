---
name: daily-report
description: Builds the daily morning report — yesterday's Sentry errors for this app, ranked and cross-checked against Linear. Read-only. Use when asked for the daily or morning report.
---

# Daily Morning Report

Answer one question: **what broke yesterday and does anyone know?**

## Procedure

1. Fetch from Sentry org `arabgt`, project **`backend-prod`**: issues NEW since
   yesterday, regressions, and the biggest movers by event count (last 24h).
2. Rank: crashes first, then by users affected, then by event count.
3. Cross-check the Linear project "ArabGT Mobile App": which issues already
   have a card (link it), which are untracked.
4. Output ONE markdown report:
   - Headline: `X new / Y regressed / Z untracked in Linear`
   - Table: issue, short title, users, events, first seen, Linear card (or "—")
   - One short paragraph: notable pattern, if any.
5. Small-sample rule: under ~10 events, label it "early signal — not a
   conclusion". Never extrapolate from tiny samples.

## Hard rules

- READ-ONLY end to end: no tickets, no comments, no Sentry changes.
  If asked to file the untracked ones, point to `/sentry-sweep`.
- Report in English; keep it one screen long.
