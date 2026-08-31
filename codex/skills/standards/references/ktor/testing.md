# Testing
- Unit-test domain rules and application services without a Ktor engine when possible.
- Use `testApplication` to run calls in memory without binding a real server socket.
- Configure the same modules and test client plugins that production routes require.
- Override DI providers with fakes before loading modules, then add a smaller number of end-to-end tests.
- Test validation, error mapping, authorization, timeout, cancellation, and serialization behavior through the application pipeline.
- Use external-service mocks for deterministic contract tests and a real server test only when engine behavior matters.
- Use real containers for database behavior that in-memory fakes cannot prove.
