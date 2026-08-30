# chi HTTP router

This reference covers chi as a focused router and middleware layer for Go HTTP services.
It assumes the framework-independent rules in go-http.md.
Use chi for a concrete routing or composition need, not as a ritual layer around every handler.

## When chi is justified

- Choose chi when route groups, subrouters, mounts, or inline middleware materially reduce routing complexity.
- Choose chi when preserving standard http.Handler signatures is an explicit interoperability requirement.
- Keep net/http when Go 1.22 ServeMux already expresses the route tree and no chi-specific capability is needed.
- Do not add chi only to rename paths or wrap a single handler.
- Keep one router abstraction in a service and document the dependency decision.
- Pin the major import path and review chi changes before upgrades.

## Router assembly

- Construct one chi.NewRouter during startup and pass it as the http.Server Handler.
- Register routes near the feature that owns them, then mount feature routers from one composition point.
- Use method-specific helpers such as Get, Post, Put, Patch, and Delete.
- Use Route or Group for a shared prefix and shared policy.
- Use With for a narrow middleware stack on one endpoint.
- Use Mount to attach a separately owned http.Handler without changing its contract.
- Define NotFound and MethodNotAllowed responses with the same public error envelope as normal handlers.
- Keep route patterns explicit and avoid a catch-all route that hides missing registrations.
- Treat URL parameters as untrusted strings and parse or validate them in the transport boundary.
- Use chi.URLParam only at the HTTP edge, then pass typed values to the service.
- Generate route documentation from the router when the API contract needs a route inventory.
- Keep route pattern names stable so request metrics do not use raw, high-cardinality URLs.

## Middleware order

- chi middleware uses the standard func(next http.Handler) http.Handler shape.
- Put request ID and trusted proxy extraction before request logging when logs need those fields.
- Put recovery around application handlers and ensure it understands response commit state.
- Write a generic 500 only before commit; after commit, log and abort or close rather than append a second body.
- Put body-size and content-type limits before decoding.
- Put authentication before authorization and attach only a verified principal.
- Add route-group authorization at the group that owns the policy.
- Keep middleware short and explicit; a middleware should have one cross-cutting responsibility.
- Do not hide database access or business decisions in middleware.
- Do not register chi middleware and an equivalent outer middleware twice.
- Review built-in middleware semantics, especially client IP, timeout, logger, recoverer, and path cleanup behavior.
- Treat client IP headers as untrusted unless the deployment has a known proxy trust chain.
- Use a request context derived from r.Context for deadlines and request-scoped metadata.

## Handlers, errors, and context

- Keep chi handlers as ordinary http.HandlerFunc values so services and tests do not depend on chi.
- Read and validate path, query, header, and body values before calling the application service.
- Use dedicated DTOs and never bind directly into a business or persistence struct.
- Use one error mapping function at the HTTP boundary and return after it writes.
- Wrap lower-layer errors with %w and classify them with errors.Is or errors.As.
- Pass context.Context as the first argument to services, repositories, and clients.
- Use context values only for request-scoped metadata and package-owned typed keys.
- Do not store chi.Context or a request context in a long-lived struct.
- Do not write a response from a goroutine after the handler returns.
- Keep background work on an application lifecycle context or a durable queue.

## Security and operations

- Put chi behind an explicit http.Server with read, write, idle, and header limits.
- Use http.MaxBytesReader for JSON, form, multipart, and upload endpoints.
- Use TLS and secure cookie attributes according to the service's deployment policy.
- On Go 1.25 and later, consider http.NewCrossOriginProtection for unsafe cross-origin browser requests.
- Keep auth tokens, cookies, query secrets, and request bodies out of logs.
- Log the chi route pattern, not the raw path, as the primary request dimension.
- Use log/slog or one existing structured logger and pass request context to it.
- Keep pprof and expvar on a restricted operational listener.

## Testing and complexity control

- Test chi route matching and middleware order with httptest.NewRequest and httptest.NewRecorder.
- Use an httptest server for tests that need real client behavior, redirects, cookies, or HTTP/2.
- Test not found, method not allowed, malformed parameters, body limits, auth failures, and panic recovery.
- Run tests with -race when middleware or handlers share state.
- Run go vet and govulncheck as part of dependency and release checks.
- Keep chi-specific types out of services, repositories, and domain packages.
- Prefer one small chi adapter over multiple helper layers that only forward calls.
- Do not create a package per route when a feature module can own its routes, handlers, and tests together.

## Sources

### chi maintainer documentation

- [chi repository and README](https://github.com/go-chi/chi)

### Official Go documentation

- [net/http package](https://pkg.go.dev/net/http)
- [context package](https://pkg.go.dev/context)
- [net/http/httptest](https://pkg.go.dev/net/http/httptest)
- [log/slog](https://pkg.go.dev/log/slog)
- [Security Best Practices for Go Developers](https://go.dev/doc/security/best-practices)
- [Go Security](https://go.dev/doc/security/)
