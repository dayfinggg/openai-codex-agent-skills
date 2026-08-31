# Security and performance

Apply Helmet before routes and other setup that may call `app.use()` or register routes. [Nst9]
Use `helmet` with the Express adapter and `@fastify/helmet` as a Fastify plugin with the Fastify adapter. [Nst9]
Use TLS or a trusted reverse proxy and configure proxy trust for the real topology.
Use secure, HttpOnly, scoped cookies and conservative CORS and CSRF policies.
Apply authentication before authorization and keep authorization checks in guards or providers.
Rate-limit login, token, upload, search, and resource-amplifying endpoints.
Keep secrets in protected configuration, never in source or logs.
Avoid synchronous and unbounded work in controllers, guards, pipes, and providers.
Use streams for large transfers and preserve backpressure.
Choose the Fastify adapter only after checking every Express-specific middleware and recipe for an equivalent. [Nst10]
Benchmark the complete application with its real adapter, serialization, middleware, and dependencies.
