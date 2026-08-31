# Quality baseline

- Target a supported .NET framework and language version chosen by the product's support policy.
- Keep builds reproducible; check in `global.json` when a repository must use a known SDK.
- Keep compiler, nullable, analyzer, and test output clean in CI.
- Use modern language features when they make intent clearer, not merely because they are new.
- Make every public behavior explicit in types, names, validation, documentation, or tests.
- Avoid cleverness, hidden global state, and abstractions that do not serve a real caller.
