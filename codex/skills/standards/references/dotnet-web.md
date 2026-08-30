# ASP.NET Core web standards

This reference targets current ASP.NET Core and .NET 10 applications.
Recheck API details when targeting a different supported framework version.

## Baseline

- Use `WebApplication.CreateBuilder(args)` and `WebApplication` as the composition root for new apps.
- Keep service registration, configuration binding, middleware order, and endpoint mapping visible in `Program.cs` or in clearly named extension methods.
- Treat HTTP as a boundary with explicit routes, verbs, status codes, content types, authentication, and authorization requirements.
- Define and review the public contract before optimizing implementation details.
- Generate an OpenAPI document with `Microsoft.AspNetCore.OpenApi` and keep interactive documentation restricted to development or authorized users.
- Prefer framework capabilities over a new package or custom pipeline component when they meet the requirement.

## Minimal APIs and controllers

- Start new HTTP APIs with Minimal APIs unless controller-specific features justify another choice.
- Minimal APIs reduce ceremony and support route groups, filters, authorization, typed results, OpenAPI metadata, and dependency injection.
- Use `MapGroup` to keep a feature's prefix, tags, policies, filters, and endpoint mappings together.
- Use `TypedResults` when response types should be visible to OpenAPI and directly assertable in unit tests.
- Use controllers when the app needs MVC model-binding extensibility, advanced MVC validation, application parts, conventions, or OData support.
- Choose one style per feature based on required behavior, not on a blanket preference or a benchmark detached from the workload.
- Do not rewrite stable controllers merely to adopt Minimal APIs.
- Both styles should keep HTTP translation at the edge and delegate business decisions to testable application or domain code.

## Endpoint and contract shape

- Use request and response DTOs rather than binding or returning persistence entities.
- DTOs prevent over-posting, hide server-only fields, stabilize the contract, and reduce payload size.
- Return the status code that describes the result, such as `201 Created` with a `Location` header after creation.
- Give endpoints stable names and explicit response metadata so generated OpenAPI describes real behavior.
- Bound list endpoints with filtering, ordering, and pagination instead of returning an unbounded collection.

## Dependency injection

- Register dependencies in the composition root and group related registrations behind focused `Add{Feature}` extension methods.
- Use constructor injection for classes and handler or method injection for request-scoped endpoint dependencies.
- Use transient for independent short-lived services, scoped for request or unit-of-work state, and singleton only for thread-safe process-wide state.
- Never capture a scoped service inside a singleton without creating an explicit scope for each operation.
- Keep `DbContext` scoped by default and do not register it as a singleton.
- Prefer injected dependencies over `IServiceProvider`, `RequestServices`, static state, or `IHttpContextAccessor` access.
- For conventional middleware, inject scoped services into `Invoke` or `InvokeAsync`, or use factory-based middleware.
- Use `IHttpClientFactory` for outbound HTTP clients instead of constructing and disposing a client per request.
- Enable scope validation in development and test builds so captive dependencies fail early.

## Middleware and pipeline

- Middleware runs in registration order on the request and reverse order on the response, so order is part of the behavior.
- Put production exception handling first, then configure trusted forwarded headers before any component that consumes scheme, host, or client-IP data.
- Place HTTPS handling and public static-file handling according to the deployment topology and data sensitivity.
- With endpoint routing, use `UseRouting`, then `UseCors`, `UseAuthentication`, and `UseAuthorization` in that order when those components are present.
- Place antiforgery middleware after authentication and authorization, and before form-writing endpoints that require it.
- Call endpoint-specific rate limiting after routing; global-only limiters can be placed earlier when appropriate.
- Use middleware for application-wide concerns and endpoint filters for behavior local to a route or route group.
- A middleware may short-circuit deliberately, but document the skipped downstream behavior and test the branch.
- Keep early, global middleware fast because it runs for every request.

## Binding and validation

