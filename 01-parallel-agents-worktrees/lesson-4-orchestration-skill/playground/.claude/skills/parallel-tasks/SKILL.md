---
name: parallel-tasks
description: Orchestrates multiple independent coding tasks in parallel using git worktrees — one agent per task, merged back when done. Use whenever the user asks to run several tasks in parallel or at the same time.
---

# Parallel Tasks Orchestrator

Run each of the user's tasks in its own git worktree with its own agent, in parallel, then merge everything back into the current branch.

## Procedure

1. **Collect the tasks.** Take them from the user's message. If no explicit list is given, treat each file containing an `UnimplementedError` TODO under `lib/` as one task.
2. **Safety checks (run before anything else):**
   - `git rev-parse --show-toplevel` must succeed and the working tree must be clean (`git status --porcelain` empty). If not, STOP and tell the user why.
3. **File-overlap check (strict team policy):**
   - Determine which files each task will touch.
   - If two or more tasks touch the SAME file, do NOT run those in parallel. Explain the conflict risk, and offer to run the overlapping tasks sequentially instead. Only disjoint tasks may run in parallel.
4. **Prepare one worktree per parallel task:**
   - `git worktree add ../playground-worktrees/<slug> -b task/<slug>` where `<slug>` is a short kebab-case name derived from the task.
5. **Dispatch one agent per task, all in parallel.** Each agent's instructions must state:
   - work ONLY inside its own worktree directory;
   - implement exactly its assigned task, nothing else;
   - commit the work with a clear message before finishing.
6. **After ALL agents finish:** merge every `task/<slug>` branch into the current branch (`--no-edit`), then show `git log --oneline --graph`.
7. **Clean up:** `git worktree remove` each worktree and delete the merged `task/*` branches.
8. **Report:** one short summary per task — what was implemented and its commit hash.
