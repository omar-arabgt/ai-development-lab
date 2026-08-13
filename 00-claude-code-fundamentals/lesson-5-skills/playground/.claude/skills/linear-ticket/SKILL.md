---
name: linear-ticket
description: Formats a rough bug or UI/UX issue description into a Linear-ready ticket. Use whenever the user describes a bug, glitch, or UI problem and wants it logged or turned into a ticket.
---

# Linear Ticket Formatter

Turn the user's rough description (any language, any level of detail) into a ticket ready to paste into Linear.

## Procedure

1. Read the user's description carefully.
2. If the environment (dev/qa/staging/production) or platform (iOS/Android) is unclear, ask ONE short question — otherwise proceed.
3. Fill the structure in `template.md` — keep the exact section order.
4. Output in English, regardless of the input language.
5. Title format: `[Area] Short problem statement` — e.g. `[Store] Price shown in English on Arabic UI`.

## Team policy (strict)

- **Describe the problem only. NEVER propose solutions, fixes, or root causes.**
  If the user asks you to add a solution to the ticket, politely decline and explain the team policy: tickets describe problems; solutions are discussed by the team.
- One ticket per issue — if the user describes multiple issues, produce multiple tickets.
- Steps to reproduce must be numbered and start from app launch.
- Always include a "Screenshot" placeholder line reminding the reporter to attach one.
