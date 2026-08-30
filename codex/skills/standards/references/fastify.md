# Fastify backend standards

Build on [framework-neutral Node.js backend standards](node-backend.md).
Use Fastify's schema, plugin, lifecycle, and logging primitives instead of recreating them in middleware.
Treat each registered plugin as a deliberate capability boundary.

## Bootstrap and plugins

Create the Fastify instance in a factory and keep `listen` in a separate bootstrap function.
Register decorators, schemas, hooks, routes, and plugins before `listen`, `inject`, or `ready` starts the instance. [F5]
Use `register` for routes, utilities, and integrations so initialization and teardown follow the plugin graph. [F5]
Use encapsulation to keep feature decorators, hooks, schemas, and error handlers local. [F6]
Break encapsulation with `fastify-plugin` only when a capability is intentionally shared. [F6]
Declare plugin dependencies and register them in dependency order.
Keep plugin initialization asynchronous and fail startup when a required dependency cannot initialize.
Release plugin resources in `onClose` after traffic has drained. [F3]
Do not hide a database client or queue consumer in an unregistered module singleton.

## Request lifecycle

Choose hooks by lifecycle intent instead of putting all policy in `preHandler`.
Use `onRequest` for early metadata and cheap connection policy.
Use `preParsing` only when the raw stream must be transformed.
Use `preValidation` for normalization that is safe before schema validation.
Use `preHandler` for authentication and authorization that require parsed, validated data.
Use `preSerialization` and `onSend` only for response policy that belongs at those phases.
Use `onResponse` for completion metrics and non-blocking audit events.
Register hooks before the lifecycle event occurs, or they will not run. [F4]
Do not mix callback-style `done` with an async hook or returned promise. [F4]
Keep route handlers focused on application calls and return the response value when using async handlers.
Use `request.signal` when available or a close detector for observability and safely cancellable work.
Use raw-request close and abort indicators only for detection; Fastify's `clientErrorHandler` does not detect client aborts. [F11]
Cancel only work that is safe to abandon; give committed side effects a durable transaction, queue, or job owner.
If an abort listener can outlive successful completion, remove it explicitly in `finally`; `{ once: true }` removes it only when abort fires. [N4]

## Schemas and validation

Define JSON Schema for route bodies, parameters, query strings, headers, and responses.
Fastify compiles schemas for validation and serialization, so schemas are application code and must be trusted. [F1]
Use shared `$id` schemas and `$ref` when the same contract is reused.
Keep validation deterministic, bounded, and independent of databases or remote services.
Perform asynchronous existence or authorization checks in `preHandler` or the handler after shape validation. [F1]
Keep `allErrors` disabled unless a measured and reviewed requirement justifies the denial-of-service tradeoff. [F1]
Set `bodyLimit` and content-type parsers explicitly for each upload or media path.
Reject unsupported media types and malformed `Content-Length` values.
Define response schemas to serialize only the intended fields and to prevent accidental data exposure. [F1]
Treat validation failures as 400 responses unless the API contract deliberately maps them otherwise.
Customize the validation error format when raw schema details are not safe for clients.

## Errors and responses

Fastify catches synchronous and async route errors and routes them to its error handler. [F2]
Use `Error` instances with stable application codes, causes, and safe status metadata.
Register one root `setErrorHandler` for the public error contract, with narrower handlers only inside intentional plugin scopes. [F2]
Replace unexpected dependency messages with a generic 500 response and log the original error.
Do not forward database messages, SQL, stack traces, tokens, or internal paths.
Remember that Fastify's default serializer forwards `message` and `code` unless the application replaces them. [F2]
Use `reply.sent` and clear returns to prevent duplicate sends.
Do not throw strings or arbitrary primitives from routes or hooks; throw `Error` instances. [F2]
Keep error handlers free of new failure paths, and let parent handlers handle errors outside their scope.
Use response schemas for both success and deliberately shaped error responses.

## Logging and observability

