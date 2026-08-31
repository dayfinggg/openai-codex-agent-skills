# Testing

Test providers with explicit fake dependencies before bootstrapping the full Nest application.
Use `Test.createTestingModule()` to compile the dependency graph in unit and integration tests. [Nst8]
Override database, queue, HTTP, guards, filters, and other providers rather than branching production code for tests. [Nst8]
Create and initialize a Nest application for end-to-end HTTP tests.
Use the adapter's in-process injection when the application uses Fastify, or a controlled HTTP test client otherwise. [Nst8]
Close the application in teardown so lifecycle hooks and clients run.
Test DTO validation, unknown properties, parsing, guards, filters, response redaction, and adapter-specific behavior.
Test cancellation, dependency failure, timeout, shutdown, and duplicate-response paths.
Keep real integration tests for databases, queues, TLS, proxies, and serialization.
