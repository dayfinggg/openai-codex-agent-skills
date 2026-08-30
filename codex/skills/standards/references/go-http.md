# Go HTTP backend

This reference covers framework-independent Go HTTP services built on net/http.
Use it as the baseline for chi, Gin, and Echo applications.
Keep boundaries where they provide independent ownership, replacement, persistence, or focused testing.

## Router and server

- Start with a private http.ServeMux and an explicit http.Server.
- Avoid DefaultServeMux and package-global registration because they hide route ownership and complicate tests.
- On Go 1.22 and later, use method-aware and wildcard-aware ServeMux patterns when they express the contract clearly.
- Treat route registration as startup configuration because invalid or conflicting patterns panic during registration.
- Use one router per server and expose its http.Handler to the server constructor.
- Use method-specific routes and make 404 and 405 behavior explicit.
- Keep route patterns stable enough to use as metric and log dimensions.
- Configure ReadHeaderTimeout, ReadTimeout where appropriate, WriteTimeout, IdleTimeout, and MaxHeaderBytes for the deployment and endpoint mix.
- Give each slow dependency a narrower context deadline than the overall request budget.
- Serve production traffic over HTTPS with managed certificates and a reviewed TLS policy.
- Keep crypto/tls defaults unless compatibility or compliance requires an explicit change.
- Never use InsecureSkipVerify in production.
- Start the server in a goroutine only when the lifecycle owner waits for it and observes startup errors.
- On shutdown, stop accepting work, call Server.Shutdown with a deadline, wait for owned workers, then close databases and clients.
- Handle hijacked connections such as WebSockets separately because Server.Shutdown does not wait for them.

## Handler boundary

- Implement http.Handler or http.HandlerFunc and return after writing the response.
- Let a handler translate HTTP input and output, but keep business rules in an application service.
- Keep SQL, retries, and external API policy out of handlers.
- Inject services and repositories through constructors so tests can replace them without globals.
- Read all required request data before writing headers or a body.
- Set Content-Type and other headers before the first WriteHeader or Write.
- Call WriteHeader once for non-OK responses and return immediately after an error response.
- Never use ResponseWriter or Request.Body after ServeHTTP returns or from a goroutine that outlives the handler.
- Use http.MaxBytesReader or http.MaxBytesHandler for every endpoint that accepts a body.
- Return 413 Request Entity Too Large when a body or upload exceeds its endpoint limit.
- Stream large bodies rather than buffering unbounded input or output.
- Use http.ServeContent or http.FileServerFS only with controlled filesystem roots and validated names.
- Return a stable error envelope with a public code, safe message, and request identifier.
- Map internal errors to public responses in one transport boundary.

## Panic recovery and middleware

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

## Context, validation, and JSON

- Take context.Context as the first parameter of service, repository, and client methods.
- Start request work from r.Context and preserve it through database and outbound HTTP calls.
- Derive a narrower timeout for each slow dependency and always call its cancel function.
- Use http.NewRequestWithContext for outbound calls so dialing, headers, and body reads share the deadline.
- Stop loops and goroutines when ctx.Done closes.
- Do not store a context in a struct, pass nil contexts, or use values for ordinary parameters.
- Validate method, route values, query values, headers, media type, body size, syntax, and domain invariants separately.
- Parse numeric, time, enum, and identifier values with typed parsers and reject overflow or trailing junk.
- Use dedicated input DTOs with allowlisted fields instead of binding into business or persistence structs.
- Require the documented media type and reject unsupported Content-Type values explicitly.
- Decode one JSON value and then require end-of-input so concatenated values are not silently accepted.
- Use Decoder.DisallowUnknownFields for legacy encoding/json DTOs when unknown fields are not part of the contract.
- When the toolchain includes Go 1.27 encoding/json/v2, prefer it for new JSON where compatible.
- encoding/json/v2 rejects duplicate object names and invalid UTF-8 by default, but unknown-member rejection remains opt-in with RejectUnknownMembers.
- Return field-level validation details without echoing secrets or full attacker-controlled payloads.

## Errors and database

- Add operation context with %w when callers should inspect an underlying error.
- Use errors.Is for stable categories and errors.As for typed details across wrapping.
- Define domain errors for not found, conflict, invalid input, forbidden, and dependency failure when callers need stable categories.
- Map domain errors to HTTP statuses only at the transport boundary.
- Keep internal details in logs and expose short, stable client messages.
- Open one long-lived *sql.DB per database and share it safely across handlers.
- Pass request-derived contexts to QueryContext, ExecContext, QueryRowContext, and BeginTx.
- Use placeholders and driver arguments; never assemble SQL with fmt.Sprintf or concatenation.
- Map sql.ErrNoRows to a domain not-found result.
- Close Rows on every path and check Rows.Err after iteration.
- Run all operations that must be atomic through sql.Tx and do not call sql.DB methods inside that transaction.
- Tune pool limits from observed database capacity and monitor DB.Stats.
- Use a short PingContext for readiness, not for every application request.

## Concurrency, security, and operations

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

## Testing

- Unit-test handlers with httptest.NewRequest, httptest.NewRecorder, and ResponseRecorder.Result.
- Test the assembled router with httptest.NewServer or the in-memory NewTestServer available in newer Go versions.
- Use table-driven subtests for methods, routes, DTOs, validation, authorization, and error mappings.
- Use t.Parallel only when fixtures, environment, ports, database state, and loggers are isolated.
- Test cancellation, deadlines, body limits, unknown JSON fields, malformed headers, and client disconnect behavior.
- Use a real database in focused integration tests for SQL, transactions, constraints, and migrations.
- Fuzz parsers, decoders, path handling, and request-to-domain conversion.
- Retain every discovered fuzz input as a regression seed.
- Run go test ./..., go test -race ./..., go vet ./..., and govulncheck ./... before release.

## Sources

### Official Go documentation

- [net/http package](https://pkg.go.dev/net/http)
- [Routing Enhancements for Go 1.22](https://go.dev/blog/routing-enhancements)
- [context package](https://pkg.go.dev/context)
- [database/sql package](https://pkg.go.dev/database/sql)
- [Accessing relational databases](https://go.dev/doc/database/)
- [Executing SQL statements that do not return data](https://go.dev/doc/database/change-data)
- [Querying for data](https://go.dev/doc/database/querying)
- [Executing transactions](https://go.dev/doc/database/execute-transactions)
- [Managing connections](https://go.dev/doc/database/manage-connections)
- [Canceling in-progress operations](https://go.dev/doc/database/cancel-operations)
- [encoding/json](https://pkg.go.dev/encoding/json)
- [encoding/json/v2](https://pkg.go.dev/encoding/json/v2)
- [crypto/tls](https://pkg.go.dev/crypto/tls)
- [html/template](https://pkg.go.dev/html/template)
- [log/slog](https://pkg.go.dev/log/slog)
- [net/http/httptest](https://pkg.go.dev/net/http/httptest)
- [testing package](https://pkg.go.dev/testing)
- [expvar](https://pkg.go.dev/expvar)
- [net/http/pprof](https://pkg.go.dev/net/http/pprof)

### Go team guidance

- [Go Concurrency Patterns: Context](https://go.dev/blog/context)
- [Working with Errors in Go 1.13](https://go.dev/blog/go1.13-errors)
- [Structured Logging with slog](https://go.dev/blog/slog)
- [Security Best Practices for Go Developers](https://go.dev/doc/security/best-practices)
- [Go Security](https://go.dev/doc/security/)
- [Data Race Detector](https://go.dev/doc/articles/race_detector)
- [Getting started with fuzzing](https://go.dev/doc/tutorial/fuzz)
