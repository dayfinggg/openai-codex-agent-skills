# Testing

- A good unit test is fast, isolated, repeatable, self-checking, and timely to write.
- Name tests by unit, scenario, and expected behavior; keep Arrange, Act, and Assert visually distinct.
- Keep unit tests independent of databases, networks, file systems, clocks, and process-global state; cover those through integration tests.
- Test public contracts, not private implementation details.
- Test nullability boundaries, argument validation, cancellation, disposal, exception translation, and concurrent behavior where applicable.
- Make asynchronous tests return `Task` and await the operation under test.
- Add a regression test that demonstrates a bug before or alongside its fix.
- Use coverage to find untested behavior; do not treat a percentage target as proof of quality.
