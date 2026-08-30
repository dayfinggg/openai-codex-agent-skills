# NestJS backend standards

Build on [framework-neutral Node.js backend standards](node-backend.md).
Use NestJS when a team benefits from an explicit module graph, dependency injection, and shared request conventions.
Keep framework decorators at the transport boundary and keep domain services independently testable.

## Bootstrap and module graph

Create the application from one root module and keep bootstrap responsible for process wiring.
Use feature modules to group related controllers, providers, ports, adapters, and policies.
Nest builds its dependency graph from modules and uses the root module as the application entry point. [Nst1]
Treat a module's exported providers as its public API.
Import the module that owns a capability instead of reaching into its private providers. [Nst1]
Avoid making every module global; global modules reduce visible coupling only when used sparingly. [Nst1]
Keep configuration, database clients, queues, and external SDKs in providers with explicit lifecycle ownership.
Prefer constructor injection so required dependencies are visible and replaceable in tests. [Nst2]
Do not create providers manually inside controllers when Nest can resolve them.
Use request scope only when request identity or isolation requires it.
Remember that request-scoped classes do not receive application lifecycle hooks. [Nst3]

## Request boundary

Controllers receive requests and send responses; providers perform application work. [Nst4]
Keep controllers thin and pass DTOs or explicit commands to providers.
Use middleware for transport-wide concerns that do not depend on the selected handler.
Use guards for authentication and authorization that need route metadata or execution context. [Nst5]
Use pipes for parsing and validation before the provider runs.
Use filters for consistent exception mapping and safe response bodies.
Make global, controller-scoped, and method-scoped policy visible and intentional.
Do not let domain providers depend on `Request`, `Response`, `ExecutionContext`, or adapter-specific objects.
Avoid `@Res()` and other platform-specific response APIs unless the endpoint truly needs them.
Return one response and return immediately after an explicit response write.
Generate or validate a request identifier and carry it through providers and outbound calls.

## Validation and serialization

Use DTOs or the project's chosen schema pipe for body, path, query, and header validation.
Nest's `ValidationPipe` can validate request properties and transform plain payloads into DTO instances. [Nst6]
Set `whitelist: true` to strip properties without validation decorators.
Set `forbidNonWhitelisted: true` when unknown properties must reject the request instead of being stripped. [Nst6]
Use explicit parse pipes when implicit conversion would hide a contract mistake.
Disable detailed validation messages in production when they could reveal internal rules. [Nst6]
Validate output DTOs or serialization rules for public responses.
Return allowlisted views rather than persistence entities with sensitive fields.
Keep validation deterministic and do not perform database lookups in the initial shape check.
Use consistent status, code, detail, and request identifier fields in error responses.

## Errors and exception filters

Throw `HttpException` subclasses for expected HTTP failures.
Nest's built-in exception layer handles `HttpException` and returns a generic response for unknown exceptions. [Nst7]
Create a custom exception hierarchy when domain errors need stable mapping.
Use a global exception filter for the public error contract and cross-cutting logging.
Use controller or method filters only for intentionally local response policies.
Remember that middleware exceptions are handled only by global filters because middleware runs before route selection. [Nst7]
Do not expose stack traces, SQL, tokens, file paths, or upstream credentials.
Log unknown exceptions with the original error, request identifier, route, and safe context.
Do not catch an error merely to log it and continue with inconsistent state.
If a response has started, finish or abort the stream and never write a second response.

## Async lifecycle

Return or await provider, factory, module, and lifecycle promises.
Create external clients during module initialization and close them during application shutdown.
Use `OnModuleInit` or `OnApplicationBootstrap` for asynchronous readiness checks. [Nst3]
Do not report readiness until required dependencies are usable.
Enable `enableShutdownHooks()` when process signals must trigger Nest shutdown handlers. [Nst3]
Make shutdown idempotent and bound the drain window.
Let the HTTP adapter stop new requests before providers release shared clients.
When a transport exposes a client-abort signal, cancel only safely cancellable work.
Give committed side effects a durable transaction, queue, or job owner instead of cancelling them on disconnect.
If an abort listener can outlive successful completion, remove it in `finally`; `{ once: true }` removes it only when abort fires. [Nst13]
Do not schedule asynchronous work from a `process.on('exit')` handler. [N4]

## Logging and observability

Use Nest's `Logger` or a custom `LoggerService` through dependency injection.
Enable JSON logging for production aggregation and keep development formatting environment-specific. [Nst12]
Use a logger context named for the provider or feature.
Include request ID, route template, method, status, duration, error code, and dependency identifiers.
Redact authorization headers, cookies, passwords, tokens, and personal data.
Do not log full request bodies by default.
Emit one completion record per request and additional records for meaningful state changes or failures.
Record request rate, status classes, latency percentiles, event-loop delay, dependency latency, and pool saturation.
Propagate trace context through outbound clients and background jobs.

## Security and performance

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

## Testing

Test providers with explicit fake dependencies before bootstrapping the full Nest application.
Use `Test.createTestingModule()` to compile the dependency graph in unit and integration tests. [Nst8]
Override database, queue, HTTP, guards, filters, and other providers rather than branching production code for tests. [Nst8]
Create and initialize a Nest application for end-to-end HTTP tests.
Use the adapter's in-process injection when the application uses Fastify, or a controlled HTTP test client otherwise. [Nst8]
Close the application in teardown so lifecycle hooks and clients run.
Test DTO validation, unknown properties, parsing, guards, filters, response redaction, and adapter-specific behavior.
Test cancellation, dependency failure, timeout, shutdown, and duplicate-response paths.
Keep real integration tests for databases, queues, TLS, proxies, and serialization.

## Choose NestJS deliberately

Choose NestJS when module ownership, DI conventions, guards, pipes, and filters reduce team coordination cost.
Use plain Node, Express, or Fastify when a smaller explicit pipeline is easier to explain and operate.
Do not add dynamic modules, global providers, request scope, or custom decorators without a current use.
Keep domain logic free of Nest metadata so a provider can be tested or reused directly.
Use the official cats sample as a concrete reference for a controller, DTO, guard, parse pipe, and service delegation. [Nst11]

## Sources

### Official NestJS and Node.js documentation

- [Nst1: NestJS modules](https://docs.nestjs.com/modules)
- [Nst2: NestJS providers](https://docs.nestjs.com/providers)
- [Nst3: NestJS lifecycle events](https://docs.nestjs.com/fundamentals/lifecycle-events)
- [Nst4: NestJS controllers](https://docs.nestjs.com/controllers)
- [Nst5: NestJS guards](https://docs.nestjs.com/guards)
- [Nst6: NestJS validation](https://docs.nestjs.com/techniques/validation)
- [Nst7: NestJS exception filters](https://docs.nestjs.com/exception-filters)
- [Nst8: NestJS testing](https://docs.nestjs.com/fundamentals/testing)
- [Nst9: NestJS Helmet](https://docs.nestjs.com/security/helmet)
- [Nst10: NestJS Fastify performance adapter](https://docs.nestjs.com/techniques/performance)
- [Nst12: NestJS logger](https://docs.nestjs.com/techniques/logger)
- [Nst13: Node.js Global AbortController and AbortSignal](https://nodejs.org/api/globals.html)
- [N4: Node.js Process API](https://nodejs.org/api/process.html)

### Maintainer examples

- [Nst11: NestJS official cats sample controller](https://github.com/nestjs/nest/blob/master/sample/01-cats-app/src/cats/cats.controller.ts)
