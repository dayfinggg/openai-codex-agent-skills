# Symfony web standards
These rules supplement `php.md` and target Symfony 8.1+ applications.
Use `php.md` for native PHP, PSR, Composer, generic dependency injection, exceptions, testing, and static analysis.

## Application shape
- Keep the default Symfony directory structure unless a documented project convention gives a stronger boundary.
- Use PHP namespaces under `App\` to organize application logic instead of creating an internal bundle.
- Keep controllers, console commands, event listeners, message handlers, and forms at the framework edge.
- Put business decisions in named application services, domain objects, or value objects that do not require the kernel.
- Let the service container compose adapters, but keep the application dependency graph visible through type hints.
- Treat Doctrine, Messenger, the event dispatcher, forms, mail, and HTTP clients as explicit infrastructure boundaries.

## Controllers and routing
- A controller reads `Request`, checks access, invokes one use case, and returns a `Response`.
- Keep controllers to glue code. Move orchestration, persistence policy, and business rules into services or domain objects.
- Extend `AbstractController` for useful edge helpers when that coupling stays at the controller boundary.
- Use route attributes with explicit names and HTTP methods when they keep endpoint metadata local.
- Use action or constructor injection instead of fetching arbitrary services from the container.
- Use an entity value resolver for a simple identifier lookup and a repository method for complex mapping or filtering.
- Use an invokable controller when one endpoint has a distinct action name and lifecycle.
- Keep response serialization and status semantics explicit for JSON APIs.
- Register a controller as a service with `#[Route]`, `#[AsController]`, or the controller service tag when it does not use the default setup.

## Services and domain logic
- Name an application service after a business action, such as `PublishPost` or `ChargeInvoice`.
- Let the action coordinate repositories, transactions, and integration ports while domain objects enforce invariants.
- Keep services private by default and rely on autowiring and autoconfiguration for ordinary application classes.
- Use a repository only for a meaningful query or a persistence boundary that hides volatility.
- Do not create a bundle to organize one application's internal business logic.
- Keep required business work in the visible use case instead of an unordered event listener.
- Use forms, voters, listeners, and message handlers as adapters that call the application service.
- Configure manual services only when autowiring cannot express the intended implementation or scalar value.

## Validation and forms
- Put reusable Validator constraints on the underlying object, command DTO, or value object rather than only on a form field.
- Separate input-shape constraints from domain invariants that require a use-case decision or repository query.
- Use a dedicated form type when a form is complex or reused, and keep a simple form readable in one action.
- Process a form only after `isSubmitted()` and `isValid()` succeed.
- Keep form types focused on mapping and presentation concerns, not multi-step business orchestration.
- Use validation groups for genuinely different workflows and document which group the use case expects.
- Validate messages, console input, and imported data as well as browser forms.
- Return a stable API error shape instead of exposing raw constraint internals to clients.

## Doctrine and persistence
- Map entities with PHP attributes unless a project has a stronger, consistent metadata convention.
- Keep complex query construction in a repository and use Doctrine's query builder for dynamic conditions.
- Return a focused projection or DTO when the use case does not need a full entity graph.
- Treat `persist()` as registering work and `flush()` as synchronizing the unit of work with the database.
- Flush once at the application transaction boundary unless an intermediate flush is required and documented.
- Let implicit `flush()` transaction handling cover an ORM-only unit when it is sufficient.
- Use `Connection::transactional()` or `EntityManager::wrapInTransaction()` when DBAL operations share the unit.
- Roll back and discard a failed entity manager before starting another unit of work.
- Keep uniqueness, foreign keys, and other concurrency-sensitive invariants enforced by the database.
- Do not use entity lazy loading as an accidental list-query strategy. Load the relationships the response needs deliberately.
- Pass stable identifiers to Messenger and reload current entities in handlers instead of serializing a live graph.
- Dispatch messages that depend on committed rows only after the transaction commits, using an explicit project mechanism.
- Never span a database transaction across requests or user think time.

## Messenger and background work
- Model a message as data and a handler as the application operation that consumes it.
- Inject `MessageBusInterface` and route only messages that truly need asynchronous transport.
- Queue slow I/O, imports, notifications, indexing, and work that does not belong on the request path.
- Keep messages serializable and independent of `Request`, session state, and open connections.
- Make handlers idempotent because transports may redeliver a message after a worker or acknowledgement failure.
- Give each transport an intentional retry strategy, backoff, timeout, and failure transport.
- Use a stable business idempotency key for non-repeatable effects such as payments.
- Inspect, retry, skip, or remove failed messages deliberately rather than silently discarding them.
- Give rate-limited or slow transports dedicated workers so they do not block unrelated messages.
- Run workers under Supervisor, systemd, or an equivalent process manager.
- Bound worker memory or time and restart workers after deploying new code.

## Events and listeners
- Dispatch a typed event for a meaningful fact or extension point that other code may observe.
- Keep event payloads small and stable, with identifiers or immutable snapshots instead of mutable entity graphs.
- Use listeners or subscribers for optional reactions such as notifications, indexing, analytics, or integrations.
- Use `#[AsEventListener]` or autoconfigured subscribers instead of repetitive manual registration.
- Use a subscriber when one class intentionally owns several related subscriptions.
- Use listener priorities sparingly and document the ordering when behavior depends on it.
- Keep `kernel.*` listeners focused on HTTP cross-cutting work such as request metadata or exception responses.
- Do not hide a required, ordered business step inside an event listener.
- Inspect registrations with `debug:event-dispatcher` when event behavior is unclear.

