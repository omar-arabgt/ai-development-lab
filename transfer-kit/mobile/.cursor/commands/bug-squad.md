# Bug Squad — Sentry → Linear → Parallel Fix → PR

Run the full bug pipeline for the top **N** (default 3) most RECURRING
unresolved issues (sorted by event count) from Sentry org `arabgt`,
project **`mobile-prod`** (default; the user may name another env project).

**Phase A — sweep:** dedupe against the Linear "Sentry Bugs" project
(reuse existing cards), create missing cards there (problem only, no fix
proposals, Sentry link, counts) with status **Todo**. Writes go ONLY to
"Sentry Bugs" — missing project = STOP and tell the user.

**Phase B — parallel fix:** map each bug's files from its stack trace; no
two agents may share a file (overlaps = one agent, sequential). One git
worktree off `dev` + one agent per bug (branch `fix/<ticket-id>-<slug>`),
run as parallel subagents / Multitask. Each agent: ticket → **In
Progress**; read Sentry (READ-ONLY); write a failing test that reproduces
the bug; fix the root cause with a minimal, match-the-file diff; run
`flutter analyze` then `flutter test` (the FULL suite, not only the new test); commit, push, open ONE **PR targeting `dev`** with Sentry+Linear
links; comment the PR link on the ticket; move it to the status named
exactly **"In Review from AI"**.

**Phase C — report:** table of bug → ticket → branch → PR → status.

Hard rules: if the status "In Review from AI" does not exist, STOP and ask
the user to create it (never substitute another status). Sentry stays
read-only. PRs to `dev` only. Never ship a red test suite.
