# Testing
- Use `WebTestCase` for HTTP behavior, routing, security, forms, serialization, and response contracts.
- Use `KernelTestCase` for application services or repositories that need the test container.
- Test domain rules and use cases at their narrowest useful boundary, then cover real Doctrine and Messenger wiring with integration tests.
- Use a disposable test database for repository behavior that depends on mapping, joins, constraints, or transaction semantics.
- Add a small smoke suite for important public URLs, then add focused functional tests for each critical flow.
- Test access denial, invalid forms, not-found behavior, exception rendering, message retries, duplicate delivery, and rollback.
- Assert observable responses and state changes instead of container internals or private methods.
- Keep external HTTP calls, mail, and message transports fakeable through injected services.
- Run formatter, static analysis, unit tests, integration tests, and smoke tests in CI.
