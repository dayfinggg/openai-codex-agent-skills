# Concurrency, security, and operations

- Assume handler calls overlap because the server invokes handlers from service goroutines.
- Keep per-request state local and protect shared mutable state with a mutex, atomic, or owner goroutine.
- Bound workers, queues, fan-out, retries, and connection pools.
- Give every goroutine an owner, stop condition, failure path, and shutdown join.
- Do not reuse a request context for work that must survive the response; enqueue a job with its own lifecycle.
- Use Secure, HttpOnly, and an intentional SameSite mode for session cookies.
- On Go 1.25 and later, consider http.NewCrossOriginProtection for unsafe cross-origin browser requests, but still keep safe methods free of state changes.
- Use html/template for HTML because it performs contextual escaping.
- Keep tokens, cookies, passwords, full bodies, and sensitive query values out of logs.
- Emit structured records with log/slog and pass request context to context-aware log methods.
- Log method, route pattern, status, duration, bytes, request ID, and sampled trace identifiers.
- Protect net/http/pprof and expvar on a separate listener or authenticated network-restricted route.
- Keep supported Go and module versions current and run govulncheck in CI.
