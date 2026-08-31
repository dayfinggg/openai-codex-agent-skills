# Dependency injection

- Register dependencies in the composition root and group related registrations behind focused `Add{Feature}` extension methods.
- Use constructor injection for classes and handler or method injection for request-scoped endpoint dependencies.
- Use transient for independent short-lived services, scoped for request or unit-of-work state, and singleton only for thread-safe process-wide state.
- Never capture a scoped service inside a singleton without creating an explicit scope for each operation.
- Keep `DbContext` scoped by default and do not register it as a singleton.
- Prefer injected dependencies over `IServiceProvider`, `RequestServices`, static state, or `IHttpContextAccessor` access.
- For conventional middleware, inject scoped services into `Invoke` or `InvokeAsync`, or use factory-based middleware.
- Use `IHttpClientFactory` for outbound HTTP clients instead of constructing and disposing a client per request.
- Enable scope validation in development and test builds so captive dependencies fail early.
