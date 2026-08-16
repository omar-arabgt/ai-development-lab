# ArabGT — AI-First Development Factory
## Concepts & Implementation Architecture

━━━━━━━━━━━━━━━━━━━━━━━━

**Scope:** A validated approach for moving from "developers using AI" to an AI-assisted development pipeline with automated quality gates, on our existing stack (GitHub, Sentry, Linear, Flutter).

**Status:** Research / Proposal — every concept below was **built and verified in a dedicated lab** (30 hands-on experiments, public repo available on request).

**Audience:** Product, Engineering, QA, and Stakeholders.

---

## 1. Purpose

This document presents the concepts, architecture, and staged direction for adopting AI-first development at ArabGT. It is intentionally a concepts/architecture document rather than an implementation backlog: the goal is shared understanding of *what* the factory is and *why* each piece exists. Every claim marked **[verified in lab]** was demonstrated end-to-end, not assumed.

## 2. The Core Idea

Using AI is asking it to do a task. An **AI factory** is a system that asks *itself* — triggered by real events (a crash, a ticket, a schedule) — while humans stay exactly at two points: **decisions** (what should be built, answering specification questions) and **approval** (merging the pull request). Everything between those two points can run without a human finger.

## 3. Foundational Concepts

| Concept | What it means | Why it matters |
|---|---|---|
| Project memory (CLAUDE.md) | A file that teaches the AI the project's rules, conventions and red lines from second one | Consistent output that matches team standards **[verified in lab]** |
| Permissions & Hooks | Hard enforcement: the system blocks forbidden operations *before* they run — not politeness, mechanism | The AI physically cannot touch what it must not touch **[verified in lab]** |
| Spec-driven development | Vague requests return *numbered questions*, not silent guesses; every feature gets a contract + a neutral checker | Output quality equals contract quality; decisions stay human **[verified in lab]** |
| Deterministic gate vs. AI review | A fast, repeatable check guards the merge button; an AI reviewer reads what the check cannot see | "Green ≠ healthy" — the pair covers both **[verified in lab]** |
| MCP (Model Context Protocol) | A standard connector ("USB-C for AI") that plugs the AI into Sentry, Linear, PostHog, etc. | One protocol, every tool; works with any MCP-capable client — including Cursor |
| Headless pipelines | `claude -p` runs a full task non-interactively — callable from webhooks, schedulers, CI | The building block that removes the human finger **[verified in lab]** |
| Defense in depth | Eight independent protection layers; production is a red line enforced by the system itself | A guard that was never seen blocking is a wish, not a guard **[verified in lab]** |

## 4. High-Level Architecture

```
     TRIGGERS                    PIPELINES                         GATES                HUMANS
┌────────────────┐   ┌─────────────────────────────┐   ┌─────────────────────┐   ┌──────────────┐
│ New crash      │──►│ Diagnose → fix → branch      │──►│                     │   │              │
│  (webhook)     │   │                              │   │ Contract check  ✓   │   │  Decisions   │
├────────────────┤   ├─────────────────────────────┤   │ Branch protection 🔒 │──►│  (specs)     │
│ New ticket     │──►│ Questions → spec → checker   │──►│ AI code review  👁   │   │      +       │
│  (Linear)      │   │ → implementation             │   │                     │   │  PR approval │
├────────────────┤   ├─────────────────────────────┤   └─────────────────────┘   └──────────────┘
│ 07:00 daily    │──►│ Morning report               │──►  file / Slack
│  (schedule)    │   │ (Sentry + PostHog combined)  │
├────────────────┤   ├─────────────────────────────┤
│ Weekly         │──►│ Visual QA + journey tests    │──►  defect report
│  (schedule)    │   │                              │
└────────────────┘   └─────────────────────────────┘
        Underneath everything: 8 protection layers — production is never reachable.
```

## 5. QA Automation Strategy — full coverage, all tried

QA is layered like a pyramid: cheap and fast at the bottom running constantly, expensive and wide at the top running on schedule. **Crucially: AI writes the tests (the part teams always postpone); free deterministic tools run them (so daily execution costs nothing).**

