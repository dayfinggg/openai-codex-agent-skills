# Testing
- Make feature tests the main safety net for HTTP behavior, authorization, validation, persistence, and serialization.
- Unit-test deterministic domain rules and actions without booting more framework than the subject needs.
- Use HTTP assertions for status, redirects, validation errors, JSON shape, headers, and authenticated behavior.
- Use `Queue::fake()` and `Event::fake()` to assert dispatch intent without running asynchronous side effects.
- Bind fakes or mocks into the container at external boundaries instead of mocking every facade by default.
- Use `withoutExceptionHandling()` when a failing feature test needs the original exception and stack.
- Test rollback, not-found behavior, authorization failures, duplicate delivery, retry exhaustion, and error rendering.
- Keep tests independent and use factories or explicit fixtures that describe the scenario under test.
- Run formatting, static analysis, focused tests, and the full test suite in CI.
