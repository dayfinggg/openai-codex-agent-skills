# Laravel web standards
These rules supplement `php.md` and target Laravel 13.x applications.
Use `php.md` for native PHP, PSR, Composer, generic dependency injection, exceptions, testing, and static analysis.

## Application shape
- Keep routes, middleware, controllers, commands, jobs, and listeners as transport adapters.
- Put business decisions in named actions, domain objects, or application services that can be called from more than one entrypoint.
- Use Laravel's conventional directories until feature grouping makes ownership clearer.
- Use the service container only where dependency construction or substitution needs it.
- Prefer a concrete class when no substitution seam exists, and do not create empty interfaces or service wrappers.
- Treat Eloquent, queues, mail, notifications, and HTTP clients as infrastructure boundaries.

## Controllers and routing
- Let a controller authenticate, authorize, validate, call one use case, and format the response.
- Keep query composition, multi-write orchestration, and external side effects out of large controller methods.
- Use resource controllers when the endpoint is ordinary CRUD and invokable controllers when one action deserves a name.
- Let Laravel resolve controller dependencies through constructor or action type hints.
- Use route model binding for a straightforward identifier lookup and return the framework's normal not-found response.
- Move scoped, conditional, or multi-record lookups into a named query or repository method.
- Attach cross-cutting behavior through route or controller middleware instead of duplicating checks in actions.
- Return an explicit view, redirect, JSON response, or response object for each branch.

## Services and domain actions
- Name application services after business actions, such as `PublishPost` or `RefundOrder`.
- Let an action coordinate Eloquent repositories, transactions, authorization policy calls, and integration ports.
- Keep domain rules in plain PHP objects or Eloquent methods only when the rule is owned by that model.
- Do not make a generic `*Service` class a dumping ground for unrelated operations.
- Do not make every model pass through a repository when Eloquent already expresses the required query clearly.
- Reuse the same action from HTTP, Artisan, scheduled tasks, jobs, and event listeners.
- Keep framework facades and `app()` resolution at composition or edge code, not in domain logic.

## Validation and authorization
- Use inline `Validator` rules for a small, local input shape.
- Use a `FormRequest` when validation, authorization, preparation, or after-validation checks deserve a named boundary.
- Keep `rules()` about input constraints and `authorize()` about whether the current caller may perform the request.
- Laravel validates a type-hinted form request before the controller method runs.
- Use custom rule objects for complex or shared constraints, and keep business invariants in the action or domain object.
- Validate command payloads again when the same action is called from a job, command, or integration.
- Use policies or `can` middleware for resource permissions, including ownership and tenant scope.
- Do not treat client-provided role fields, hidden controls, or route visibility as authorization.

## Eloquent and persistence
- Keep Eloquent models focused on persistence mapping, relationships, casts, and invariants they own.
- Put complex or reusable query composition in a model scope, query object, or repository with a meaningful name.
- Define relationships as methods and eager-load the relationships a list or serializer will read.
- Enable `Model::preventLazyLoading()` outside production to expose accidental N+1 queries during development and tests.
- Select only the columns and relationships needed by the use case, then inspect SQL for high-volume paths.
- Protect mass assignment with `Fillable` or `Guarded` and build the allowed attribute array explicitly.
- Never pass an entire request payload to `create()`, `fill()`, or `update()` without an allowlist.
- Use query-builder parameter binding for values and never put user input into an unprepared SQL statement.
- Keep transaction ownership in the action that coordinates multiple writes.
- Use `DB::transaction()` for atomic work and configure deadlock attempts when the workload warrants retries.
- Keep database uniqueness, foreign keys, and check constraints aligned with application invariants.
- Pass stable identifiers to asynchronous work and reload current records instead of serializing a live model graph.
- Use `afterCommit()` or the queue connection's `after_commit` setting when work depends on committed rows.

## Queues and jobs
- Queue slow I/O, imports, notifications, indexing, and work that does not belong on the request critical path.
- Make a job's public payload small, serializable, and independent of `Request`, session state, or open connections.
- Implement `ShouldQueue` for asynchronous jobs and use `handle()` dependency injection for collaborators.
- Put reusable rate limiting, overlap prevention, throttling, and skip behavior in job middleware.
- Choose queue, connection, delay, timeout, retry count, and backoff as part of the job's operational contract.
- Use `tries` or `retryUntil` deliberately, and ensure the timeout is compatible with the queue retry delay.
- Design jobs to be idempotent or protect non-repeatable effects with a stable business key.
- Use unique jobs only when duplicate dispatches are semantically equivalent and the lock scope is understood.
- Dispatch after commit when the job reads rows changed by the current transaction.
- Record and inspect failed jobs, and distinguish transient dependency failures from permanent input failures.
- Test dispatch intent with `Queue::fake()` and test `handle()` behavior separately.

## Events and listeners
- Use an event for a meaningful fact or an optional extension point, not for a required step whose order is business-critical.
- Keep event payloads small and stable, with identifiers or immutable snapshots instead of mutable model graphs.
- Use listeners to decouple optional notifications, indexing, analytics, or integration work from the use case.
- Queue slow listeners with `ShouldQueue` and configure after-commit behavior when they read transaction results.
- Keep listener dependencies type-hinted so Laravel can resolve them through the container.
- Use `Event::fake()` to assert dispatch without executing listeners, then test each listener independently.
- Document event ordering or propagation only when correctness depends on it.

