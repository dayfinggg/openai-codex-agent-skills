# Axum framework reference

Read `rust.md` first for language-wide ownership, error, async, testing, and abstraction rules.
This reference adds Axum, Tower, and Tokio integration details without repeating that baseline.
Read documentation that matches the Axum version in `Cargo.lock`.
Axum's repository says that `main` tracks work toward 0.9 while 0.8.x is the released branch [A12].

## Application shape and state

- Keep `main` responsible for configuration, resource construction, router assembly, binding, and shutdown.
- Expose an `app(state)` or `router(state)` constructor so tests can build the service without opening a socket [A8].
- Use `Router::with_state` and `State<T>` for application state; a router with missing state cannot be served until `.with_state` completes [A2].
- Axum clones state for every request, so store pools, clients, and other expensive resources behind cheap cloneable handles [A1] [A2].
- Implement `FromRef` when a handler needs a substate rather than the entire application state [A2].
- Use `Extension` only for deliberately dynamic request data because a missing extension is a runtime 500 response [A2].
- Keep request-local principals and claims in typed extensions or a custom extractor after authentication has succeeded.

## Extractors and handlers

- Use `Path`, `Query`, typed headers, `State`, `Json`, `Form`, and `Bytes` to make the request contract visible in the handler signature [A3].
- Put the one body-consuming extractor last because preceding extractors must implement `FromRequestParts` [A3].
- Never attempt to consume the request body twice; choose one decoded representation or explicitly buffer once.
- Return `Result<T, T::Rejection>` when one handler needs to customize an extractor rejection [A3].
- Write a custom `FromRequest` or `FromRequestParts` extractor when authentication, validation, or request context is reused across routes [A3] [A10].
- Keep extractor rejection bodies stable and avoid returning parser, database, or filesystem details to clients.
- Axum's default 2 MiB limit protects `Bytes`, `String`, `Json`, and `Form`, but an extractor that polls the body directly bypasses that local limit [A6].
- Add `RequestBodyLimitLayer` when a global limit must cover custom and third-party body consumers [A6] [H3].
- Validate content type, size, ranges, and formats before calling application services [S1].

## Routing and middleware

- Axum uses Tower services and `tower-http` layers, so prefer their established timeout, tracing, CORS, compression, ID, and limit components [A1] [H1].
- `ServiceBuilder` layers run in addition order on requests: the first `.layer(...)` sees the request first, and responses return in reverse order [A4] [A11].
- Repeated `Router::layer` calls run the last-added middleware first on requests, and responses traverse that order in reverse [A4].
- Prefer one `ServiceBuilder` for a critical chain so its request order reads top to bottom [A4] [A11].
- Use `route_layer` when an authorization policy should apply only after a route matches [A4].
- Use `from_fn` for small Axum-only middleware and `from_fn_with_state` when the function needs state [A4].
- Use a custom Tower `Layer` only when configuration, reuse, or publication needs it; do not wrap every handler in a generic adapter [A4].
- Handle errors from timeout, rate, or other fallible layers with `HandleErrorLayer`, or the connection can close without a response [A5].
- Set request IDs before `TraceLayer` and propagate them after tracing observes the response [H5].
- Mark authorization and cookie headers sensitive before request tracing, and mark response headers sensitive after tracing where required [H4].
- Require an ordering test for every critical chain, such as request ID, authentication, timeout, handler, and response redaction.
- Make that test record entry and exit markers and assert the exact request and response sequences rather than relying on registration order by inspection.

## Errors

- Define an application error type with stable public categories and a retained source error for diagnostics.
- Implement `IntoResponse` for the Axum-facing error type and map validation, authentication, conflict, timeout, and dependency failures deliberately [A5].
- Use generic 5xx response bodies while logging causes, request IDs, route templates, and safe context [S1].
- Remember that an extractor rejection bypasses the handler, so test its status and body as a separate boundary [A3].
- Keep middleware errors infallible at the router boundary by converting them with `HandleError` or `HandleErrorLayer` [A5].
- Do not use panics as control flow; a `CatchPanicLayer` is only a last-resort process boundary and should return a generic 500 [H7].
- Review error mapping as part of the HTTP contract because status and body shape are observable behavior [L1].