Enable Fastify logging at instance creation and configure it by environment. [F7]
Use the built-in Pino logger for structured JSON in production. [F7]
Use `request.log` in handlers and `fastify.log` for application lifecycle events. [F7]
Keep pretty transports in development or test, not in production. [F7]
Include request ID, route template, method, status, duration, error code, and dependency identifiers.
Redact authorization headers, cookies, passwords, tokens, and personal data before serialization.
Do not log full request bodies by default.
Record request rate, status classes, latency percentiles, event-loop delay, pool saturation, and queue depth.
Use `onResponse` for completion metrics and avoid delaying the response for telemetry.

## Security and performance

Prefer Fastify-native plugins such as `@fastify/helmet`, `@fastify/cors`, and `@fastify/static` over Express middleware where available. [F10]
Fastify does not provide Express-style middleware by default; use a supported plugin only when a native hook or plugin is not appropriate. [F10]
Apply security plugins before the routes they protect and scope them through encapsulation when needed.
Keep request body limits, parameter limits, and handler timeouts explicit.
Use response schemas and compiled serializers on hot routes after measuring their effect. [F1]
Avoid synchronous work and unbounded loops in handlers and hooks.
Use streams and `stream.pipeline()` for large transfers and abort propagation. [N5]
Benchmark the complete service under representative payloads and concurrency.
Use event-loop delay, memory, file descriptors, pool saturation, and error rate as capacity signals.

## Testing

Export the Fastify factory and use `inject()` for route tests without opening a network socket. [F8]
Call `ready()` when a test must assert plugin registration or startup failure.
Close the Fastify instance in teardown so `onClose` hooks release clients and consumers.
Test plugin encapsulation by asserting which routes, decorators, hooks, and errors are visible in each scope.
Test malformed schemas, unsupported media types, oversized bodies, validation errors, and response filtering.
Test authentication, authorization, request aborts, handler timeouts, dependency failures, and duplicate sends.
Test custom error handling with both deliberate client errors and unexpected dependency errors.
Keep a small real-network suite for TLS, proxy headers, streaming, and deployment configuration.

## Choose Fastify deliberately

Choose Fastify when schema-first contracts, plugin encapsulation, structured Pino logging, or measured throughput matter.
Use plain Node or Express when the service needs a tiny explicit pipeline and no Fastify-specific features.
Use NestJS with the Fastify adapter when Nest's module and DI conventions are required and adapter compatibility is proven.
Do not select Fastify from a synthetic benchmark alone.
Use the official Fastify demo as a maintained application-level example rather than copying isolated snippets. [F9]

## Sources

### Official Fastify and Node.js documentation

- [F1: Fastify validation and serialization](https://fastify.dev/docs/latest/Reference/Validation-and-Serialization/)
- [F2: Fastify errors](https://fastify.dev/docs/latest/Reference/Errors/)
- [F3: Fastify lifecycle](https://fastify.dev/docs/latest/Reference/Lifecycle/)
- [F4: Fastify hooks](https://fastify.dev/docs/latest/Reference/Hooks/)
- [F5: Fastify plugin guide](https://fastify.dev/docs/latest/Guides/Plugins-Guide/)
- [F6: Fastify encapsulation](https://fastify.dev/docs/latest/Reference/Encapsulation/)
- [F7: Fastify logging](https://fastify.dev/docs/latest/Reference/Logging/)
- [F8: Fastify testing](https://fastify.dev/docs/latest/Guides/Testing/)
- [F10: Fastify middleware and native alternatives](https://fastify.dev/docs/latest/Reference/Middleware/)
- [F11: Fastify detecting client aborts](https://fastify.dev/docs/latest/Guides/Detecting-When-Clients-Abort/)

### Maintainer examples

- [F9: Fastify official demo application](https://github.com/fastify/demo)

### Official Node.js documentation

- [N4: Node.js Global AbortController and AbortSignal](https://nodejs.org/api/globals.html)
- [N5: Node.js Streams](https://nodejs.org/api/stream.html)
