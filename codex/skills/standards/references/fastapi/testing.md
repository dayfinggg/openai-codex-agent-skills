# Testing

- Use `TestClient` for ordinary synchronous pytest request tests. [F13]
- Use HTTPX `AsyncClient` with `ASGITransport` and an async pytest plugin for async tests. [F16]
- Use `app.dependency_overrides` to replace databases, authentication providers, settings, and external services in focused tests. [F17]
- Use `with TestClient(app)` when a test must execute the app lifespan and cleanup. [F18]
- Test router prefixes, OpenAPI output, response filtering, validation errors, authorization scopes, and error handlers.
- Test database rollback, unique conflicts, transaction boundaries, idempotency, retries, and background-job handoff.
- Keep external integration tests explicit and limited, and do not call paid or stateful services from ordinary unit tests.
