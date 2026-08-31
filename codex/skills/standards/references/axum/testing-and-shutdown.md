# Testing and shutdown

- Test the router as a Tower service with `oneshot` and `BodyExt` before adding a real listener [A8].
- Cover success, not-found, malformed input, extractor rejection, body limits, authentication, authorization, and error response shape.
- Add an explicit middleware-order test for each security and reliability chain.
- Use `MockConnectInfo` when a handler requires connection information but the test does not run the real accept loop [A8].
- Use paused Tokio time for retry and timeout tests, and mock asynchronous I/O instead of sleeping or opening external services [T7].
- Test cancellation, bounded queue behavior, task failure, and graceful shutdown as observable scenarios [T6] [T9].
- Wire `axum::serve(...).with_graceful_shutdown(...)` to cancellation, stop readiness before draining, await owned tasks, and close the database pool [A7] [D1] [T6].
- Keep domain services independent of Axum types, and use focused adapters instead of a framework-agnostic universal handler.
- Prefer concrete dependencies, `FromRef`, and narrow traits over deeply nested generic state or a trait object for every client [M1].
