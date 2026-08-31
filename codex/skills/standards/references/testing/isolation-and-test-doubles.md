# Isolation and test doubles

- Use test double as the general term. A stub supplies controlled responses, a spy records calls, a mock verifies an interaction contract, and a fake provides a working but simplified implementation.
- Use a stub when the collaborator only supplies input to the behavior under test.
- Verify interactions only when the interaction itself is the contract, such as sending one command, committing once, or not calling a forbidden dependency.
- Prefer state or result verification when callers care about the outcome rather than the internal collaboration sequence.
- Avoid deep mock graphs, broad default behavior, and assertions on every call. They duplicate implementation and make harmless refactoring break tests.
- Keep a fake semantically faithful to the production contract. An in-memory fake that ignores transactions, uniqueness, ordering, or concurrency cannot prove those behaviors.
- Add contract tests shared by a fake and its real adapter when both are relied upon as equivalent implementations.
- Do not mock value objects, ordinary data, or code that is cheap and deterministic to execute.
