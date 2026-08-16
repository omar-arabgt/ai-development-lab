# The Complete Guide — Talk Track + Where Everything Is Defined

> Each topic has two parts: **"What you say"** (the spoken explanation, ready to present) and **"Where it's defined"** (a table: the mechanism, the exact file/location, whether it exists by default or is code we write, and which tool is best for us — Claude, Cursor, or both).

---

# 1. The Setup: Knowledge, Boundaries, Guards

## What you say

"When you open a fresh AI session — Claude or Cursor — it knows nothing about our project: not the structure, not the architecture, not our coding conventions. So the first thing we do is **write it a complete project definition in a file that lives inside the repo itself** — the structure and how features are organized, the conventions and approved patterns, and the forbidden zones and red lines. The result: from the first second of any session, the AI works like a developer who has been with us for a year. And since the file lives in the repo — anyone who clones gets the knowledge with it: **a team asset, not someone's personal settings**.

On top of knowledge come boundaries: **Permissions** — explicit lists of what the AI may run without asking, what needs approval, what is flatly forbidden, and which files it may edit. And above that, the strongest layer: **Production guards** — code that inspects every operation **before it executes**; anything that hints at a production database or environment is blocked instantly with a clear message. Not a policy on a wiki that someone must remember — the system itself refuses."

## Where it's defined

| Item | Exact file/location | Default or written by us? | Best for us |
|---|---|---|---|
| Project memory — Claude | `CLAUDE.md` at the repo root | **We write it** (the AI studies the codebase and drafts it; we review) | **Both tools** — same content, two files |
| Project memory — Cursor | `.cursor/rules/` at the repo root (`.mdc` files) | **We write it** (a mirror of the same CLAUDE.md rules) | ↑ |
| Permissions + file scopes — Claude | `.claude/settings.json` in the repo → `permissions: { allow / ask / deny }` | **We write it** — committed with the repo, so everyone inherits it | **Claude is finer-grained** — explicit rules down to command and file level |
| Permissions — Cursor | App settings (Agent auto-run allowlist) | UI setting | ⚠️ Note: Cursor's settings live **on the machine, not in the repo** — they don't propagate to the team automatically |
| Production guards (hooks) | `.claude/settings.json` in the repo → `hooks: PreToolUse` — a small bash script that inspects the operation and returns exit 2 to block | **Code we write** — a few lines, committed with the repo | **Claude only** — Cursor has no full equivalent |
| Company workspace guards (Sentry/Linear) | `~/.claude/settings.json` on each user's machine → a hook that blocks any MCP call naming the company workspace | **Code we write** (once per machine) | Claude only |

---

# 2. Multi-Agent Development and the Local Flow

## What you say

"Once the AI knows the project and is bounded — we get to the big picture: **several agents at the same time on the same repo**. Three rules make it safe: **Isolation** — each agent gets an isolated copy on the same machine (git worktree: a second working copy in a separate folder on a separate branch, no new clone) — your main folder and open editor are never touched. **Splitting by files** — no two tasks touch the same file, so the final merge has zero conflicts **by design, not by luck** — and this rule doesn't live in anyone's memory: it's written as a procedure and the AI itself refuses to violate it. **And the orchestrator** — one session dispatches, waits, merges, and cleans up. The bottom line: five tasks finish in the time of the longest one. And all of it is local — the only thing that ever leaves the machine is the Pull Request."

## Where it's defined

| Item | Exact file/location | Default or written by us? | Best for us |
|---|---|---|---|
| Isolated copies (worktrees) | A git feature itself: `git worktree add ../wt/task-a -b task/a` | **Default** — built into git, zero code | **Both** — Claude sessions and Cursor windows/background agents both ride them |
| Preventing agents from mixing on the same files | **A skill we write**: `.claude/skills/parallel-tasks/SKILL.md` in the repo — the policy is explicit: "check file overlap; overlap = no parallelism, offer sequential" | **Code/markdown written once** — committed, so every agent obeys it | **Claude** (skills are its mechanism) — Cursor users benefit from the same rule if mirrored into rules |
| The orchestrator | Not a file — **a Claude session activating the skill above**; parallel dispatch tooling is built in | Parallelism is default in Claude; the policy is ours | **Claude** — strongest orchestration; Cursor's alternative is background agents (simpler) |
| Recovering from any damage | git itself: `git restore` / `revert` / `branch checkpoint` | **Default** | Both |

---

# 3. Signals & Procedures: Sentry, Linear, Skills

## What you say

"The AI is connected to our existing tools through one standard connector called **MCP** — like USB-C: one protocol for every service, spoken by both Claude and Cursor. From **Sentry**: the moment a crash arrives, the AI reads the stack trace, opens the code, lands on the guilty line, prepares the fix as a PR, and closes the report. From **Linear**: an employee describes a problem in plain everyday language and the AI turns it into a properly formatted ticket and actually creates it; new tickets get triaged automatically — priority, labels, duplicates linked even across languages. And **Skills**: team procedures written once with the policies baked in — ask it to put a solution in a ticket? The skill itself refuses, because our team policy is problem-only. **Team knowledge stops living in people's heads and moves into versioned files every agent obeys.**"

