# Testing

- Test observable behavior, contracts, and failure modes rather than implementation trivia.
- Add focused runtime tests for parsers, adapters, state transitions, and error translation.
- Add integration tests at module, package, and transport boundaries where wiring can fail.
- Add type-level tests for public generics, overloads, conditional types, and intentional compiler errors.
- Use `@ts-expect-error` only when the error is the behavior under test, and state what must remain rejected.
- Include malformed external values, absent optionals, unknown discriminants, and unexpected extra fields.
- Verify promise rejection and ensure tests never leave background work or floating promises.
- Control clocks, randomness, network calls, filesystem state, and environment variables in unit tests.
- Prefer deterministic fixtures that show the smallest input needed to prove the behavior.
- Keep test names descriptive enough to serve as executable documentation. [S23][S32]
- Run the same type checker and compiler options in CI that developers use locally.
- Use the TypeScript repository's focused cases and baselines as examples of narrow compiler-regression tests, not as application test templates. [S25]
