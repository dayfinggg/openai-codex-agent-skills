# Quality baseline

- Keep formatting, type checking, linting, tests, and the production build independently runnable.
- Run the repository's prescribed checks before merging, rather than substituting a favorite command.
- Prefer code whose runtime behavior is obvious from ordinary JavaScript control flow. Static types do not validate runtime data.
- Make side effects visible at the edge of a module and keep core logic deterministic where practical.
- Express constraints, invariants, and choices through names, types, and structure. Do not add prose comments or source notes. Preserve mandatory notices and tool-required directives.
- Keep generated files, declaration output, and vendored code under their declared ownership.
- Do not hide a failing check with a broad compiler, linter, or test suppression.
