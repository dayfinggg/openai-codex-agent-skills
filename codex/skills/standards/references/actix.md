# Actix Web framework reference

Read `rust.md` first for language-wide ownership, error, async, testing, and abstraction rules.
This reference adds Actix Web, Actix runtime, and ecosystem integration details without repeating that baseline.
Read documentation that matches the Actix Web version in `Cargo.lock`.

## Application factory and state

- Keep `main` responsible for configuration, resource construction, `HttpServer` setup, and shutdown.
- Keep the `HttpServer::new` factory cheap because Actix instantiates an application per worker [B1].
- Actix starts one worker per available physical CPU by default, and `.workers(n)` changes that count [B1].
- Build shared pools, clients, and `web::Data` outside the factory when every worker must use the same resource [B1].
- Extract application data with `web::Data<T>`; handlers receive a read-only reference unless `T` provides explicit interior mutability [B2].
- Use `Arc`, atomics, locks, or an owner task deliberately when state must cross worker boundaries [B1].
- Remember that nested scopes resolve the closest data value, so scope-local data can shadow app-level data [B13].
- Keep worker-local state only when per-worker isolation is intentional and documented.

## Handlers and extractors

- Actix handlers are async functions whose parameters implement `FromRequest` and whose result implements `Responder` [B2].
- Use typed `web::Path`, `web::Query`, headers, `web::Json`, `web::Form`, and `web::Data` to make the request contract visible.
- Only the first body-reading extractor can consume a request; use `Either` when the endpoint intentionally accepts fallback body types [B2].
- Configure `JsonConfig`, `FormConfig`, `PathConfig`, or `PayloadConfig` at the app, scope, or resource boundary [B2] [B7].
- Give JSON and form routes explicit size and content-type policies instead of inheriting a permissive default [B7].
- Treat raw `web::Payload` as an advanced boundary and use `to_bytes_limited` rather than unbounded buffering [B8].
- Write a focused custom extractor for authentication or reusable validation, and return a stable rejection before application code runs.
- Validate lengths, ranges, formats, content types, and allowed values before invoking a use case [S1].
- Keep extractor failures free of database, parser, filesystem, and stack-trace details.

## Middleware and ordering

- Register middleware with `App::wrap`, `Scope::wrap`, or `Resource::wrap`, and keep cross-cutting work out of handlers [B3].
- Actix executes middleware in the opposite direction from registration, so `.wrap(first).wrap(second)` makes `second` see the request first [B3].
- The response then traverses the same chain in reverse, so write response cleanup with that nesting in mind.
- Use `middleware::from_fn` for a small local middleware and `Transform` plus `Service` for reusable or configurable middleware [B3].
- Add `Logger` or a tracing middleware at the application boundary, and configure it for every `App` instance [B3].
- Use `ErrorHandlers` when status-based response rewriting is required, and keep its output consistent with the API error contract [B3].
- Put request ID creation and credential redaction where every protected scope observes them.
- Require an ordering test for every critical chain, such as request ID, authentication, body limit, timeout, handler, and response logging.
- Make the test record entry and exit markers and assert the exact sequence rather than trusting nested `.wrap` calls by inspection.

## Error handling

- Return `Result<T, E>` from handlers when `E` can convert to `actix_web::Error` and implements `ResponseError` for custom status mapping [B4].
- Use error helpers or a bounded `ResponseError` implementation for validation, authentication, conflict, timeout, and dependency failures [B4].
- Keep public error bodies generic while retaining causes and safe context for logs [S1].
- Actix logs errors at `WARN`; use `RUST_LOG` and `RUST_BACKTRACE` deliberately and avoid sending those diagnostics to clients [B4].
- Log each failure at one ownership boundary with request ID, route, status, and source fields.
- Do not use panics as request control flow, and keep response conversion separate from domain error construction.
- Review `ResponseError` status and body changes as API compatibility changes [L1].

## Runtime and concurrency

