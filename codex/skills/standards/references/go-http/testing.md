# Testing

- Unit-test handlers with httptest.NewRequest, httptest.NewRecorder, and ResponseRecorder.Result.
- Test the assembled router with httptest.NewServer or the in-memory NewTestServer available in newer Go versions.
- Use table-driven subtests for methods, routes, DTOs, validation, authorization, and error mappings.
- Use t.Parallel only when fixtures, environment, ports, database state, and loggers are isolated.
- Test cancellation, deadlines, body limits, unknown JSON fields, malformed headers, and client disconnect behavior.
- Use a real database in focused integration tests for SQL, transactions, constraints, and migrations.
- Fuzz parsers, decoders, path handling, and request-to-domain conversion.
- Retain every discovered fuzz input as a regression seed.
- Run go test ./..., go test -race ./..., go vet ./..., and govulncheck ./... before release.
