# Daily Report — yesterday's errors at a glance

Build the daily morning report from Sentry org `arabgt`, project **`backend-prod`**:
new issues since yesterday + regressions + biggest movers (24h), ranked
(crashes first, then users affected). Cross-check the Linear project
"ArabGT Mobile App" and mark which issues already have cards (link them) and
which are untracked. Output one markdown report: headline counts, a table
(issue, title, users, events, first seen, Linear card), and one paragraph on
any notable pattern. Under ~10 events say "early signal — not a conclusion".
READ-ONLY: no tickets, no comments, no Sentry changes — to file untracked
issues, use /sentry-sweep.
