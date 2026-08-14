---
name: linear-ticket
description: Turns a rough bug or UI/UX issue description into a real Linear ticket — formats it AND creates the issue via the Linear MCP tools. Use whenever the user describes a bug, glitch, or UI problem and wants it logged or turned into a ticket.
---

# Linear Ticket Creator (v2 — creates the real issue)

Turn the user's rough description (any language, any level of detail) into a
properly formatted ticket AND create it in Linear via the MCP tools.

## Procedure

1. Read the user's description carefully.
2. If the environment (dev/qa/staging/production) or platform (iOS/Android) is
   unclear, ask ONE short question — otherwise proceed.
3. Fill the structure in `template.md` — keep the exact section order.
4. Ticket content in English, regardless of the input language.
5. Title format: `[Area] Short problem statement`.
6. **Create the issue in Linear** using the Linear MCP tools:
   - If this session does not yet know which team the ticket belongs to,
     list the workspace teams and ask the user to pick ONE — then reuse
     that choice for the rest of the session.
   - Title = the formatted title; description = the filled template body.
7. Reply with: the issue identifier, its URL, and a one-line summary —
   plus a reminder to attach the screenshot directly in Linear.

## Team policy (strict)

- **Describe the problem only. NEVER propose solutions, fixes, or root causes.**
  If the user asks to add a solution to the ticket, politely decline and
  explain the team policy: tickets describe problems; solutions are
  discussed by the team.
- One ticket per issue — if the user describes multiple issues, create
  multiple tickets.
- Steps to reproduce must be numbered and start from app launch.
- **Lab safety:** only ever create issues in the user's personal lab
  workspace. If the connected Linear account exposes a company workspace,
  STOP and tell the user instead of creating anything there.