- Validate at the HTTP boundary, then enforce business invariants again in application or domain code.
- In .NET 10 Minimal APIs, call `builder.Services.AddValidation()` to enable validation for supported parameters and request types.
- Minimal API validation uses DataAnnotations and `IValidatableObject` for query, header, and body values and returns `400 Bad Request` for failures.
- If Minimal API handlers or validatable types live in another assembly, register validation from that assembly so its source-generated metadata is discovered.
- Controllers marked with `[ApiController]` automatically return a validation `400` without a manual `ModelState.IsValid` branch.
- Customize validation failures through `ProblemDetails` rather than leaking internal exception or binding details.
- Disable validation only for a documented endpoint that has a reviewed reason to bypass it.
- Do not confuse syntactic input validation with authorization, ownership checks, or domain invariants.

## EF Core boundary

- Treat one short-lived `DbContext` as one unit of work, normally scoped to an HTTP request.
- Dispose contexts through DI and never share one context concurrently across threads or parallel operations.
- Await each EF Core operation before starting another operation on the same context.
- Keep persistence-specific context, mappings, migrations, and provider code behind a real infrastructure boundary when the application has one.
- Do not add a generic repository or unit-of-work wrapper solely for ceremony; `DbContext` already supplies those patterns for simple CRUD.
- Add a focused repository or port when it expresses a domain boundary, isolates a provider, or provides a useful testing seam.
- Project only the columns needed by the response and use no-tracking queries for read-only paths when identity resolution is not required.
- Limit result sets and use pagination; test against data volumes that resemble production.
- Inspect generated SQL, query plans, round trips, and related-entity loading before adding a performance abstraction.
- Use raw SQL only when EF Core cannot produce the required query and measured performance or database-specific behavior justifies the maintenance cost.
- Keep DTO mapping explicit at the persistence or application boundary so database shape does not become the HTTP contract.

## Async, cancellation, and work duration

- Make the entire request call chain asynchronous when it performs I/O.
- Never block on asynchronous work with `.Result`, `.Wait()`, or `GetAwaiter().GetResult()`.
- Do not use `Task.Run` to disguise synchronous I/O or to wrap ordinary request work.
- Never use `async void` for application operations or fire-and-forget work.
- Pass `HttpContext.RequestAborted` to database, HTTP, and other cancellable operations; Minimal APIs can bind it directly as a `CancellationToken`.
- Set explicit request or dependency timeouts for operations whose duration must be bounded.
- Move long-running or durable work to a hosted background service, a durable queue, or an external worker and return a trackable result.
- Stream only when the contract needs streaming, and propagate cancellation through the producer and serializer.

## Errors and responses

- Enable the Developer Exception Page only in `Development`.
- In non-development environments use `UseExceptionHandler` and a consistent RFC 7807 `ProblemDetails` response.
- Register `AddProblemDetails` when Minimal APIs and controllers need a common error format.
- Map expected domain outcomes to deliberate `4xx` results and reserve `5xx` responses for unexpected server failures.
- Do not use exceptions for normal branching or validation decisions.
- Never return stack traces, connection strings, tokens, or other sensitive details to clients.
- Log the complete server-side exception with a request or trace identifier while returning a safe client payload.

## Configuration and options

- Use `appsettings.json` for non-secret defaults and environment-specific files only for environment differences.
- Remember that later configuration providers override earlier values; the standard order places environment variables and command-line arguments above JSON files.
- Use `__` for hierarchical environment-variable keys when portability matters.
- Bind related settings to typed options classes instead of reading arbitrary string keys throughout the codebase.
- Validate required options with data annotations or `IValidateOptions<T>` and call `ValidateOnStart()` when invalid startup configuration should fail fast.
- Keep configuration access near the service that owns the setting and expose only the values that service needs.
- Never commit passwords, tokens, certificates, or production secrets to configuration files or source control.
- Use Secret Manager for development and a suitable managed secret store or environment mechanism for deployment.

## Security

