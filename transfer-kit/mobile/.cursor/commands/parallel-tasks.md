# Parallel Tasks — dispatch law

Split the given tasks across parallel agents, under these hard rules:

1. FIRST map the files each task will touch (from stack traces, feature paths,
   or a quick scan). **No two agents may work on the same file** — overlapping
   tasks are merged into ONE agent working sequentially.
2. One git worktree + one branch per agent (`fix/<ticket-id>-<slug>` off `dev`).
   Parallel agents NEVER work inside the main checkout.
3. Each agent: failing test first -> fix -> FULL suite green -> one PR to `dev`.
4. Report at the end: task -> branch -> PR -> status, then remove worktrees.
