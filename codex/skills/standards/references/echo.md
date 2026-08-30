# Echo HTTP framework

This reference covers Echo-specific routing, context, binding, middleware, and error handling.
It assumes the framework-independent rules in go-http.md.
Use Echo at the transport edge and pass ordinary context.Context and DTOs below that boundary.

## When Echo is justified

- Choose Echo when an existing service or team needs its routing, binding, middleware, rendering, or centralized error pipeline.
- Prefer net/http or chi for a new small service when Echo would add unused policy or lifecycle surface.
- Echo v5 uses the github.com/labstack/echo/v5 import path and requires Go 1.25 or newer.
- Pin the major version and confirm the service toolchain before adopting Echo v5.
- Keep echo.Context out of services, repositories, domain entities, and persistence models.
- Do not mix Echo routing with a second router abstraction in one service.

## Router and server construction

- Construct one Echo instance during startup and register routes from feature-owned composition functions.
- Use method-specific helpers such as GET, POST, PUT, PATCH, and DELETE.
- Use groups for a shared prefix and shared authentication or authorization middleware.
- Echo prioritizes static routes over parameter routes and parameter routes over wildcards.
- Avoid Any for state-changing endpoints because it accepts every HTTP method.
- Keep route patterns stable for logs, metrics, and API documentation.
- Pass Echo as the Handler of an explicit http.Server when TLS, timeouts, or graceful shutdown need service-owned control.
- Configure read, write, idle, and header limits on that server.
- Keep startup errors fatal and observe server errors until shutdown.

## Middleware and panic recovery

- Echo middleware uses func(next echo.HandlerFunc) echo.HandlerFunc and can run before and after the next handler.
- Keep middleware order explicit across request IDs, limits, authentication, authorization, recovery, logging, and tracing.
- Return errors from handlers and middleware so the centralized error handler owns response formatting.
- Do not write a response and then return an unrelated error that could trigger a second response.
- Echo's Recover middleware should report the panic and pass control to the centralized HTTPErrorHandler.
- The error handler must inspect whether the response is already committed.
- Write a generic 500 only before commit; after commit, log and abort or close according to the protocol.
- Never append an error body after a partial success response.
- Do not expose panic values, stack traces, or internal error messages.
- Avoid duplicate recovery and request logging from Echo and an outer net/http layer.
- Keep proxy-derived client IPs untrusted until the deployment trust chain is configured.

## Binding and validation

- Echo binding can read path parameters, query parameters, headers, and request bodies.
- Use explicit binding tags and choose one source when precedence could change the result.
- Bind into a dedicated DTO and map fields explicitly into a business or persistence type.
- Never bind directly into a struct that contains protected fields such as IsAdmin.
- Require the documented Content-Type and reject unsupported media types explicitly.
- Wrap the request body with http.MaxBytesReader before binding JSON, multipart, or uploads.
- Return 413 for an exceeded body limit and 400 for malformed syntax.
- Validate ranges, lengths, enums, cross-field constraints, and authorization after binding.
- Keep domain invariants in the application service so all callers share the rules.
- On a Go 1.27 toolchain, evaluate encoding/json/v2 for new JSON; duplicate names and invalid UTF-8 are rejected by default, while unknown-member rejection is opt-in.
- For legacy encoding/json, use Decoder.DisallowUnknownFields when unknown fields are not part of the contract and reject trailing values.
- Return safe field-level errors without echoing secrets or complete request bodies.

## Context, ownership, and errors

- Extract the standard request context from c.Request and pass it as the first parameter below the Echo boundary.
- Do not store echo.Context or a request context in long-lived structs.
- Use context-aware database and outbound HTTP operations and derive narrower dependency deadlines.
- Do not write ResponseWriter data from a goroutine after the handler returns.
- Give background work an application lifecycle context, owner, stop condition, and shutdown join.
- Map domain errors to one stable public envelope in the centralized error handler.
- Use errors.Is and errors.As after lower layers wrap causes with %w.
- Check Echo's committed-response state before writing an error response.
- Keep transaction ownership in the service or repository layer rather than in an Echo handler.

## Security and observability

- Use Secure, HttpOnly, and intentional SameSite settings for session cookies.
- On Go 1.25 and later, consider http.NewCrossOriginProtection for unsafe cross-origin browser requests.
- Use html/template for HTML and never use text/template for untrusted HTML.
- Keep tokens, cookies, passwords, raw bodies, and sensitive query values out of logs.
- Use Echo's slog-compatible logger or one existing structured logger, not several competing request loggers.
- Log route pattern, method, status, duration, bytes, request ID, and sampled trace identifiers.
- Keep metrics and diagnostic endpoints on a restricted operational listener or route.
- Protect pprof and expvar because they expose process and runtime information.
- Expose cheap liveness and dependency-aware readiness endpoints separately.

## Lifecycle, testing, and complexity control

- Prefer Echo StartConfig with a cancellable context and GracefulTimeout when that matches the service lifecycle.
- Use http.Server.Shutdown with a deadline when the application owns server construction.
- Close databases and clients after active requests and owned workers have stopped.
- Test Echo handlers and routes with httptest.NewRequest, httptest.NewRecorder, or an httptest server.
- Test route precedence, groups, middleware short-circuiting, binding precedence, committed-response recovery, and error envelopes.
- Test body limits, unknown JSON fields, wrong media types, cancellation, and authorization.
- Use table-driven subtests and use t.Parallel only with isolated fixtures and global Echo state.
- Run go test -race, go vet, and govulncheck in CI.
- Keep Echo adapters small enough that service tests do not construct echo.Context.
- Do not add wrappers that only forward c.JSON, c.Bind, or next(c) without owning a real policy.
- Keep one canonical implementation of decoding, validation, errors, request IDs, and logging.
- Review built-in and third-party middleware for duplicate behavior, maintenance cost, and security impact.

## Sources

### Echo maintainer documentation

- [Echo installation and version requirements](https://echo.labstack.com/guide/installation/)
- [Echo repository and README](https://github.com/labstack/echo)
- [Echo routing](https://echo.labstack.com/guide/routing/)
- [Echo context](https://echo.labstack.com/guide/context/)
- [Echo binding](https://echo.labstack.com/guide/binding/)
- [Echo error handling](https://echo.labstack.com/guide/error-handling/)
- [Echo customization](https://echo.labstack.com/guide/customization/)
- [Echo custom middleware](https://echo.labstack.com/cookbook/middleware/)
- [Echo graceful shutdown](https://echo.labstack.com/cookbook/graceful-shutdown/)

### Official Go documentation

- [net/http package](https://pkg.go.dev/net/http)
- [context package](https://pkg.go.dev/context)
- [encoding/json](https://pkg.go.dev/encoding/json)
- [encoding/json/v2](https://pkg.go.dev/encoding/json/v2)
- [html/template](https://pkg.go.dev/html/template)
- [log/slog](https://pkg.go.dev/log/slog)
- [net/http/httptest](https://pkg.go.dev/net/http/httptest)
- [database/sql package](https://pkg.go.dev/database/sql)
- [Security Best Practices for Go Developers](https://go.dev/doc/security/best-practices)
- [Data Race Detector](https://go.dev/doc/articles/race_detector)
