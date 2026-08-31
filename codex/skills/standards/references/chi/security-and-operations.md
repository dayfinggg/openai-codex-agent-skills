# Security and operations

- Put chi behind an explicit http.Server with read, write, idle, and header limits.
- Use http.MaxBytesReader for JSON, form, multipart, and upload endpoints.
- Use TLS and secure cookie attributes according to the service's deployment policy.
- On Go 1.25 and later, consider http.NewCrossOriginProtection for unsafe cross-origin browser requests.
- Keep auth tokens, cookies, query secrets, and request bodies out of logs.
- Log the chi route pattern, not the raw path, as the primary request dimension.
- Use log/slog or one existing structured logger and pass request context to it.
- Keep pprof and expvar on a restricted operational listener.
