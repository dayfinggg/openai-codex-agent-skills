# Panic recovery and middleware

- Write standard middleware as func(next http.Handler) http.Handler.
- Make middleware order explicit and test authentication, limits, recovery, logging, and tracing order.
- Recovery must track whether headers or body bytes are committed.
- Recovery may write a generic 500 only before response commit.
- After commit, recovery must log and abort or close the response, or let net/http terminate the connection; it must not append a second response.
- The standard net/http server recovers panics, logs a stack trace, and closes the connection or sends an HTTP/2 reset stream.
- Do not promise clients a 500 unless the recovery wrapper can safely send it before commit.
- Put authentication and authorization in middleware, but keep authorization decisions close to the protected route group.
- Fail closed when authentication or trusted proxy configuration is missing.
- Generate a bounded request ID when no accepted trusted ID exists.
- Use typed, unexported context keys with type-safe accessors for request metadata.
- Do not use middleware as a hidden service locator or global mutable state holder.
- Keep proxy-derived client IP headers untrusted unless the proxy topology is configured and enforced.
