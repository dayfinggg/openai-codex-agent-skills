# Requests, contexts, and lifecycle

- Flask's WSGI lifecycle includes request and application contexts, URL matching, `before_request`, the view, error handling, response hooks, session saving, and teardown. [L4]
- Treat `g` as request or application-context scratch space, not as durable state between requests. [L3]
- Use `g` for resources shared during one request, and close those resources in `teardown_appcontext` or the extension's documented hook. [L3] [L12]
- Keep setup mutations out of view functions because late routes, blueprints, configuration, and extensions are not applied consistently. [L4]
- Use middleware or request hooks only for cross-cutting behavior such as tracing, authentication loading, headers, or request limits.
- Make hook ordering and short-circuit behavior visible through registration order, tests, or public API documentation when callers need the contract.
- Keep request parsing, authorization, application calls, response selection, and status codes visible at the view boundary.
- Keep domain code independent of Flask proxies and response objects where practical.
