# Request lifecycle

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
