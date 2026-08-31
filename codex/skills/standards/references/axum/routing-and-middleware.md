# Routing and middleware

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
