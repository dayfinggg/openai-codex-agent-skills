# Spring Boot web backends
This reference covers Spring Boot and Spring Framework choices at the HTTP, application, persistence, and operations boundaries.
Use `java.md` and `kotlin.md` for language, collection, exception, concurrency, and testing fundamentals.
Framework APIs and defaults change, so verify the target Spring Boot and Spring Framework versions in the linked documentation.
## Design and boundaries
- Organize code around a domain or feature, not around a mandatory number of technical layers.
- Put `@SpringBootApplication` in a root package so component and entity scanning stays local.
- Let a controller adapt HTTP input and output, an application service coordinate a use case, and a repository own persistence.
- Keep DTOs and validation annotations at the transport boundary when their shape differs from domain values.
- Keep domain invariants in domain types or application services so non-HTTP callers receive the same guarantees.
- Define a repository interface when persistence is a replaceable port, a consistency boundary, or a useful test seam.
- Do not create an interface, service, and repository for every noun when each type only forwards one call.
- Prefer feature-first packages when a change crosses controller, service, repository, and tests for one capability.
- Use Spring Modulith when package boundaries need architectural verification or module-scoped integration tests.
- The official Spring Petclinic demonstrates a small application entry point and domain-oriented owner code.
## Dependency injection
- Prefer constructor injection for required dependencies and immutable components.
- Use setter or configuration-method injection only for genuinely optional dependencies.
- Let one constructor express required collaborators and use qualifiers when multiple candidates exist.
- Keep bean wiring in configuration or a composition root rather than constructing infrastructure in domain code.
- Treat circular dependencies as a design signal and refactor ownership before enabling workarounds.
- Use `@ConfigurationProperties` for cohesive settings instead of scattering `@Value` lookups through beans.
- Keep configuration properties focused on environment data and avoid making them service locators.
## HTTP boundary
- Keep `@RestController` methods short enough that mapping and use-case intent are obvious.
- Parse and normalize request data before invoking the application service.
- Return explicit status codes and response DTOs rather than exposing persistence entities as an accidental API.
- Keep transaction policy, SQL, remote calls, and authorization policy out of controller methods.
- Put cross-cutting HTTP behavior in filters, interceptors, argument resolvers, or focused configuration.
## Validation and errors
- Use Bean Validation with `@Valid` or `@Validated` on request models and method constraints where appropriate.
- Handle both `MethodArgumentNotValidException` and `HandlerMethodValidationException` in current Spring MVC.
- Validate business invariants again in the domain or application service because callers are not all HTTP clients.
- Centralize cross-cutting mappings in `@ControllerAdvice` or a focused `ResponseEntityExceptionHandler`.
- Prefer RFC 9457 `ProblemDetail` for REST errors when clients can consume `application/problem+json`.
- Map domain failures deliberately to 400, 401, 403, 404, 409, 422, or 5xx semantics.
- Do not expose stack traces, SQL, secrets, internal class names, or tokens in a client error.
## Transactions and persistence
- Place `@Transactional` around an application use case that changes one consistency boundary.
- Keep remote calls, message publication, and long waits outside the database transaction when possible.
- Remember that proxy-based transactions apply to external calls through the proxy, not same-class self-invocation.
- Runtime exceptions and errors roll back by default, while checked exceptions need an explicit rollback rule.
- Prefer concrete-class transaction annotations and test rollback behavior instead of assuming the annotation is active.
- Select the transaction manager that matches imperative, reactive, or multiple-database work.
- Use reactive transaction operators for coroutine or reactive data paths rather than mixing thread-bound and reactive contexts.
- Do not mistake `readOnly` for an authorization or consistency guarantee.
- Let repositories own query shape and persistence mapping while the service owns the unit of work.
## Configuration and operations
- Keep deploy-time values outside the artifact and provide safe defaults only for local development.
- Use external properties, YAML, environment variables, and command-line overrides intentionally.
- Bind related settings into typed `@ConfigurationProperties` objects and validate them during startup.
- Know property-source precedence before diagnosing an unexpected value.
- Store secrets in a secret manager or environment injection, never in committed configuration or logs.
- Expose only the management endpoints that operators need and secure sensitive endpoints separately.
- Keep Actuator management traffic on a controlled interface, port, or security chain when the deployment requires it.
## Concurrency and coroutine integration
- Choose Servlet-based blocking MVC, virtual-thread execution, or WebFlux and coroutines from the actual I/O model.
- Spring MVC asynchronous return values release the request thread, but response writes can remain blocking.
- Use WebFlux with non-blocking clients and drivers when the complete request path benefits from non-blocking I/O.
- Spring supports suspending controller methods and `Flow`; use the model consistently within a boundary.
- Do not assume a thread-bound imperative transaction follows work started on a new thread.
- Give `@Async` work an explicit bounded executor and configure context propagation when request context matters.
- Put unavoidable blocking calls on a deliberately chosen executor or dispatcher at the adapter boundary.
## Observability
- Treat logs, metrics, and traces as one request narrative with stable operation names and correlation context.
- Use Actuator with Micrometer Observation for standard metrics and traces.
- Use `ObservationRegistry` for custom observations instead of coupling business code to a vendor API.
- Use low-cardinality metric tags and keep user identifiers in traces or structured logs only when safe.
- Enable context propagation for asynchronous executors and reactive pipelines when trace context crosses threads.
- Redact credentials, tokens, personal data, and full request bodies by default.
- Keep health and readiness checks aligned with whether the service can receive work.
## Security
- Use Spring Security request rules for coarse access and method security for fine-grained checks.
- Add a catch-all request rule because unannotated methods are not secured by method annotations alone.
- Enforce ownership or tenant checks in the application layer, not only in URL matching.
- Configure an OAuth2 resource server with an issuer or explicit decoder and verify scopes or authorities.
- Keep CSRF protection for browser-session applications and disable it only for genuinely non-browser clients.
- Use `DelegatingPasswordEncoder` or a supported adaptive encoder, never `NoOpPasswordEncoder`.
- Restrict Actuator exposure and protect management endpoints with their own authorization rules.
## Testing
- Unit-test domain rules and application services without a Spring context when possible.
- Use `@SpringBootTest` when full context behavior matters and slice tests when only one adapter matters.
- Use MockMvc or an HTTP client to assert status, headers, content type, and `ProblemDetail` shape.
- Test validation, exception mapping, authorization, transaction rollback, timeout, and cancellation behavior.
- Use Testcontainers for real database or service behavior and let Spring manage container lifecycle when contexts are cached.
- Test security rules with authenticated and unauthenticated principals, including method-security denials.
## Sources
### Official Spring Boot and Framework documentation
- [Spring Boot structuring](https://docs.spring.io/spring-boot/reference/using/structuring-your-code.html), [Spring Boot dependency injection](https://docs.spring.io/spring-boot/reference/using/spring-beans-and-dependency-injection.html), and [Spring Framework dependency injection](https://docs.spring.io/spring-framework/reference/core/beans/dependencies/factory-collaborators.html).
- [Spring MVC validation](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-controller/ann-validation.html), [Spring MVC error responses](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-ann-rest-exceptions.html), and [Spring MVC asynchronous requests](https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-ann-async.html).
- [Spring transactions with `@Transactional`](https://docs.spring.io/spring-framework/reference/data-access/transaction/declarative/annotations.html), [transaction implementation](https://docs.spring.io/spring-framework/reference/data-access/transaction/declarative/tx-decl-explained.html), and [externalized configuration](https://docs.spring.io/spring-boot/reference/features/external-config.html).
- [Spring Boot testing](https://docs.spring.io/spring-boot/reference/testing/spring-boot-applications.html), [Spring Boot Testcontainers](https://docs.spring.io/spring-boot/reference/testing/testcontainers.html), and [Spring Boot observability](https://docs.spring.io/spring-boot/reference/actuator/observability.html).
- [Spring Boot Actuator endpoints](https://docs.spring.io/spring-boot/reference/actuator/endpoints.html) and [Spring Framework Kotlin coroutines](https://docs.spring.io/spring-framework/reference/languages/kotlin/coroutines.html).
### Spring Security documentation
- [Authorization](https://docs.spring.io/spring-security/reference/servlet/authorization/), [method security](https://docs.spring.io/spring-security/reference/servlet/authorization/method-security.html), and [OAuth2 support](https://docs.spring.io/spring-security/reference/servlet/oauth2/).
- [OAuth2 resource-server JWT](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/jwt.html), [password storage](https://docs.spring.io/spring-security/reference/features/authentication/password-storage.html), and [CSRF](https://docs.spring.io/spring-security/reference/features/exploits/csrf.html).
### Maintainer guidance and verified examples
- [Spring Modulith reference](https://docs.spring.io/spring-modulith/reference/index.html) and [Oliver Drotbohm's Spring Modulith introduction](https://spring.io/blog/2022/10/21/introducing-spring-modulith/).
- [Spring Petclinic repository](https://github.com/spring-projects/spring-petclinic) and [Petclinic application entry point](https://github.com/spring-projects/spring-petclinic/blob/main/src/main/java/org/springframework/samples/petclinic/PetClinicApplication.java).
