# Testing

Export the Fastify factory and use `inject()` for route tests without opening a network socket. [F8]
Call `ready()` when a test must assert plugin registration or startup failure.
Close the Fastify instance in teardown so `onClose` hooks release clients and consumers.
Test plugin encapsulation by asserting which routes, decorators, hooks, and errors are visible in each scope.
Test malformed schemas, unsupported media types, oversized bodies, validation errors, and response filtering.
Test authentication, authorization, request aborts, handler timeouts, dependency failures, and duplicate sends.
Test custom error handling with both deliberate client errors and unexpected dependency errors.
Keep a small real-network suite for TLS, proxy headers, streaming, and deployment configuration.