- Actix Web runs on Tokio, and each server worker uses a single-threaded runtime [B9].
- Each worker processes its requests sequentially, so blocking a handler, extractor, lock, or destructor stalls that worker [B1].
- Use async network and database clients, and avoid synchronous filesystem, DNS, compression, or CPU work in request futures.
- Use `web::block` or `actix_web::rt::task::spawn_blocking` for bounded blocking operations [B10] [T10].
- Bound CPU-heavy jobs with a semaphore or dedicated pool, and use a dedicated thread for long-lived blocking loops [B10] [T10].
- Use a bounded channel and an owner task when a shared client or mutable resource should have one clear owner [T2].
- Keep lock guards short and never hold a blocking lock across `.await` [T1].
- Use `#[tokio::main]` when the surrounding application needs Tokio's work-stealing runtime, but use `#[actix_web::main]` for Actix actor support and its local task system [B9].
- Track spawned background work with join handles or `JoinSet`; do not detach work whose failure affects service correctness [T9].
- Use cancellation-aware `select!` and make request side effects safe if a future is dropped [T5].

## Database boundary

- Create one async database pool before `HttpServer::new`, wrap the shared handle in `web::Data`, and clone the handle into each app instance [D1] [B1].
- Keep SQL, row mapping, and driver errors in a repository or infrastructure module rather than in route modules.
- Let an application service own use-case transaction scope and keep transactions narrow [D2].
- Acquire connections close to the query and release them before unrelated awaits.
- Use bound parameters and database constraints, and consider SQLx compile-time checked queries when SQLx is selected [D3].
- Configure pool size, acquire timeout, query timeout, and shutdown behavior from deployment limits [D1].
- Test migrations, constraints, query shape, and rollback against an isolated real database.

## Security

- Configure TLS with a maintained Rustls or OpenSSL integration, or terminate TLS at a trusted edge [B1].
- Configure `actix-cors` with exact origins, methods, and headers when browser clients need cross-origin access [B5].
- Never combine credentialed CORS with a wildcard origin, and disable CORS when cross-origin calls are not required [B5] [S1].
- Set per-route JSON, form, payload, and upload limits, including limits for custom extractors [B7] [B8] [S1].
- Authenticate in middleware or an extractor, then authorize the requested resource, owner, method, and workflow transition on the server [S1].
- Keep tokens and API keys out of URLs, and redact credentials and personal data from request logs [S1].
- Reject unexpected methods and content types with semantically correct 4xx responses [S1].
- Treat forwarded host, scheme, and client-IP headers as untrusted until the proxy path is explicit.
- Add rate or concurrency limits to expensive and credentialed endpoints, and return 429 when policy rejects excess traffic [S1].

## Observability

- Initialize the logging or tracing subscriber before starting the server, and configure filters from deployment settings [T8].
- Use Actix `Logger` for access records and a tracing middleware when spans, metrics, or distributed context are required [B3] [B12].
- Record method, route template, status, latency, request ID, and failure category without placing user IDs in metric label values.
- Keep request IDs and trace context available to downstream services, and redact cookies, authorization headers, and bodies.
- Measure request count, in-flight requests, latency distributions, status classes, payload rejections, and dependency outcomes.
- Measure database pool wait separately from query execution so pool saturation is visible.
- Use the maintained telemetry workshop example as a reference for request spans, concurrency gauges, duration histograms, and success labels [B12].

## Testing and shutdown

- Build an app factory that accepts test state and does not bind a socket.
- Use `test::init_service`, `TestRequest`, and `call_service` for application-level tests [B6].
- Cover success, not-found, malformed input, extractor rejection, body limits, authentication, authorization, and error bodies.
- Add an explicit middleware-order test for each security and reliability chain.
- Unit-test custom extractors, middleware, `ResponseError` conversions, and pure application services without starting workers [B6].
- Use paused Tokio time for retry and timeout tests, and mock async I/O instead of sleeping [T7].
- Test migrations, constraints, transaction behavior, and pool failures against an isolated real database.
- Wire `HttpServer` shutdown signals and `shutdown_timeout` to cancellation, stop readiness before draining, await owned tasks, and close the pool [B1] [D1] [T6].
- Remember that `spawn_blocking` work cannot be force-cancelled after it starts, so give it bounded inputs and a shutdown plan [T10].

