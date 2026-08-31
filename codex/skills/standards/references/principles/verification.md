# Verification

- Follow the repository's configured formatter, linter, compiler or type checker, build, tests, and documentation checks.
- Inspect the final diff for duplicated knowledge, new public surface, dependency direction, hidden behavior, and unrelated churn.
- Use the language compiler, module rules, architecture tests, or static analysis to prove intended dependency direction and the absence of cycles where those boundaries matter.
- Where a composition root and adapters exist, exercise the root and at least one real adapter path so a passing isolated core test does not hide broken wiring or representation mapping.
- Where aggregates or bounded contexts exist, test aggregate invariants at their consistency boundary and verify published cross-context contracts, including mixed schema versions and translation layers where coexistence is supported.
- Exercise public APIs from a caller's perspective and verify error and side-effect documentation.
- Use a profiler or relevant performance tool for performance claims and compare before and after measurements.
- Ask a second reader to review a non-obvious boundary or abstraction.
- Prefer a change that measurably improves code health over cosmetic perfection, consistent with Google's [code-review standard](https://google.github.io/eng-practices/review/reviewer/standard.html).
