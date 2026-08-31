# Testing and complexity control

- Test chi route matching and middleware order with httptest.NewRequest and httptest.NewRecorder.
- Use an httptest server for tests that need real client behavior, redirects, cookies, or HTTP/2.
- Test not found, method not allowed, malformed parameters, body limits, auth failures, and panic recovery.
- Run tests with -race when middleware or handlers share state.
- Run go vet and govulncheck as part of dependency and release checks.
- Keep chi-specific types out of services, repositories, and domain packages.
- Prefer one small chi adapter over multiple helper layers that only forward calls.
- Do not create a package per route when a feature module can own its routes, handlers, and tests together.
