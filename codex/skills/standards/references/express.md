# Express 5 backend standards

Build on [framework-neutral Node.js backend standards](node-backend.md).
Use Express 5 as an explicit middleware and routing pipeline, not as a hidden application container.
Keep the app factory separate from the server bootstrap so tests can import the app without binding a port.

## Composition and request boundaries

Create the app in one factory and register global middleware in deliberate order.
Use routers to group one cohesive resource or capability under a clear mount path.
Keep route handlers thin and delegate application work to services with explicit dependencies.
Make the pipeline visible as security, request ID, access logging, parsers, authentication, routes, not-found handling, and errors.
Remember that middleware loaded first executes first and a handler that neither responds nor calls `next()` leaves the request hanging. [E1]
Use `app.use()` for cross-cutting middleware and router-level middleware for feature-specific policy. [E1]
Do not mutate request objects with undocumented fields when an explicit context object will do.
Do not let route handlers call database or queue clients through hidden module globals.
Keep route path and HTTP method ownership unambiguous.

## Parsing and validation

Apply `express.json()`, `express.urlencoded()`, `express.raw()`, or `express.text()` only where each parser is needed. [E1]
Set parser limits and accepted media types explicitly.
Mount raw-body parsing before JSON parsing for signed webhook endpoints.
Validate route parameters, query values, headers, cookies, and parsed bodies at the route boundary.
Reject unknown fields when the endpoint contract is closed.
Use a runtime schema library or validator because TypeScript annotations do not validate incoming data.
Validate response shape and serialize an allowlisted object rather than returning an ORM entity directly.
Return a stable error body with status, application code, and request identifier.
Do not put database lookups in a parser or cheap shape-validation middleware.
Keep validation errors safe to expose and log only the minimum detail needed to diagnose them.

## Async handlers and errors

Use `async` route handlers and return their promises.
Express 5 forwards rejected promises and thrown async errors to `next` automatically. [E2]
If a promise is not returned, Express cannot observe its rejection; attach `.catch(next)` or return it. [E2]
Use `next(err)` for errors that occur after an asynchronous callback begins.
Define error middleware with exactly four parameters, `(err, req, res, next)`, and register it last. [E1]
Map known validation, authentication, authorization, not-found, conflict, and dependency errors deliberately.
Treat unknown errors as internal failures and do not expose their stack, SQL, file paths, or secrets in production. [E2]
If headers were sent, delegate to the default handler or close the stream rather than writing a second response. [E2]
Never catch an error only to log it and continue with inconsistent state.
Use `Error` instances with stable codes and causes so handlers do not match mutable messages.

## Security

Use a maintained Node.js LTS release and keep Express and its dependencies current. [E3]
Use TLS directly or through a trusted reverse proxy, and configure `trust proxy` for the actual topology.
Install Helmet before routes and other middleware that emit responses. [E1][E4]
Use secure, HttpOnly, scoped cookies and an explicit same-site policy.
Do not trust redirect targets, host headers, forwarded headers, query strings, or object keys.
Prevent open redirects and validate filesystem paths before any file operation.
Apply authentication before authorization and enforce authorization in each protected router.
Rate-limit login, token, upload, search, and resource-amplifying endpoints.
Use conservative CORS, CSRF, upload, and content-security policies for the deployment model.
Audit dependencies, remove unused middleware, and never log credentials or tokens.
Disable fingerprinting and avoid default session cookie names in production. [E4]

## Performance and lifecycle

Do not use synchronous filesystem, compression, crypto, or child-process APIs in request handlers.
Bound JSON, regular-expression, decompression, and upload work before processing it.
Use streaming APIs for large responses and preserve backpressure.
Use compression middleware where it improves the measured response path, and avoid compressing already-compressed media. [E3]
Cache only responses with explicit freshness and invalidation rules.
Set server and upstream timeouts; do not rely on a reverse proxy to protect every deployment.
Start clients and pools during bootstrap, and close them during graceful shutdown.
Keep the `app` object independent from `http.Server` so `server.close()` can stop new connections and drain active work. [N1]
On client disconnect, cancel only safely cancellable work and give committed side effects a durable transaction, queue, or job owner.
If a close or abort listener can outlive successful completion, remove it in `finally`; `{ once: true }` removes it only when abort fires. [N4]
In Express 5, handle the `app.listen` callback's error argument rather than assuming bind failures throw synchronously. [E6]
Use readiness checks that fail before traffic reaches an uninitialized dependency.

## Logging and observability

Use a trusted structured logger in request middleware and application services.
Include request ID, route template, method, status, duration, and stable error code.
Redact authorization headers, cookies, passwords, tokens, and personal data.
Do not log full request bodies by default.
Emit one completion record per request and additional records for meaningful state changes or failures.
Record request rate, status classes, latency percentiles, event-loop delay, dependency latency, and saturation.
Preserve the request ID across outbound calls and background jobs.

## Testing

Export the app factory and test it without calling `listen` when possible.
Use an ephemeral port for tests that require a real server.
Exercise the real middleware order with malformed input, unsupported media types, auth failures, and oversized bodies.
Test returned and unreturned promise failures, error middleware, headers-sent behavior, and not-found handling.
Assert response shape and redaction as well as status and headers.
Close the server, clients, timers, and pools in teardown.
Use Node's `node:test` runner or the project's existing runner for deterministic unit and boundary tests. [N9]
Keep a small integration suite for proxy trust, TLS, uploads, streaming, and dependency wiring.

## Choose Express deliberately

Choose Express when the team benefits from minimal framework policy, explicit middleware, and broad ecosystem compatibility.
Prefer direct factories and routers before adding a DI container or a framework-wide abstraction layer.
Choose Fastify when schema compilation, plugin encapsulation, or measured throughput is the primary constraint.
Choose NestJS when enforced modules, dependency injection, and cross-cutting framework conventions are the primary constraint.
Do not select Express or reject it from a synthetic benchmark alone.

## Sources

### Official Express and Node.js documentation

- [E1: Express middleware](https://expressjs.com/en/guide/using-middleware/)
- [E2: Express 5 error handling](https://expressjs.com/en/5x/guide/error-handling/)
- [E3: Express production performance and reliability](https://expressjs.com/en/advanced/best-practice-performance/)
- [E4: Express production security](https://expressjs.com/en/advanced/best-practice-security/)
- [E5: Express official repository and examples](https://github.com/expressjs/express)
- [E6: Express 5 migration guide](https://expressjs.com/en/guide/migrating-5/)
- [N1: Node.js HTTP API](https://nodejs.org/api/http.html)
- [N4: Node.js Global AbortController and AbortSignal](https://nodejs.org/api/globals.html)
- [N9: Node.js Test Runner](https://nodejs.org/api/test.html)
