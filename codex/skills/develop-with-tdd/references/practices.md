# TDD Practices

The cycle is a small failing test, the minimum passing code, then design improvement while green. Confirm the failure is meaningful before implementation. A test that passes immediately did not demonstrate that it can detect the missing behavior. For a regression, show that the test fails on the prior defect or a controlled mutation when practical.

Prefer public behavior and sociable tests with real fast collaborators. Use doubles at slow, unstable, or external boundaries and keep interaction assertions limited to behavior that is itself contractual. Treat flaky tests as defects and identify their source rather than adding blind retries.

Triangulate from one example to a general rule. Add boundaries, negative cases, properties, or metamorphic relationships when an implementation could memorize visible inputs. Treat test, fixture, snapshot, runner, timeout, retry, and coverage changes as part of the reviewed product change, not as a free path to green.

Primary sources:

- [Martin Fowler on test-driven development](https://martinfowler.com/bliki/TestDrivenDevelopment.html)
- [Agile Alliance TDD glossary](https://agilealliance.org/glossary/tdd/)
- [Martin Fowler on mocks and stubs](https://martinfowler.com/articles/mocksArentStubs.html)
- [Martin Fowler on non-deterministic tests](https://martinfowler.com/articles/nonDeterminism.html)
- [Martin Fowler on test shapes](https://martinfowler.com/articles/2021-test-shapes.html)
