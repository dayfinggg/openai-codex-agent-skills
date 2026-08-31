# Errors, security, and observability

- Map application errors to one stable public envelope at the Gin boundary.
- Use errors.Is and errors.As after lower layers wrap errors with %w.
- Return after c.JSON, c.Abort, or another terminal response operation.
- Use Secure, HttpOnly, and intentional SameSite cookie settings for session cookies.
- On Go 1.25 and later, consider http.NewCrossOriginProtection for unsafe cross-origin browser requests.
- Use html/template for HTML and never use text/template for untrusted HTML.
- Keep tokens, cookies, passwords, raw bodies, and sensitive query values out of logs.
- Emit structured logs with log/slog and record route pattern, status, duration, bytes, and request ID.
- Restrict pprof, expvar, metrics, and health details to trusted operational access.
