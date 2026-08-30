# Ktor web backends
This reference covers Ktor server choices at the routing, application, persistence, and operations boundaries.
Use `kotlin.md` and `java.md` for language, coroutine, collection, exception, and JVM fundamentals.
Ktor is intentionally unopinionated, so select the smallest structure that makes ownership, lifecycle, and tests clear.
## Design and application structure
- Organize code around a domain or feature rather than a mandatory technical-layer tree.
- Define `Application` extension functions as modules that install plugins, register routes, and connect services.
- Pass a service or port into a route module when explicit wiring is clearer than a container.
- Use feature packages when one change crosses routes, application logic, persistence, and tests.
- Keep route handlers as HTTP adapters that parse input, invoke a use case, and map the result to HTTP.
- Keep business invariants and authorization policy in application or domain code, not in duplicated route conditionals.
- Let repositories own queries and persistence mapping when they represent a meaningful storage port.
- Do not create an interface, service, and repository for every noun when each type only forwards one call.
- Use Ktor's domain-driven or modular structures for larger systems, but keep small services small.
- Ktor's route extension functions and maintained samples show several valid ways to group endpoints.
## Dependency injection
- Register small-application dependencies through module parameters when that keeps construction visible.
- Use the built-in DI plugin for named implementations, shared lifecycle, async providers, or larger composition roots.
- Register providers once during application setup and resolve them at module setup rather than in every request.
- Use type-based resolution by default and named dependencies only when multiple implementations are intentional.
- Keep resource creation and shutdown in the DI or application lifecycle that owns the resource.
- Override DI providers in `testApplication` before loading modules when a fake is sufficient.
- Keep startup order explicit when one module resolves a dependency provided by another module.
## Routing and transport
- Group routes by feature or resource and use `Route` extension functions to keep the top-level routing block readable.
- Use nested `route` blocks when path ownership and resource relationships are clear.
- Parse path and query parameters explicitly and return a deliberate 400 response for invalid input.
- Use `ContentNegotiation` and typed serialization for request and response DTOs.
- Keep database entities and internal domain values out of public JSON unless their contracts are intentionally identical.
- Keep route handlers free of SQL, transaction policy, secret handling, and broad exception translation.
## Validation and errors
- Install `RequestValidation` for typed request-body checks and define rules close to the request contract.
- Handle `RequestValidationException` through `StatusPages` so invalid bodies have one response shape.
- Install `StatusPages` once at the application boundary for exception and status-code mapping.
- Use typed domain failures and one error renderer so every route has consistent semantics.
- Map domain failures deliberately to 400, 401, 403, 404, 409, 422, or 5xx semantics.
- Keep route handlers free of broad `catch (Throwable)` blocks that hide cancellation or programming defects.
- Do not expose stack traces, SQL, secrets, internal class names, or tokens in a client error.
## Transactions and persistence
- Ktor leaves transaction policy to the selected database library, so make the boundary explicit in infrastructure.
- Keep the service responsible for the unit of work and the repository responsible for database-specific operations.
- The Ktor Exposed guide demonstrates an interface-backed repository, an in-memory fake, and a PostgreSQL repository.
- Treat JDBC access as blocking even when called from a `suspend` function and move it to an appropriate IO dispatcher.
- Use R2DBC or another non-blocking driver only when the complete data path supports that model.
- Do not share a transaction across unrelated coroutines or threads unless the driver explicitly supports it.
- Test database locking, isolation, constraints, migrations, and rollback behavior against a real database.
## Configuration and lifecycle
- Use `application.conf` or `application.yaml` for modules, deployment settings, and custom configuration groups.
- Substitute environment variables for secrets and deployment-specific values.
- Use `property()` for required values and `propertyOrNull()` only when absence is valid.
- Use typed configuration mapping such as `getAs<T>()` for cohesive application settings.
- Keep module names and startup order in configuration when using `EngineMain`.
- Fail fast on missing endpoints, invalid durations, unsafe limits, and incompatible feature flags.
- Subscribe to application lifecycle events to release resources and record startup or shutdown state.
## Concurrency and request cancellation
- Ktor route handlers are suspendable, but `suspend` does not make blocking code non-blocking.
- Keep blocking database, filesystem, and legacy-client calls off the engine's event-loop threads.
- Use a deliberately chosen IO dispatcher or a non-blocking driver at the adapter boundary.
- Bound fan-out, queues, connection pools, and external calls with timeouts and capacity limits.
- Use Ktor's module startup settings deliberately when concurrent module loading is safe for the dependency graph.
- Install `HttpRequestLifecycle` when a disconnected client should cancel long-running request work.
- Let request cancellation reach child work and rethrow `CancellationException` after cleanup.
- Consult `kotlin.md` for general structured-concurrency, dispatcher, shared-state, and coroutine-testing rules.
## Observability
- Treat logs, metrics, and traces as one request narrative with stable operation names and correlation context.
- Use SLF4J with `CallLogging` or structured logging and configure the backend for production output.
- Use `MicrometerMetrics` for HTTP and JVM metrics and choose a registry such as Prometheus deliberately.
- Use low-cardinality metric tags and keep user identifiers in traces or structured logs only when safe.
- Use `KtorServerTelemetry` for incoming spans and configure a stable OpenTelemetry service name.
- Install telemetry before other logging or telemetry plugins when the Ktor integration requires that order.
- Redact credentials, tokens, personal data, and full request bodies by default.
- Add health and readiness signals that reflect whether the service can receive work.
## Security
- Install `Authentication` and select a provider per protected route or route group.
- For JWT, verify the algorithm, issuer, audience, expiry, signature, and required claims before creating a principal.
- Implement authorization as a route guard or plugin that calls application policy, not as duplicated route conditionals.
- Use TLS in deployment and rotate signing keys or shared secrets according to the identity system's policy.
- Configure CORS with explicit allowed hosts, methods, headers, and preflight behavior.
- Keep a CSRF strategy for browser-session applications and do not treat bearer tokens as a reason to ignore cookie risks.
- Never store JWT secrets, private keys, passwords, or database credentials as plaintext in committed configuration.
## Testing
- Unit-test domain rules and application services without a Ktor engine when possible.
- Use `testApplication` to run calls in memory without binding a real server socket.
- Configure the same modules and test client plugins that production routes require.
- Override DI providers with fakes before loading modules, then add a smaller number of end-to-end tests.
- Test validation, error mapping, authorization, timeout, cancellation, and serialization behavior through the application pipeline.
- Use external-service mocks for deterministic contract tests and a real server test only when engine behavior matters.
- Use real containers for database behavior that in-memory fakes cannot prove.
## Sources
### Official Ktor documentation
- [Ktor application structure](https://ktor.io/docs/server-application-structure.html), [routing](https://ktor.io/docs/server-routing.html), and [routing organization](https://ktor.io/docs/server-routing-organization.html).
- [Ktor dependency injection](https://ktor.io/docs/server-dependency-injection.html), [dependency resolution](https://ktor.io/docs/server-di-dependency-resolution.html), and [DI testing](https://ktor.io/docs/server-di-testing.html).
- [Ktor request validation](https://ktor.io/docs/server-request-validation.html), [StatusPages](https://ktor.io/docs/server-status-pages.html), and [configuration in a file](https://ktor.io/docs/server-configuration-file.html).
- [Ktor database integration with Exposed](https://ktor.io/docs/server-integrate-database.html), [HTTP request lifecycle](https://ktor.io/docs/server-http-request-lifecycle.html), and [Ktor testing](https://ktor.io/docs/server-testing.html).
- [Ktor logging](https://ktor.io/docs/server-logging.html), [Micrometer metrics](https://ktor.io/docs/server-metrics-micrometer.html), [OpenTelemetry](https://ktor.io/docs/server-opentelemetry.html), and [application events](https://ktor.io/docs/server-events.html).
- [Ktor authentication](https://ktor.io/docs/server-auth.html), [JWT](https://ktor.io/docs/server-jwt.html), and [CORS](https://ktor.io/docs/server-cors.html).
### Maintained examples and companion libraries
- [Ktor samples](https://github.com/ktorio/ktor-samples), [structured-logging sample](https://github.com/ktorio/ktor-samples/tree/main/structured-logging), and [engine-main-modules sample](https://github.com/ktorio/ktor-documentation/tree/main/codeSnippets/snippets/engine-main-modules).
- [JetBrains Exposed](https://github.com/JetBrains/Exposed) provides the database adapter used in the Ktor integration guide.
### JetBrains guidance
- [JetBrains KotlinConf 2025 backend roundup](https://blog.jetbrains.com/kotlin/2025/08/kotlin-on-the-backend-what-s-new-from-kotlinconf-2025/) identifies structured concurrency in Ktor as a server-side topic.

### Practitioner talk

- [Talking Kotlin: Ktor with Ryan Harter](https://talkingkotlin.com/ktor-with-ryan-harter/) discusses route extension functions and plugin composition; use current Ktor docs for API contracts.
