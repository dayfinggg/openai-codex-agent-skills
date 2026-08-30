# Gin HTTP framework

This reference covers Gin-specific routing, middleware, binding, and recovery choices.
It assumes the framework-independent rules in go-http.md.
Use Gin at the transport edge and keep application services independent of gin.Context.

## When Gin is justified

- Choose Gin when an existing service or team already relies on its routing, binding, validation, and middleware ecosystem.
- Choose Gin when those features remove current implementation cost that standard net/http does not cover.
- Prefer net/http or chi for a new small service when a full framework would add more policy than value.
- Keep gin.Context in route handlers and adapters, not in services, repositories, or domain types.
- Pin the supported Gin version and review its release notes before upgrades.
- Do not mix Gin routing with a second router abstraction in the same service.

## Router and server construction

- Use gin.New when the service needs an explicit middleware stack.
- Use gin.Default only when its built-in logger and recovery behavior are deliberately part of the service policy.
- Register route groups for shared prefixes and shared authorization policy.
- Register method-specific routes and avoid Any-style catch-all behavior for state-changing endpoints.
- Keep route registration in startup composition code rather than package init functions.
- When server timeouts, TLS, or graceful shutdown matter, pass the Gin handler to an explicit http.Server instead of hiding lifecycle in router.Run.
- Configure read, write, idle, and header limits on that http.Server.
- Keep route patterns stable for metrics and logs, and do not log raw query strings by default.

## Middleware and recovery

- Gin middleware runs in registration order before c.Next and resumes after c.Next returns.
- Keep middleware responsibilities narrow and make global, group, and route-level placement explicit.
- Put request ID, trusted proxy handling, limits, authentication, authorization, recovery, and logging in a reviewed order.
- Do not use middleware as a hidden service locator or as a place to mutate global state.
- Gin's built-in Recovery catches a panic and writes a 500, but custom recovery is needed for service-owned logging or envelopes.
- A custom recovery must write a generic 500 only when the response is not committed.
- After response commit, log the panic and abort or close according to the protocol; never write a second error body.
- Do not expose the recovered panic value, stack, or internal error text to clients.
- Ensure recovery does not run twice through Gin and an outer net/http wrapper.
- Fail closed when authentication or trusted proxy configuration is incomplete.

## Binding and validation

- Prefer ShouldBind, ShouldBindJSON, or another ShouldBind variant when the service owns the error response.
- The Bind family aborts with a 400 automatically, which can conflict with a JSON error contract or a desired 422 mapping.
- Use a dedicated input DTO with explicit json, form, uri, and header tags.
- Never bind directly into a business or persistence struct because client fields could set protected state.
- Require the documented Content-Type and choose the binder explicitly when ambiguity would change behavior.
- Wrap the request body with http.MaxBytesReader before binding JSON, multipart, or uploads.
- Return 413 for an exceeded body limit and 400 for malformed syntax.
- Validate ranges, lengths, enums, cross-field rules, and authorization after binding.
- Keep domain validation in the application service so non-HTTP callers receive the same rules.
- On a Go 1.27 toolchain, evaluate encoding/json/v2 for new APIs; it rejects duplicate names and invalid UTF-8 by default, while unknown-member rejection remains opt-in.
- For legacy encoding/json, use Decoder.DisallowUnknownFields when unknown fields are not allowed and reject trailing JSON values.
- Return safe field errors and never echo passwords, tokens, or complete request bodies.

## Context and goroutines

- Extract r.Context from c.Request and pass it to every service, database, and outbound client operation.
- Use context.Context as the first parameter below the Gin boundary.
- Do not store gin.Context or a request context in a long-lived object.
- Gin reuses gin.Context objects through a pool, so never retain the original context in a goroutine after the handler returns.
- If an unavoidable background goroutine needs read-only request metadata, follow Gin's c.Copy guidance and capture only immutable values.
- A copied context is not permission to write a response after return or to abandon cancellation and shutdown ownership.
- Give every goroutine an owner, stop condition, failure path, and join or queue lifecycle.
- Use an application context for work that intentionally outlives the request.

## Errors, security, and observability

- Map application errors to one stable public envelope at the Gin boundary.
- Use errors.Is and errors.As after lower layers wrap errors with %w.
- Return after c.JSON, c.Abort, or another terminal response operation.
- Use Secure, HttpOnly, and intentional SameSite cookie settings for session cookies.
- On Go 1.25 and later, consider http.NewCrossOriginProtection for unsafe cross-origin browser requests.
- Use html/template for HTML and never use text/template for untrusted HTML.
- Keep tokens, cookies, passwords, raw bodies, and sensitive query values out of logs.
- Emit structured logs with log/slog and record route pattern, status, duration, bytes, and request ID.
- Restrict pprof, expvar, metrics, and health details to trusted operational access.

## Testing and complexity control

- Test Gin handlers with httptest.NewRequest, httptest.NewRecorder, and the returned response.
- Test the assembled router for route groups, middleware short-circuiting, binding errors, panic recovery, and error envelopes.
- Test body limits, unknown fields, wrong media types, client cancellation, and authorization boundaries.
- Use table-driven subtests and use t.Parallel only with isolated fixtures and global Gin state.
- Run go test -race, go vet, and govulncheck in CI.
- Keep Gin adapters small enough that service tests do not need a Gin context.
- Do not add wrappers that merely rename c.JSON, c.Bind, or c.Next without owning a real policy.
- Keep one canonical implementation of validation, error mapping, request IDs, and logging.
- Review default middleware and third-party middleware for duplicate behavior and security cost.

## Sources

### Gin maintainer documentation

- [Gin quickstart](https://gin-gonic.com/en/docs/quickstart/)
- [Gin middleware](https://gin-gonic.com/en/docs/middleware/)
- [Gin using middleware](https://gin-gonic.com/en/docs/middleware/using-middleware/)
- [Gin binding](https://gin-gonic.com/en/docs/binding/)
- [Gin model binding and validation](https://gin-gonic.com/en/docs/binding/binding-and-validation/)
- [Gin custom recovery](https://gin-gonic.com/en/docs/middleware/custom-recovery/)
- [Gin goroutines inside middleware](https://gin-gonic.com/en/docs/middleware/goroutines-inside-a-middleware/)
- [Gin upload size limits](https://gin-gonic.com/en/docs/routing/upload-file/limit-bytes/)

### Official Go documentation

- [net/http package](https://pkg.go.dev/net/http)
- [context package](https://pkg.go.dev/context)
- [encoding/json](https://pkg.go.dev/encoding/json)
- [encoding/json/v2](https://pkg.go.dev/encoding/json/v2)
- [html/template](https://pkg.go.dev/html/template)
- [log/slog](https://pkg.go.dev/log/slog)
- [net/http/httptest](https://pkg.go.dev/net/http/httptest)
- [Security Best Practices for Go Developers](https://go.dev/doc/security/best-practices)
- [Data Race Detector](https://go.dev/doc/articles/race_detector)
