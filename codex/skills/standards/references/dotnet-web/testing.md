# Testing

- Unit-test domain and application decisions with fakes at real boundaries and keep those tests fast.
- Use focused integration tests to exercise routing, middleware, binding, authentication, persistence, and serialization together.
- Use `WebApplicationFactory<TEntryPoint>` and `TestServer` or the current equivalent to bootstrap the real app in-process.
- Test Minimal API handlers as named methods when `TypedResults` makes status and payload types directly assertable.
- Keep integration tests for the most important infrastructure scenarios instead of repeating every unit-test permutation.
- Override services and configuration through a custom web-application factory rather than changing production startup code for tests.
- Assert status codes, headers, problem-details fields, authorization failures, validation failures, and cancellation behavior as part of the API contract.
- Run a small set of provider-backed EF tests when query translation, transactions, or constraints matter.
- Keep unit and integration test projects separate so infrastructure dependencies do not leak into fast tests.
