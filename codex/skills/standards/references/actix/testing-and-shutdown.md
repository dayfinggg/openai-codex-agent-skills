# Testing and shutdown

- Build an app factory that accepts test state and does not bind a socket.
- Use `test::init_service`, `TestRequest`, and `call_service` for application-level tests [B6].
- Cover success, not-found, malformed input, extractor rejection, body limits, authentication, authorization, and error bodies.
- Add an explicit middleware-order test for each security and reliability chain.
- Unit-test custom extractors, middleware, `ResponseError` conversions, and pure application services without starting workers [B6].
- Use paused Tokio time for retry and timeout tests, and mock async I/O instead of sleeping [T7].
- Test migrations, constraints, transaction behavior, and pool failures against an isolated real database.
- Wire `HttpServer` shutdown signals and `shutdown_timeout` to cancellation, stop readiness before draining, await owned tasks, and close the pool [B1] [D1] [T6].
- Remember that `spawn_blocking` work cannot be force-cancelled after it starts, so give it bounded inputs and a shutdown plan [T10].
