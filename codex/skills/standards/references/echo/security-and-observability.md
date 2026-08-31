# Security and observability

- Use Secure, HttpOnly, and intentional SameSite settings for session cookies.
- On Go 1.25 and later, consider http.NewCrossOriginProtection for unsafe cross-origin browser requests.
- Use html/template for HTML and never use text/template for untrusted HTML.
- Keep tokens, cookies, passwords, raw bodies, and sensitive query values out of logs.
- Use Echo's slog-compatible logger or one existing structured logger, not several competing request loggers.
- Log route pattern, method, status, duration, bytes, request ID, and sampled trace identifiers.
- Keep metrics and diagnostic endpoints on a restricted operational listener or route.
- Protect pprof and expvar because they expose process and runtime information.
- Expose cheap liveness and dependency-aware readiness endpoints separately.
