# Safe state and diffs

- Before changing repository state, inspect the current branch, upstream, `git status --short`, unstaged diff, and staged diff. Do not assume the remote name or primary branch.
- Treat the index as the exact proposed commit snapshot. `git add` stages the content visible at that moment, while later edits remain unstaged.
- Stage only intended paths. Inspect `git diff --cached` before committing, and preserve unrelated user changes.
- Use `git switch` for branches and `git restore` for worktree or index restoration when supported. Resolve and validate exact paths before discarding changes.
- Treat reflog as a local recovery aid, not as a backup or a guarantee that unreachable objects will remain available.