## Errors and HTTP responses
- Map validation, authentication, authorization, not-found, conflict, and dependency failures to deliberate response contracts.
- Translate domain and infrastructure exceptions to HTTP responses at the HTTP boundary.
- Configure reporting, context, ignoring, and rendering through `withExceptions()` in `bootstrap/app.php`.
- Return a safe, stable JSON error shape and never expose stack traces, SQL, credentials, or internal paths in production.
- Log an unexpected exception once with request, user, tenant, command, or entity context that is safe to retain.
- Retry only failures likely to recover and route permanent job failures to a visible review path.
- Preserve the original exception when adding context, and do not catch an exception merely to return success-shaped data.

## Security
- Use `auth` middleware for authentication and policies or `can` middleware for object-level authorization.
- Protect cookie-authenticated POST, PUT, PATCH, and DELETE forms with Laravel's CSRF middleware and token helpers.
- Exempt a webhook from CSRF only when the endpoint authenticates the provider's signature and replay policy.
- Hash passwords with `Hash` or the configured authentication stack and never log plaintext credentials.
- Keep Eloquent mass-assignment allowlists and query bindings enabled for all user-controlled data.
- Escape rendered output by default and review deliberate raw HTML output as a security-sensitive boundary.
- Apply route rate limiters to login, password reset, expensive endpoints, and resource-amplifying actions.
- Use Sanctum's stateful SPA flow when same-site cookie authentication is the intended API model.
- Validate uploaded files by size, type, storage destination, and content handling rather than trusting names or MIME headers.

## Configuration and secrets
- Use environment variables for deployment-specific infrastructure values and named config for application behavior.
- Read `env()` only from configuration files and use `config()` from application code.
- Verify `config:cache` in deployment because cached configuration stops loading `.env` values during requests.
- Keep secrets in the deployment secret store, encrypted environment, or a dedicated secret service.
- Never commit production keys, tokens, database passwords, or diagnostic dumps.

## Testing
- Make feature tests the main safety net for HTTP behavior, authorization, validation, persistence, and serialization.
- Unit-test deterministic domain rules and actions without booting more framework than the subject needs.
- Use HTTP assertions for status, redirects, validation errors, JSON shape, headers, and authenticated behavior.
- Use `Queue::fake()` and `Event::fake()` to assert dispatch intent without running asynchronous side effects.
- Bind fakes or mocks into the container at external boundaries instead of mocking every facade by default.
- Use `withoutExceptionHandling()` when a failing feature test needs the original exception and stack.
- Test rollback, not-found behavior, authorization failures, duplicate delivery, retry exhaustion, and error rendering.
- Keep tests independent and use factories or explicit fixtures that describe the scenario under test.
- Run formatting, static analysis, focused tests, and the full test suite in CI.

## Avoiding Laravel ceremony
- Start with a route, controller, form request, model or query, action only when needed, and a feature test.
- Prefer a named action over a generic service and a meaningful query over a repository interface with one pass-through method.
- Prefer a direct call over an event for required work and a real queue over a synchronous wrapper that hides latency.
- Do not add a service provider, facade, contract, observer, listener, or job until a real responsibility justifies it.
- Keep simple CRUD close to Laravel conventions and isolate only business rules or integrations that need a seam.
- Remove generated empty classes and dead bindings when the feature no longer uses them.

## Sources
### Official/maintainer
- [Laravel directory structure](https://laravel.com/docs/13.x/structure)
- [Laravel controllers](https://laravel.com/docs/13.x/controllers) and [routing](https://laravel.com/docs/13.x/routing)
- [Laravel service container](https://laravel.com/docs/13.x/container)
- [Laravel validation](https://laravel.com/docs/13.x/validation)
- [Laravel Eloquent](https://laravel.com/docs/13.x/eloquent) and [relationships](https://laravel.com/docs/13.x/eloquent-relationships)
- [Laravel database transactions](https://laravel.com/docs/13.x/database) and [query builder](https://laravel.com/docs/13.x/queries)
- [Laravel queues](https://laravel.com/docs/13.x/queues)
- [Laravel events](https://laravel.com/docs/13.x/events)
- [Laravel error handling](https://laravel.com/docs/13.x/errors)
- [Laravel configuration](https://laravel.com/docs/13.x/configuration)
- [Laravel authentication](https://laravel.com/docs/13.x/authentication), [authorization](https://laravel.com/docs/13.x/authorization), and [CSRF](https://laravel.com/docs/13.x/csrf)
- [Laravel rate limiting](https://laravel.com/docs/13.x/rate-limiting), [hashing](https://laravel.com/docs/13.x/hashing), and [Sanctum](https://laravel.com/docs/13.x/sanctum)
- [Laravel testing](https://laravel.com/docs/13.x/testing), [HTTP tests](https://laravel.com/docs/13.x/http-tests), and [mocking](https://laravel.com/docs/13.x/mocking)
- [Laravel application skeleton](https://github.com/laravel/laravel), [framework source](https://github.com/laravel/framework), and [queue source](https://github.com/laravel/framework/blob/13.x/src/Illuminate/Bus/Queueable.php)
### Practitioner/community
- [Laracasts: The Many Misconceptions of Laravel](https://laracasts.com/series/the-many-misconceptions-of-laravel)
- [Laracasts: The Service Container](https://laracasts.com/series/laravel-5-fundamentals/episodes/26)
