---
name: bug-squad
description: End-to-end bug pipeline — pulls the top recurring Sentry bugs, files them in Linear, fixes them in parallel with one agent + worktree per bug, tests, opens PRs, and moves tickets to "In Review from AI". Use when asked to squad, auto-fix, or batch-fix Sentry bugs.
---

# Bug Squad — Sentry → Linear → Parallel Fix → PR

One command runs the whole chain for the top **N** (default 3) most
RECURRING unresolved bugs (sorted by event count) from org `arabgt`,
project **`backend-prod`** (default; the user may name another env project).

## Phase A — Sweep into Linear

1. Fetch the top N unresolved issues from Sentry, ordered by event count.
2. Dedupe against the Linear **"Sentry Bugs"** project: if a card already
   references the issue's Sentry ID/link, reuse that card; otherwise create
   one there (title `[Area] problem`, body per the linear-ticket policy:
   problem only, no fix proposals, Sentry link, counts) with status **Todo**.
3. Writes go ONLY to the "Sentry Bugs" project. Missing/inaccessible → STOP.

## Phase B — Parallel fix

4. Plan file ownership FIRST: from the stack traces, list the files each bug
   touches. **No two agents may share a file** — overlapping bugs are fixed
   sequentially by one agent instead.
5. For each bug: create a git worktree off `dev`, branch
   `fix/<ticket-id>-<slug>`, and dispatch one agent per bug in parallel.
6. Each agent, inside its own worktree:
   a. Move its Linear ticket to **In Progress**.
   b. Read the full Sentry issue + stack trace (Sentry is READ-ONLY — never
      resolve/assign/modify anything there).
   c. Write a test that REPRODUCES the bug and fails first.
   d. Fix the root cause (Django code only, minimal diff, match-the-file style).
   e. Run `python manage.py test` against the LOCAL stack only (never a remote DB). All green or keep working — never ship red.
   f. Commit, push the branch (needs approval), open a **PR targeting `dev`**
      (one bug = one PR) with the Sentry + Linear links in the description.
   g. Comment the PR link on the Linear ticket, then move the ticket to the
      status named exactly **"In Review from AI"**.

## Phase C — Report

7. Wait for all agents, then report a table: bug → ticket → branch → PR →
   final status, plus anything an agent could not finish and why.

## Hard rules

- If the team workflow has NO status named "In Review from AI", STOP and ask
  the user to create it in Linear (Team settings → Issue statuses, under the
  Started/Review group). NEVER silently substitute another status.
- Sentry is read-only. Linear writes: cards in "Sentry Bugs", status moves,
  and comments only.
- PRs target `dev` only. Production red lines stay in force inside every
  worktree (hooks apply there too).
- An agent that cannot make the test pass leaves the ticket In Progress,
  comments what it found, and reports back — it never opens a red PR.