## Where it's defined

| Item | Exact file/location | Default or written by us? | Best for us |
|---|---|---|---|
| Sentry connection | One-time command: `claude mcp add -s user --transport http sentry https://mcp.sentry.dev/mcp` + OAuth — stored in `~/.claude.json` | **One-time setup** — the server is official from Sentry | Both speak MCP — **automation rides Claude** |
| Linear connection | Same: `claude mcp add -s user --transport http linear https://mcp.linear.app/mcp` | One-time setup | ↑ |
| Sharing connections with the team | `.mcp.json` at the repo root (declares the servers for everyone — each person authenticates with their own account) | **We write it** — a few lines of JSON | Both |
| Ticket skill | `.claude/skills/linear-ticket/SKILL.md` + `template.md` in the repo | **We write it** — procedure + template + problem-only policy | Claude |
| Triage skill | `.claude/skills/linear-triage/SKILL.md` — priority ladder + mandatory audit comment + never closes tickets | **We write it** | Claude |

---

# 4. Testing Stages: Integration Tests → GitHub Actions → Firebase Test Lab

## What you say

"Testing runs in three stages, ordered by cost — and the economics are the point: **the AI writes the test once from a plain-language description** — the expensive part teams postpone for years — **and free deterministic tools run it forever**. First, **integration tests**: the user journey written as code — open, browse, reserve, confirm. Second, **GitHub Actions** — the scheduler and gatekeeper: on every PR, checks plus AI review with the merge locked until everything is green; and every night, the full journeys on iOS AND Android with a per-platform report. Third, **Firebase Test Lab**: weekly, the same tests on **real physical devices** — Pixel and Samsung in Google's server rooms — with a report and a video per device. All of it **without any paid third-party QA platform**: the framework ships with Flutter, the scheduler is GitHub, and the device farm has a free daily quota."

## Where it's defined

| Item | Exact file/location | Default or written by us? | Best for us |
|---|---|---|---|
| Journey tests | `integration_test/` folder inside the app — Dart files | **The AI writes them** from our description; we review coverage | The framework is **part of Flutter** — free |
| Per-PR gate | `.github/workflows/` — YAML: analyze + tests + checkers | **We write it** (once, AI assists) | GitHub — free |
| AI reviewer on PRs | `.github/workflows/claude-code-review.yml` + a secret named `CLAUDE_CODE_OAUTH_TOKEN` (or an API key) in GitHub Secrets — installed via `/install-github-app` | **One-time setup** — and we own the review prompt (Flutter/RTL specifics) | **Claude** — official action, fully ours to configure; Cursor's alternative is Bugbot (hosted, less control) |
| Merge lock (Branch Protection) | GitHub → Settings → Branches → rule on `main`: require status checks | **UI setting**, once | GitHub itself |
| Nightly QA (both platforms) | `.github/workflows/nightly-qa.yml` — `schedule: cron` + an iOS-simulator job and an Android-emulator job + a report script | **We write it** — ready in the lab, copied with minor edits | Claude/GitHub |
| Real devices | `.github/workflows/weekly-qa.yml` + a secret named `FIREBASE_SERVICE_ACCOUNT` (Service Account key from the Firebase console) + `prepare_testlab.sh` | **We write it** — ready in the lab | Firebase — free daily quota |

---

# 5. Tool Split: Where Claude Wins, Where Cursor Wins

## What you say

"This is not a competition — it's a **division of roles**. Cursor is the king of daily in-editor work: Tab completion and quick inline edits with the code in your hands — that's its native strength and we're not giving it up. Claude takes everything that happens **without a UI or behind hard boundaries**: the guards that block before execution, parallel orchestration, review on GitHub, and the server pipelines. The bridge between them is MCP — every integration we build serves both."

## The summary — who owns what (memorize this)

> ⚠️ **Fact-check update (2026-08-16):** Cursor has closed many gaps — it now has hooks (late 2025, `.cursor/hooks.json`), a headless CLI (`agent -p`), native parallel agents in worktrees (up to 8), and SKILL.md skills. **The decision stands — but for sharper, updated reasons:**

| Area | Chosen tool | Why (updated) |
|---|---|---|
| Daily writing in the editor | **Cursor** | Tab completion and inline edits — its native strength |
| Project memory | **Both** | Two files, one set of rules: CLAUDE.md + .cursor/rules |
| Parallel work (worktrees) | **Both** | Native in both now — shared git mechanics |
| Guards (hooks) | **Claude for automation** | Both have them now — Claude's are older and battle-tested (GA, proven in our setup); Cursor's are months old |
| PR review | **Claude** (official action, prompt fully ours) | Cursor alternatives: hosted Bugbot or a community action — less control |
| Automation (CI, server, webhooks) | **Claude** | No longer exclusive — but: **~5.5x fewer tokens for identical tasks** in independent comparisons, transparent per-pipeline API billing (batch −50% + caching) vs credit-based plans, first-party GitHub integration, and our entire playbook is already built and proven on it |
| Service connections (MCP) | **Shared** | Same protocol — one investment serves both |

