# Lifecycle, testing, and complexity control

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
