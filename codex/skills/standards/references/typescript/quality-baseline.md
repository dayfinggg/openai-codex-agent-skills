# Quality baseline

- Keep formatting, type checking, linting, tests, and the production build independently runnable.
- Run the repository's prescribed checks before merging, rather than substituting a favorite command.
- Prefer code whose runtime behavior is obvious from ordinary JavaScript control flow. Static types do not validate runtime data.
- Make side effects visible at the edge of a module and keep core logic deterministic where practical.
- Prefer names, types, and structure that express constraints, invariants, and choices. Keep a source note only when a non-obvious reason cannot be expressed in code, types, tests, or API documentation; never narrate syntax.
- Keep generated files, declaration output, and vendored code under their declared ownership.
- Do not hide a failing check with a broad compiler, linter, or test suppression.
