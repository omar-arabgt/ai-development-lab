# Deck Outline — AI-First Development (10 slides, authoritative)

> This is the authoritative slide-by-slide outline for the presentation deck.
> Concept-first: present tense, no experiment language ("we tested", "verified", "lab").
> Style: minimal, text-first, short statements. Exactly ONE diagram (slide 6).

## Slide 1 — Title
**Title:** AI-First Development
**Subtitle:** From developers using AI → to a development factory with humans at decisions.

## Slide 2 — The Core Idea
- Using AI: you ask, it answers.
- A factory: the system asks itself — triggered by a crash, a ticket, or the clock.
- Humans sit at exactly two points: **decisions** and **approvals**.

## Slide 3 — Contracts Before Code
- A vague request returns **numbered questions**, not silent guesses.
- Every feature gets a written contract + a neutral checker that guards it.
- Output quality = contract quality. Decisions stay human.

## Slide 4 — Two Kinds of Guards
- **Deterministic gates**: same answer every time — they block the merge.
- **Intelligent reviewers**: see what checks cannot — they advise.
- Green ≠ healthy. That is why both exist.

## Slide 5 — The Parallel Team
- Multiple AI agents work the same repository **simultaneously**, each in an isolated copy.
- One orchestrator dispatches, waits, merges, cleans up.
- Five tasks take the time of the longest one — not the sum.

## Slide 6 — The Factory Flow (the only diagram)
Triggers (crash / ticket / schedule) → Pipelines (investigate → build → deliver) → Gates (contract ✓ · locked merge 🔒 · AI review 👁) → Human approval.
Note under diagram: **no arrow reaches production.**

## Slide 7 — QA in Three Speeds
- **Every PR:** contract checks + AI review — free.
- **Nightly:** full user journeys on iOS **and** Android — free.
- **Weekly:** real physical devices (Pixel, Samsung) with per-device video — free quota.
- All with tools the team already owns. **No third-party QA platform needed** — AI writes the tests; free deterministic tools run them.

## Slide 8 — The Safety Philosophy
- Production is a **hardcoded red line** — enforced by the system, not by promises.
- Permissions · pre-execution guards · locked merges · isolated accounts.
- Eight independent layers: removing any single one still leaves production unreachable.

## Slide 9 — Adoption in Phases (order, not dates)
- **Phase A:** foundations + PR gates.
- **Phase B:** signals — Sentry read-only, daily report to Slack.
- **Phase C:** QA at scale — nightly journeys, weekly real devices.
- **Phase D:** full automation — after trust is built.
- Every phase keeps humans at decisions and approvals.

## Slide 10 — Expected Questions
- **Cost?** At full scale, less than one engineer-day per month — detailed, sourced numbers available.
- **Safety?** Eight layers; production is unreachable by construction.
- **Engineers' role?** Elevated: decisions and review, not plumbing.
- **Cursor?** A complement, not a competitor — both speak the same connector protocol (MCP).
Closing line: *Everything in this deck is running today — live demo next.*
