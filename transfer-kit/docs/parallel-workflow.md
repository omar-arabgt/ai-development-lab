# Parallel Multi-Agent Workflow — Cursor & Claude

How to run several AI agents on this repo at the same time without collisions.
Same git mechanics for both tools.

## The three rules

1. **One isolated working copy per agent** — `git worktree`, never the main folder.
2. **Split tasks by files** — no two parallel tasks may touch the same file.
   (The `/parallel-tasks` skill enforces this automatically on Claude;
   mirror the habit manually when driving Cursor.)
3. **One orchestrator owns the flow** — dispatch, wait, merge, clean.

## With Claude Code (orchestrated)

Open one session at the repo root and ask:

> Use /parallel-tasks: [task A in file X], [task B in file Y], [task C in file Z]

The orchestrator creates the worktrees, dispatches one agent per task in
parallel, waits, merges the branches, cleans up, and reports. If two tasks
overlap on a file it will refuse to parallelize them — that is by design.

## With Cursor (native parallel agents)

- Cursor ≥ 2.0 runs parallel agents in isolated worktrees natively —
  use the Agents window, or `/multitask` to split a request into
  parallel subagents.
- Alternatively (any version): create worktrees manually and open one
  Cursor window per worktree:

```bash
git worktree add ../wt-task-a -b task/a
git worktree add ../wt-task-b -b task/b
# open each folder in its own Cursor window; one agent per window
```

## Manual worktree lifecycle (both tools)

```bash
git worktree add ../wt-<task> -b task/<task>   # create
# ... agent works, commits ...
git checkout main && git merge task/<task>      # integrate
git worktree remove ../wt-<task>                # clean
git branch -d task/<task>
```

## Safety habits

- Checkpoint before bold operations: `git branch checkpoint-<what>`
- Everything committed is recoverable: `git restore` / `git revert` / `git reflog`
- Only PRs leave the machine — never push directly to protected branches.
