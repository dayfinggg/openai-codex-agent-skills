# Integration and history

- Distinguish `fetch` from `pull`: fetch updates remote-tracking references, while pull also merges or rebases according to configuration and arguments.
- For important integration, fetch first, inspect the commit range and diff, choose merge or rebase deliberately, then run relevant checks.
- Resolve conflicts by intended semantics and test the integrated result. Do not select `ours` or `theirs` mechanically.
- Rewrite history only within the user's authorization, after identifying the affected commits and preserving unrelated work. Unpublished status alone is not permission to amend someone else's commits or discard local changes. Coordinate any authorized published rewrite with its consumers.
- When a coordinated published rewrite is required, verify the expected remote state and prefer `--force-with-lease` over unconditional force.
- Keep commits logically reviewable and independently revertible where practical. Treat subject and body length conventions as repository policy rather than universal law.
