# Testing

- Name a test class after the subject with a `Test` suffix and keep it under `tests/`.
- PHPUnit's basic convention is a `TestCase` subclass with public `test*` methods or an explicit `#[Test]` attribute.
- Prefer `assertSame` when identity of type and value matters.
- Call `expectException` immediately before the operation expected to throw.
- Use data providers for a behavior matrix; keep each dataset readable and purposeful.
- Test public behavior, domain invariants, failure contracts, and side effects at their narrowest useful boundary.
- Use unit tests for deterministic domain logic and integration or contract tests for adapters and framework wiring.
- Replace time, randomness, network, and filesystem globals with injected clocks, ports, or fakes.
- Keep tests independent, repeatable, and free of hidden order or shared mutable state.
- Coverage is evidence of exercised paths, not proof of correctness; prioritize meaningful assertions and edge cases.
- Test the supported PHP versions and dependency ranges that the package promises to support.
- Use traceable conference talks such as Dave Liddament's cited material to align a team on type safety and static analysis. Treat talks as practitioner guidance rather than language requirements.
