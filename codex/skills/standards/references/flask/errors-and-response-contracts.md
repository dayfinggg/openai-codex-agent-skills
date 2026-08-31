# Errors and response contracts

- Register specific error handlers, preserve the intended status code, and return the correct HTML or JSON shape. [L6]
- Map expected validation, authentication, authorization, not-found, and conflict failures to stable client responses.
- Keep generic `Exception` handlers narrow so they do not swallow or rewrite Werkzeug HTTP exceptions. [L6]
- Do not expose tracebacks, SQL, credentials, tokens, or internal object representations in production responses.
- Log unexpected failures once at the boundary that can act on them, with a request identifier and safe context.
- Remember that a blueprint cannot handle a routing 404 before Flask knows which blueprint owns the URL; use an application-level handler when needed. [L2] [L6]
- Test both error status and response body, including errors raised by parsing, hooks, views, and teardown.