| Layer | What it covers | Tool (cost) | When it runs | Status |
|---|---|---|---|---|
| 1. Unit & widget tests | Logic: "does the function return the right thing" | `flutter test` (free) | Every PR — merge gate | **[verified in lab]** — spec checkers caught planted contract violations |
| 2. Contract checkers | Every acceptance criterion of a spec, incl. edge cases | Standalone Dart checkers (free) | Every PR — required check | **[verified in lab]** — a red check physically blocked merging |
| 3. User-journey tests | Full flows on a real simulator: open → browse → details → reserve → confirm | `integration_test` (free); Maestro/Patrol as free alternatives | Nightly CI | **[verified in lab]** — including negative test: broke the button, watched red, restored, watched green |
| 4. Visual QA | What no assertion can express: overflow, contrast, readability, RTL/localization mix | AI vision on screenshots | Weekly, both AR/EN | **[verified in lab]** — caught 2 planted bugs + 1 unplanted RTL issue, zero false positives, fixed with before/after proof |
| 5. Exploratory diagnosis | When something fails: root-cause analysis and proposed fix | AI pipeline | On failure only | **[verified in lab]** — webhook-triggered diagnosis with no human in the loop |

Test authoring model: a QA engineer (or anyone) describes the journey in plain language — AI produces the runnable test; humans review the test's coverage against the spec table, which is faster and safer than reviewing implementation code. **[verified in lab]**

Cost model: AI cost is paid **once at authoring**; layers 1–3 then run forever on free CI minutes. Layers 4–5 use AI per run and are therefore scheduled, not per-commit.

### 5.1 Execution venues — three lines of defense, ordered by cost

The same journey test file runs unchanged in three places; each venue catches what the previous one cannot see:

| Venue | Devices | Trigger | Cost | Uniquely catches |
|---|---|---|---|---|
| Developer machine | one simulator | by hand | free | fast edit-test loop while building |
| GitHub Actions | fresh iOS simulator + Android emulator | every PR + nightly schedule | free (public) / metered minutes (private) | regressions nobody remembered to check; "works on my machine" issues |
| Firebase Test Lab | **real physical devices** (Pixel, Samsung, …) | weekly schedule via Actions | free daily quota | real-hardware quirks: vendor OS skins, weak CPUs, odd screens — with per-device video evidence |

### 5.2 The running QA schedule (already live in the lab)

| Cadence | What runs | Where |
|---|---|---|
| Every PR | contract checkers + AI review | GitHub gates |
| Nightly 05:00 | full user journeys on iOS **and** Android, with pass/fail reports | cloud simulators |
| Weekly Friday | entire checker suite + journeys on real devices | GitHub + Test Lab |

This entire schedule uses tools the team already owns — no third-party QA platform subscription is needed: the test framework ships with Flutter, the scheduler/reporting is GitHub itself, and AI replaces the "no-code test authoring" value that commercial QA platforms charge for.

## 6. Safety Model

1. Explicit permissions (allow/deny lists) per project
2. Pre-execution hooks that block by content, with clear refusal messages
3. Policies baked into reusable skills (e.g., problem-only tickets)
4. Branch protection: red check = merge button physically locked
5. Least-privilege tool lists per pipeline (exactly enough, never more, never less)
6. MCP guards: any call referencing company production spaces is blocked before execution
7. Account isolation: the lab runs on separate accounts; company production is not connected at all
8. Disaster drills: git-based recovery rehearsed *before* it is needed; checkpoint habit before bold operations

The production red line is enforced by layers 2, 6 and 7 simultaneously — removing any single layer still leaves it unreachable.

## 7. Adoption Phases (order, not dates)

- **Phase A — Foundations:** project memory, permissions, hooks on the Flutter repo; PR gates (contract check + AI review) on every pull request.
- **Phase B — Signals:** company Sentry connected read-only; daily morning report to Slack; ticket-formatting skill rolled out to the team.
- **Phase C — QA at scale:** golden journeys as automated tests in nightly CI; weekly visual QA sweep in Arabic and English.
- **Phase D — The factory:** ticket-to-PR and crash-to-PR pipelines behind webhooks and schedules — after the team has built trust reviewing gate-checked AI output.

Each phase keeps humans at decisions and PR approval, and none of them touches production.

## 8. Recommended Direction

1. Adopt the layered QA strategy first — it is the cheapest win and builds trust in gates.
2. Run Phase A on one real repository with the exact configuration proven in the lab.
3. Use one central API key for team billing visibility (lab ran on an individual subscription).
4. Keep Cursor and this pipeline as complements: editor-first daily work vs. automation/gates — both speak MCP, so every integration built serves both.

## 9. References

1. Lab repository (30 verified experiments, bilingual docs): github.com/omar-arabgt/ai-development-lab
2. Journey document (full story, ten principles, incident log): JOURNEY.md in the repo
3. Claude Code documentation — code.claude.com/docs
4. Model Context Protocol — modelcontextprotocol.io
5. Maestro (free mobile UI testing) — maestro.mobile.dev · Patrol (Flutter-native) — patrol.leancode.co
6. Sentry / Linear / PostHog MCP servers — official docs of each service