## Async and concurrency

- Axum is designed for Tokio and Hyper, so use async clients and avoid blocking the runtime worker [A1].
- Move synchronous I/O and bounded CPU work to `spawn_blocking`; bound many CPU jobs with a semaphore or a dedicated pool [T3] [T10].
- Do not detach background work from a request unless its durability and failure reporting are owned elsewhere.
- Keep `JoinHandle`s or use `JoinSet` for background task failure, cancellation, and shutdown ownership [T4] [T9].
- `join!` runs branches concurrently on one task, while spawned tasks can run in parallel on runtime workers when appropriate [T11].
- Use bounded channels for work queues and a dedicated owner task for a mutable connection or client [T2].
- Use a short synchronous lock for data-only critical sections, and do not hold any blocking lock across `.await` [T1].
- Apply Tower concurrency limits or bounded queues before expensive handlers to make overload behavior explicit [A11].
- Use `select!` with cancellation and dependency timeouts, and make side effects safe if a future is dropped [T5].

## Database boundary

- Construct one async database pool at startup and place its cloneable handle in `AppState` [D1].
- Keep SQL, row decoding, and driver errors in an infrastructure or repository module, not in route modules.
- Let an application service own the use-case transaction scope, and keep the transaction short around the writes that must commit together [D2].
- Acquire a connection close to the query and release it before unrelated network or rendering awaits.
- Use bound parameters and database constraints, and consider SQLx compile-time checked queries when SQLx is the selected driver [D3].
- Configure pool size, acquire timeout, query timeout, and shutdown behavior from deployment limits [D1].
- Test migrations, constraints, query shape, and transaction rollback against an isolated real database.

## Security

- Configure `CorsLayer` with an explicit origin, method, and header policy; do not allow credentials with a wildcard origin [H6] [S1].
- Apply body limits to every route that accepts untrusted input, including file uploads and custom streaming extractors [A6] [H3].
- Authenticate in a focused extractor or middleware, then authorize the resource, owner, method, and workflow transition in application code [A10] [S1].
- Keep tokens, API keys, and passwords out of URLs, and do not log request bodies or secrets [S1] [H4].
- Reject unsupported methods and content types with semantically correct 4xx responses [S1].
- Add rate or concurrency limits to expensive and credentialed endpoints, and return 429 when policy rejects excess traffic [S1] [A11].
- Terminate TLS at a trusted edge or use a maintained TLS integration, and treat forwarded headers as untrusted until the proxy is configured.
- Return generic error messages and use browser security headers only when the API's browser context benefits from them [S1].

## Observability

- Initialize one `tracing_subscriber` before serving requests and set filters from deployment configuration [T8].
- Use `TraceLayer` to record request start, matched route, status, latency, body-stream failures, and classified failures [H2].
- Prefer `MatchedPath` or another route template over raw URLs so IDs do not become high-cardinality metric labels [A9].
- Correlate logs and outbound work with request IDs and trace context, while redacting authorization, cookies, and personal data [H4] [H5].
- Measure request count, in-flight work, latency distributions, status classes, body-limit rejections, and dependency outcomes.
- Measure database pool wait separately from query execution so saturation has a visible signal.
- Use the maintained Axum tracing example as a reference for spans, rejection filters, response hooks, and stream hooks [A9].

## Testing and shutdown

- Test the router as a Tower service with `oneshot` and `BodyExt` before adding a real listener [A8].
- Cover success, not-found, malformed input, extractor rejection, body limits, authentication, authorization, and error response shape.
- Add an explicit middleware-order test for each security and reliability chain.
- Use `MockConnectInfo` when a handler requires connection information but the test does not run the real accept loop [A8].
- Use paused Tokio time for retry and timeout tests, and mock asynchronous I/O instead of sleeping or opening external services [T7].
- Test cancellation, bounded queue behavior, task failure, and graceful shutdown as observable scenarios [T6] [T9].
- Wire `axum::serve(...).with_graceful_shutdown(...)` to cancellation, stop readiness before draining, await owned tasks, and close the database pool [A7] [D1] [T6].
- Keep domain services independent of Axum types, and use focused adapters instead of a framework-agnostic universal handler.
- Prefer concrete dependencies, `FromRef`, and narrow traits over deeply nested generic state or a trait object for every client [M1].

