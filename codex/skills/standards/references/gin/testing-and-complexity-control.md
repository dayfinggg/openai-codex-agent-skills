# Testing and complexity control

- Test Gin handlers with httptest.NewRequest, httptest.NewRecorder, and the returned response.
- Test the assembled router for route groups, middleware short-circuiting, binding errors, panic recovery, and error envelopes.
- Test body limits, unknown fields, wrong media types, client cancellation, and authorization boundaries.
- Use table-driven subtests and use t.Parallel only with isolated fixtures and global Gin state.
- Run go test -race, go vet, and govulncheck in CI.
- Keep Gin adapters small enough that service tests do not need a Gin context.
- Do not add wrappers that merely rename c.JSON, c.Bind, or c.Next without owning a real policy.
- Keep one canonical implementation of validation, error mapping, request IDs, and logging.
- Review default middleware and third-party middleware for duplicate behavior and security cost.