## Errors and HTTP responses
- Let the controller or a view layer return a `Response`; do not let domain code construct HTTP responses.
- Map known domain or infrastructure failures to deliberate status, headers, and safe error bodies at the HTTP boundary.
- Use `HttpExceptionInterface` for failures that intentionally carry an HTTP status and headers.
- Understand that `kernel.exception` is the HttpKernel boundary for turning an exception into a response.
- Catch only failures the current layer can recover from, and preserve the causal exception when adding context.
- Keep debug error pages and stack traces disabled for production users.
- Log unexpected failures with request, user, tenant, message, or entity context that is safe to retain.
- Configure Messenger failure handling separately from HTTP error rendering.

## Security
- Use one firewall unless the application has legitimately separate authentication systems.
- Use `access_control` for coarse path or role rules and voters or `IsGranted` for object-level decisions.
- Enforce authorization in the use case or voter, not only in templates or navigation.
- Use the Security component's CSRF support for login and state-changing forms.
- Use the `auto` password hasher and let Symfony migrate hashes as algorithms change.
- Enable login throttling with the Rate Limiter component to reduce brute-force attempts.
- Keep secure session cookies and authentication configuration enabled for the deployment model.
- Never log plaintext credentials, tokens, secret values, or full sensitive request payloads.
- Validate uploaded files by size, type, storage destination, and content handling.

## Configuration and secrets
- Use environment variables for machine-specific infrastructure values and parameters for application behavior.
- Store sensitive values in Symfony's Secrets system or the deployment secret store.
- Keep committed `.env` values safe for local development and keep `.env.local` files out of version control.
- Avoid reading `$_ENV`, `$_SERVER`, or environment variables throughout application services.
- Use one configuration style consistently, and prefer attributes when route or listener metadata belongs beside the code.
- Inspect environment resolution with `debug:dotenv` and verify production secrets are not exposed by profiler or diagnostics.

## Testing
- Use `WebTestCase` for HTTP behavior, routing, security, forms, serialization, and response contracts.
- Use `KernelTestCase` for application services or repositories that need the test container.
- Test domain rules and use cases at their narrowest useful boundary, then cover real Doctrine and Messenger wiring with integration tests.
- Use a disposable test database for repository behavior that depends on mapping, joins, constraints, or transaction semantics.
- Add a small smoke suite for important public URLs, then add focused functional tests for each critical flow.
- Test access denial, invalid forms, not-found behavior, exception rendering, message retries, duplicate delivery, and rollback.
- Assert observable responses and state changes instead of container internals or private methods.
- Keep external HTTP calls, mail, and message transports fakeable through injected services.
- Run formatter, static analysis, unit tests, integration tests, and smoke tests in CI.

## Avoiding Symfony ceremony
- Start with a route, focused controller, validator or form, entity or repository, service only when needed, and a test.
- Prefer a named action over a generic service and a repository query with a real name over a one-method interface.
- Prefer a direct call over an event for required work and a real Messenger transport over a synchronous wrapper that hides latency.
- Do not create a bundle, compiler pass, extension, subscriber, or decorator before a concrete requirement exists.
- Keep simple CRUD close to Symfony conventions and isolate only business rules or integrations that need a seam.
- Remove generated empty services, unused tags, dead routes, and obsolete parameters during maintenance.
- Keep the container graph and event flow clear enough to trace one request to its use case and persistence effects.

## Sources
### Official/maintainer
- [Symfony Framework Best Practices](https://symfony.com/doc/current/best_practices.html)
- [Controllers](https://symfony.com/doc/current/controller.html) and [controller services](https://symfony.com/doc/current/controller/service.html)
- [Service Container](https://symfony.com/doc/current/service_container.html)
- [Validation](https://symfony.com/doc/current/validation.html) and [Forms](https://symfony.com/doc/current/forms.html)
- [Doctrine ORM](https://symfony.com/doc/current/doctrine.html)
- [Doctrine Transactions and Concurrency](https://www.doctrine-project.org/projects/doctrine-orm/en/current/reference/transactions-and-concurrency.html)
- [Messenger](https://symfony.com/doc/current/messenger.html)
- [Events and Event Listeners](https://symfony.com/doc/current/event_dispatcher.html)
- [HttpKernel request and exception flow](https://symfony.com/doc/current/components/http_kernel.html)
- [Security](https://symfony.com/doc/current/security.html), [Security Voters](https://symfony.com/doc/current/security/voters.html), and [CSRF](https://symfony.com/doc/current/security/csrf.html)
- [Configuration](https://symfony.com/doc/current/configuration.html) and [Secrets](https://symfony.com/doc/current/configuration/secrets.html)
- [Testing](https://symfony.com/doc/current/testing.html) and [repository testing](https://symfony.com/doc/current/testing/database.html)
- [Symfony framework source](https://github.com/symfony/symfony)
- [Symfony Demo application](https://github.com/symfony/demo) and [admin controller example](https://github.com/symfony/demo/blob/main/src/Controller/Admin/BlogController.php)
- [Symfony Messenger source example](https://github.com/symfony/symfony/blob/8.1/src/Symfony/Component/Messenger/MessageBus.php)
### Practitioner/community
- [SymfonyCasts: Controllers, Boring, Beautiful Services](https://symfonycasts.com/screencast/symfony5-fundamentals/controllers-services)
- [SymfonyCon: 42 best practices for Symfony, a decade later](https://symfony.com/blog/symfonycon-vienna-2024-42-best-practices-for-symfony-a-decade-later)