## Sources

### Axum and Tower documentation

- [A1] [Axum crate documentation](https://docs.rs/axum/latest/axum/).
- [A2] [Axum `State` and `FromRef`](https://docs.rs/axum/latest/axum/extract/struct.State.html).
- [A3] [Axum extractors](https://docs.rs/axum/latest/axum/extract/).
- [A4] [Axum middleware](https://docs.rs/axum/latest/axum/middleware/).
- [A5] [Axum error handling](https://docs.rs/axum/latest/axum/error_handling/).
- [A6] [Axum `DefaultBodyLimit`](https://docs.rs/axum/latest/axum/extract/struct.DefaultBodyLimit.html).
- [A7] [Axum graceful serving](https://docs.rs/axum/latest/axum/serve/struct.Serve.html).
- [A9] [Axum tracing example](https://github.com/tokio-rs/axum/blob/main/examples/tracing-aka-logging/src/main.rs).
- [A10] [Axum maintainer discussion on stateful error handling](https://github.com/tokio-rs/axum/discussions/2272).
- [A11] [Tower `ServiceBuilder` ordering](https://docs.rs/tower/latest/tower/struct.ServiceBuilder.html).

### Maintainer repositories and examples

- [A12] [Axum repository and released-branch note](https://github.com/tokio-rs/axum).
- [A8] [Axum testing example](https://github.com/tokio-rs/axum/blob/main/examples/testing/src/main.rs).

### Ecosystem documentation

- [H1] [Tower HTTP overview](https://docs.rs/tower-http/latest/tower_http/index.html).
- [H2] [Tower HTTP tracing](https://docs.rs/tower-http/latest/tower_http/trace/index.html).
- [H3] [Tower HTTP request limits](https://docs.rs/tower-http/latest/tower_http/limit/).
- [H4] [Tower HTTP sensitive headers](https://docs.rs/tower-http/latest/tower_http/sensitive_headers/).
- [H5] [Tower HTTP request IDs](https://docs.rs/tower-http/latest/tower_http/request_id/).
- [H6] [Tower HTTP CORS](https://docs.rs/tower-http/latest/tower_http/cors/).
- [H7] [Tower HTTP panic boundary](https://docs.rs/tower-http/latest/tower_http/catch_panic/).
- [T1] [Tokio shared state](https://tokio.rs/tokio/tutorial/shared-state).
- [T2] [Tokio channels](https://tokio.rs/tokio/tutorial/channels).
- [T3] [Tokio runtime and blocking guidance](https://docs.rs/tokio/latest/tokio/index.html).
- [T4] [Tokio spawning and concurrency](https://tokio.rs/tokio/tutorial/spawning).
- [T5] [Tokio `select!` and cancellation](https://tokio.rs/tokio/tutorial/select).
- [T6] [Tokio graceful shutdown](https://tokio.rs/tokio/topics/shutdown).
- [T7] [Tokio async testing](https://tokio.rs/tokio/topics/testing).
- [T8] [Tokio tracing](https://tokio.rs/tokio/topics/tracing).
- [T9] [Tokio `JoinSet`](https://docs.rs/tokio/latest/tokio/task/struct.JoinSet.html).
- [T10] [Tokio `spawn_blocking`](https://docs.rs/tokio/latest/tokio/task/fn.spawn_blocking.html).
- [T11] [Tokio `join!`](https://docs.rs/tokio/latest/tokio/macro.join.html).

### Database and security guidance

- [D1] [SQLx pool](https://docs.rs/sqlx/latest/sqlx/struct.Pool.html).
- [D2] [SQLx transactions](https://docs.rs/sqlx/latest/sqlx/struct.Transaction.html).
- [D3] [SQLx repository README](https://github.com/transact-rs/sqlx/blob/main/README.md).
- [S1] [OWASP REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html).
- [M1] [Microsoft Pragmatic Rust UX guidelines](https://microsoft.github.io/rust-guidelines/guidelines/libs/ux/index.html).

### Practitioner article

- [L1] [Luca Palmieri on Rust web error reporting](https://lpalmieri.com/posts/rust-web-frameworks-have-subpar-error-reporting/).