**The updated bottom line:** it is no longer "who can" — both can. The decision is economics, maturity, and readiness: automation on Claude, the editor on Cursor.

---

# 6. A Developer's Day — How Work Actually Flows

## What you say

"In the morning you pick a ticket from Linear — it arrives **already triaged**. You open Cursor or a Claude session — **the rules and guards load themselves from the repo**; nothing to remember. You describe the work — and anything unclear comes back as **questions**, not guesses: you decide, and your answers become the spec. Agents implement in isolated copies — in parallel when the tasks allow. One PR goes up, passes the gates on its own, you review and merge — **and the ticket closes itself**. The developer's craft moves up: from typing every line — to deciding and reviewing."

## Where it's defined

Every piece is defined in the earlier sections — this one just composes them. The only new bit: **linking the ticket to the PR** happens inside the pipeline itself (the AI comments on the ticket with the work link and moves its status) — a policy we put in the skill, not an extra tool.

---

# 7. The Automation Server on AWS

## What you say

"The last piece: who runs the automation? Three layers. **Developer machines** for interactive work — everything local until the PR. **GitHub Actions** for gates and scheduled tests. And a **small always-on AWS server** for everything that must happen without a human: it receives the webhooks — a crash from Sentry, a ticket from Linear — runs the schedules — the morning report at 07:00, hourly triage — drives the headless pipelines and delivers results to Slack. Why a server? **Because laptops sleep and this box never does.** And a small instance is genuinely enough — the heavy AI lifting happens on the provider's API side; the server just listens, schedules, and dispatches."

## Where it's defined

| Item | Exact file/location | Default or written by us? | Notes |
|---|---|---|---|
| The server itself | A small EC2 (t4g.small is enough) — or any VPS | **We provision it** — final-phase decision | Heavy lifting is API-side, not server-side |
| Webhook listener | A script listening on an endpoint that fires `claude -p` on each POST — template ready in the lab | **Code we write** (~70 lines) | Sentry/Linear/GitHub post to it from their own Webhooks settings |
| Scheduling | `crontab` on the server → wrapper scripts (explicit PATH + logging) — or GitHub Actions schedule when a repo is involved | **We write it** — templates ready in the lab | Rule: everything explicit, no interactive question mid-pipeline |
| Headless pipelines | `claude -p "..." --allowedTools "..."` inside the scripts — tool lists sized exactly to the task | **We write them** | Headless = Claude-exclusive |
| Server credentials | Environment variables on the server (API key, tokens) — **never in code** | One-time setup | Same philosophy as GitHub Secrets |

---

## The Final Rule of Thumb — Where Things Live

- **Written once, lives in the repo** (propagates with every clone): memory, permissions, guards, skills, workflows, tests
- **Configured once per machine/account**: MCP connections, OAuth authentications, company-workspace guards
- **Configured once in the cloud**: GitHub Secrets, Branch Protection, Firebase, the AWS server
- **Free by default, zero work**: git worktrees, recovery, parallelism itself — the features exist; we just use them correctly

---

# 8. The Full Loop: Sentry Error → Linear Ticket → GitHub PR

## What you say

"And here is the moment everything composes: a crash happens at 3 AM. Sentry collects it, and an alert rule fires a webhook to our server. The listener launches one pipeline that, in order: pulls the issue details, **creates a Linear ticket** — description, Sentry link, priority per our triage ladder — investigates the code and lands on the guilty line, fixes it on a branch, runs the checks, pushes and opens a **fully described PR**, comments the PR link on the ticket and moves it to In Review. The PR gates run on their own. In the morning, the engineer finds a documented ticket and an AI-reviewed PR — reads the diff and clicks Merge. And on merge, a GitHub webhook closes the loop: the ticket goes to Done and the Sentry issue to Resolved. **From crash to PR: zero hands. The only hand: the merge click.**"

## Where it's defined

| Step | Exactly where | Who writes it |
|---|---|---|
| Sentry → webhook | Sentry UI: Alerts → New Alert Rule → action: webhook to our server URL | One-time setup |
| The listener | A script on the AWS server (~70 lines — template ready in the lab) | Code we write |
| The pipeline | `scripts/sentry_to_pr.sh` in the repo: one `claude -p` command + `--allowedTools "mcp__sentry__*,mcp__linear__*,Read,Grep,Edit,Bash(git *),Bash(gh pr create:*)"` | Code we write — every segment already proven (modules 04 + 05) |
| Opening the PR from the server | `gh` CLI authenticated as a bot / GitHub App | One-time setup |
| Closing on merge | GitHub → Settings → Webhooks → event: pull_request → a small closing pipeline: ticket → Done, issue → Resolved | Code we write (a few lines) |

**Honesty note for the presentation:** every segment of this chain has been run for real — Sentry→PR in one command, and Linear→spec→implementation→ticket-updates-itself — the final wiring through webhooks is Phase E of the transfer plan (needs the server).