- Separate authentication, which establishes identity, from authorization, which decides access.
- Configure supported authentication schemes explicitly and call `UseAuthentication` before code that depends on `HttpContext.User`.
- Prefer policy-based authorization with requirements and handlers for reusable rules, and apply policies to endpoints or controllers.
- Enforce object-level ownership and business authorization in application or domain code, not only at the route role check.
- Require TLS in production; use HTTPS redirection and HSTS for web apps when the edge does not already enforce them.
- An API receiving sensitive data should not rely on an HTTP redirect that a non-browser client may ignore.
- Behind a proxy, process forwarded headers only from configured known proxies or networks and restrict accepted hosts.
- Treat cookie-authenticated browser writes as CSRF-sensitive and use antiforgery tokens for applicable form or state-changing endpoints.
- Configure CORS with the smallest explicit origin, method, and header set; never combine wildcard origins with credentials.
- Rate-limit public or expensive endpoints, choose partitions and limits from resource cost, and load-test the policy before deployment.
- Use DTOs and allow-lists to prevent over-posting and accidental exposure of server-only fields.
- In a multi-instance deployment, persist and protect a shared Data Protection key ring so cookies and antiforgery tokens work across nodes.
- Keep OpenAPI, diagnostics, and management endpoints private or authorized unless their exposure is intentional.

## Observability and operations

- Use `ILogger<T>` with structured message templates and fields rather than interpolated log strings.
- Record useful request, dependency, outcome, and duration information without logging secrets or unnecessary personal data.
- Treat logs, metrics, and distributed traces as complementary signals rather than substitutes for one another.
- Use `ActivitySource`, `Meter`, and OpenTelemetry instrumentation for ASP.NET Core, outbound HTTP, and database dependencies where a trace backend is available.
- Propagate trace context across service calls and include the trace identifier in safe error responses when it helps support.
- Add health checks with separate liveness and readiness intent, and avoid exposing dependency details on an unauthenticated public endpoint.
- Measure hot paths and query behavior with production-like load before adopting pooling, compiled queries, caching, or other complexity.

## Testing

- Unit-test domain and application decisions with fakes at real boundaries and keep those tests fast.
- Use focused integration tests to exercise routing, middleware, binding, authentication, persistence, and serialization together.
- Use `WebApplicationFactory<TEntryPoint>` and `TestServer` or the current equivalent to bootstrap the real app in-process.
- Test Minimal API handlers as named methods when `TypedResults` makes status and payload types directly assertable.
- Keep integration tests for the most important infrastructure scenarios instead of repeating every unit-test permutation.
- Override services and configuration through a custom web-application factory rather than changing production startup code for tests.
- Assert status codes, headers, problem-details fields, authorization failures, validation failures, and cancellation behavior as part of the API contract.
- Run a small set of provider-backed EF tests when query translation, transactions, or constraints matter.
- Keep unit and integration test projects separate so infrastructure dependencies do not leak into fast tests.

## Avoid needless layering

- Start a small service as one deployable project organized by feature, and add projects only when a boundary earns its cost.
- Keep endpoint or controller code thin but meaningful; a chain of pass-through classes is not separation of concerns.
- Add an abstraction when it protects a volatile dependency, defines a domain boundary, enables a needed replacement, or improves a specific test seam.
- Do not create generic repositories, generic services, mapping layers, or mediator pipelines merely to satisfy a template.
- Let simple CRUD use direct EF Core access when that is the clearest design.
- Use a richer application core and infrastructure separation when business rules, ownership, persistence replacement, or team boundaries justify it.
- Prefer feature cohesion over folders or projects that scatter one use case across many horizontal layers.
- Keep cross-cutting policy in the framework pipeline and keep feature-specific policy beside the feature.
- Reassess architecture when measured complexity or change pressure shows that the current boundary no longer serves the product.

## Sources

### Official ASP.NET Core and .NET documentation

