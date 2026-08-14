---
name: linear-triage
description: Triages untriaged Linear issues — normalizes titles, sets priority with reasoning, applies type labels, and flags duplicates. Use when the user asks to triage, sort, classify, or clean up Linear tickets.
---

# Linear Triage

Process every issue in the Triage/untriaged state (or the ones the user
points at) in the user's LAB workspace.

## Per-issue procedure

1. **Normalize the title** to `[Area] Short problem statement` (English).
   Keep the original meaning — never invent details.
2. **Classify with a label**: `bug`, `feature`, or `question`.
   Create the label if the workspace doesn't have it yet.
3. **Set priority** with this rubric:
   - **Urgent** — ONLY for crashes, data loss, payments broken, or
     security issues. Never guess Urgent from vague wording.
   - **High** — core flow broken for many users, with a workaround.
   - **Medium** — clear defect or valuable feature, not blocking.
   - **Low** — cosmetic, question, or nice-to-have.
4. **Comment your reasoning** on the issue: one short paragraph — what
   you classified it as and why, so the team can audit the call.
5. **Duplicates**: if two issues describe the same problem, mark the
   relation (or note it in comments on both) — do NOT close either one.

## Strict policy

- **Never close, resolve, or delete any issue.** Triage organizes; humans decide.
- Never change an issue's description text — titles, labels, priority,
  relations, and comments only.
- Lab safety: operate only on the user's personal lab workspace. If a
  company workspace is visible, STOP and tell the user.
- Finish with a summary table: issue id, old title → new title, label,
  priority, one-line reason.
