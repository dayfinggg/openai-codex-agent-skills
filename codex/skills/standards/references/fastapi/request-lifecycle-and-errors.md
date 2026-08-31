# Request lifecycle and errors

- Use middleware for cross-cutting request and response behavior such as tracing, headers, timing, or request limits. [F8]
- Remember that the last-added middleware is the outermost layer on the request path and the last layer on the response path. [F8]
- Use the lifespan context for application-scoped startup and shutdown resources. [F9]
- Prefer `lifespan` over the deprecated `startup` and `shutdown` event handlers, and do not mix both styles. [F9]
- Use dependency cleanup for request-scoped resources and lifespan cleanup for app-scoped resources.
- Raise `HTTPException` for expected transport failures instead of returning an exception object. [F7]
- Install focused exception handlers that translate domain errors to stable HTTP responses without exposing internals. [F7]
- Keep request validation errors, authentication failures, authorization failures, not-found results, conflicts, and unexpected exceptions distinct.
- Let unexpected failures produce generic 500 responses and log the exception once at the boundary that can act on it.
- Include a request or trace identifier in logs, but never put credentials, tokens, SQL, or stack traces in client error bodies.