- [ASP.NET Core APIs overview](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/apis?view=aspnetcore-10.0)
- [Minimal APIs quick reference](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis?view=aspnetcore-10.0)
- [Minimal API tutorial](https://learn.microsoft.com/en-us/aspnet/core/tutorials/min-web-api?view=aspnetcore-10.0)
- [Dependency injection in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection?view=aspnetcore-10.0)
- [Dependency injection service lifetimes](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection/service-lifetimes)
- [ASP.NET Core middleware](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/middleware/?view=aspnetcore-10.0)
- [Validation in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/validation?view=aspnetcore-10.0)
- [Model validation in ASP.NET Core MVC](https://learn.microsoft.com/en-us/aspnet/core/mvc/models/validation?view=aspnetcore-10.0)
- [Handle errors in ASP.NET Core APIs](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/error-handling-api?view=aspnetcore-10.0)
- [DbContext lifetime and configuration](https://learn.microsoft.com/en-us/ef/core/dbcontext-configuration/)
- [Efficient querying with EF Core](https://learn.microsoft.com/en-us/ef/core/performance/efficient-querying)
- [EF Core persistence and repository boundaries](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/infrastructure-persistence-layer-implementation-entity-framework-core)
- [ASP.NET Core best practices](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/best-practices?view=aspnetcore-10.0)
- [Use HttpContext and RequestAborted](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/use-http-context?view=aspnetcore-10.0)
- [ASP.NET Core configuration](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/configuration/?view=aspnetcore-10.0)
- [Options pattern and ValidateOnStart](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/configuration/options?view=aspnetcore-10.0)
- [ASP.NET Core authentication overview](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/?view=aspnetcore-10.0)
- [Policy-based authorization](https://learn.microsoft.com/en-us/aspnet/core/security/authorization/policies?view=aspnetcore-10.0)
- [Enforce HTTPS in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/enforcing-ssl?view=aspnetcore-10.0)
- [CORS in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/cors?view=aspnetcore-10.0)
- [CSRF prevention in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/anti-request-forgery?view=aspnetcore-10.0)
- [Rate limiting middleware](https://learn.microsoft.com/en-us/aspnet/core/performance/rate-limit?view=aspnetcore-10.0)
- [Request timeouts middleware](https://learn.microsoft.com/en-us/aspnet/core/performance/timeouts?view=aspnetcore-10.0)
- [Proxy and load-balancer configuration](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/proxy-load-balancer?view=aspnetcore-10.0)
- [Data Protection configuration](https://learn.microsoft.com/en-us/aspnet/core/security/data-protection/configuration/overview?view=aspnetcore-10.0)
- [Host ASP.NET Core in a web farm](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/web-farm?view=aspnetcore-10.0)
- [Health checks in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/health-checks?view=aspnetcore-10.0)
- [Logging in .NET and ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/logging/?view=aspnetcore-10.0)
- [.NET observability with OpenTelemetry](https://learn.microsoft.com/en-us/dotnet/core/diagnostics/observability-with-otel)
- [Test Minimal API apps](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis/test-min-api?view=aspnetcore-10.0)
- [Integration tests in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests?view=aspnetcore-10.0)
- [Generate OpenAPI documents](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/openapi/aspnetcore-openapi?view=aspnetcore-10.0)
- [Common web application architectures](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures)

### Maintainer examples

- [David Fowler's async guidance](https://github.com/davidfowl/AspNetCoreDiagnosticScenarios/blob/master/AsyncGuidance.md)
- [David Fowler's ASP.NET Core TodoApp](https://github.com/davidfowl/TodoApp)
- [Microsoft ASP.NET Core Minimal API test sample](https://github.com/dotnet/AspNetCore.Docs.Samples/blob/main/fundamentals/minimal-apis/samples/MinApiTestsSample/IntegrationTests/TodoEndpointsV2Tests.cs)

### Community talk

- [ASP.NET Community Standup: Minimal APIs](https://www.youtube.com/watch?v=enAskgcF0c0)