## Abstraction discipline

- Keep application services independent of Actix request and response types, and adapt at the handler boundary.
- Prefer Actix's native extractors, middleware, and `ResponseError` over a second framework-neutral service abstraction.
- Use concrete dependencies and narrow traits for real seams instead of a trait object for every client [M1].
- Avoid deep generic handler wrappers that obscure `FromRequest`, `Responder`, lifetimes, and error types.
- Hide `Arc`, locks, and worker-sharing details behind named services unless ownership is the API's purpose [M1].
- Revisit an abstraction when it makes worker ownership, middleware order, tracing, or shutdown harder to test.

## Sources

### Actix Web documentation

- [B1] [Actix Web server, workers, TLS, and shutdown](https://actix.rs/docs/server/).
- [B2] [Actix Web extractors](https://actix.rs/docs/extractors/).
- [B3] [Actix Web middleware](https://actix.rs/docs/middleware/).
- [B4] [Actix Web errors](https://actix.rs/docs/errors/).
- [B5] [Actix Web CORS](https://actix.rs/docs/cors/).
- [B6] [Actix Web testing](https://actix.rs/docs/testing/).
- [B7] [Actix `PayloadConfig`](https://docs.rs/actix-web/latest/actix_web/web/struct.PayloadConfig.html).
- [B8] [Actix raw payload limits](https://docs.rs/actix-web/latest/actix_web/web/struct.Payload.html).
- [B9] [Actix Web runtime](https://docs.rs/actix-web/latest/actix_web/rt/).
- [B10] [Actix `web::block`](https://docs.rs/actix-web/latest/actix_web/web/fn.block.html).
- [B13] [Actix `web::Data`](https://docs.rs/actix-web/latest/actix_web/web/struct.Data.html).

### Tokio and database guidance

- [T1] [Tokio shared state](https://tokio.rs/tokio/tutorial/shared-state).
- [T2] [Tokio channels](https://tokio.rs/tokio/tutorial/channels).
- [T5] [Tokio `select!` and cancellation](https://tokio.rs/tokio/tutorial/select).
- [T6] [Tokio graceful shutdown](https://tokio.rs/tokio/topics/shutdown).
- [T7] [Tokio async testing](https://tokio.rs/tokio/topics/testing).
- [T8] [Tokio tracing](https://tokio.rs/tokio/topics/tracing).
- [T9] [Tokio `JoinSet`](https://docs.rs/tokio/latest/tokio/task/struct.JoinSet.html).
- [T10] [Tokio `spawn_blocking`](https://docs.rs/tokio/latest/tokio/task/fn.spawn_blocking.html).
- [D1] [SQLx pool](https://docs.rs/sqlx/latest/sqlx/struct.Pool.html).
- [D2] [SQLx transactions](https://docs.rs/sqlx/latest/sqlx/struct.Transaction.html).
- [D3] [SQLx repository README](https://github.com/transact-rs/sqlx/blob/main/README.md).

### Maintainer examples

- [B11] [Actix examples repository](https://github.com/actix/examples).
- [B12] [Actix telemetry workshop example](https://github.com/actix/examples/blob/main/tracing/mainmatter-workshop/README.md).

### Security and team guidance

- [S1] [OWASP REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html).
- [M1] [Microsoft Pragmatic Rust UX guidelines](https://microsoft.github.io/rust-guidelines/guidelines/libs/ux/index.html).

### Practitioner articles and talks

- [L1] [Luca Palmieri on Rust web error reporting](https://lpalmieri.com/posts/rust-web-frameworks-have-subpar-error-reporting/).
- [V1] [Luca Palmieri, “Rust for Web Development?” video interview](https://www.youtube.com/watch?v=F0666gGub1U).
