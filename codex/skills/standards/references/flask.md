# Flask web standards

Use this reference for Flask applications and services.
Use `python.md` for Python naming, typing, packaging, exceptions, async primitives, and general testing rules.
Prefer Flask's explicit factory, blueprint, context, and WSGI contracts before adding extensions or architecture.
Treat the current Pallets Flask documentation as normative when it conflicts with this reference.

## Application and module boundaries

- Use `create_app()` as the composition root once setup is more than trivial, and accept test configuration there. [L1]
- Create extensions without binding them to an app, then call `init_app()` inside the factory. [L1]
- Use one blueprint per business capability or bounded route group, and register blueprints before the first request. [L2] [L4]
- Keep routes, schemas, policies, query helpers, templates, and tests close to the blueprint that owns them.
- Do not import a global app instance into domain modules; use `current_app`, `request`, and `g` only in valid contexts. [L3]
- Keep the entrypoint responsible for configuration, extension initialization, blueprint registration, middleware, and error handlers.
- Avoid database calls, network calls, and mutable request state during module import.
- Do not create controller, service, repository, and mapper folders by habit.
- Add a service or use-case function only when a workflow crosses models, transactions, or external systems.

## Requests, contexts, and lifecycle

- Flask's WSGI lifecycle includes request and application contexts, URL matching, `before_request`, the view, error handling, response hooks, session saving, and teardown. [L4]
- Treat `g` as request or application-context scratch space, not as durable state between requests. [L3]
- Use `g` for resources shared during one request, and close those resources in `teardown_appcontext` or the extension's documented hook. [L3] [L12]
- Keep setup mutations out of view functions because late routes, blueprints, configuration, and extensions are not applied consistently. [L4]
- Use middleware or request hooks only for cross-cutting behavior such as tracing, authentication loading, headers, or request limits.
- Document hook ordering and whether a hook may short-circuit the request.
- Keep request parsing, authorization, application calls, response selection, and status codes visible at the view boundary.
- Keep domain code independent of Flask proxies and response objects where practical.

## Validation and persistence

- Flask has no built-in form-validation framework, so choose WTForms, Flask-WTF, or an explicit JSON schema library. [L10] [L11]
- Validate types, lengths, formats, content types, file sizes, and cross-field rules before calling application code.
- Treat request validation as shape and feedback handling; enforce durable invariants in application code and the database.
- Add CSRF tokens for cookie-authenticated state changes and test rejection of missing or invalid tokens. [L10]
- Flask does not include an ORM; choose SQLAlchemy or a maintained extension deliberately. [L5]
- Keep persistence sessions scoped to the application context and remove or close them on teardown. [L5] [L12]
- Use parameterized SQL, never interpolate user input into query text, and review raw SQL as security-sensitive. [L12]
- Use the selected ORM or query toolkit directly for ordinary CRUD and query composition.
- Add a repository only for a real persistence boundary, multiple stores, or a testable adapter contract.
- Keep query helpers near the capability that owns their meaning, and measure query count before optimizing.
- Add a service function when one use case writes multiple records or coordinates external effects.

## Errors and response contracts

- Register specific error handlers, preserve the intended status code, and return the correct HTML or JSON shape. [L6]
- Map expected validation, authentication, authorization, not-found, and conflict failures to stable client responses.
- Keep generic `Exception` handlers narrow so they do not swallow or rewrite Werkzeug HTTP exceptions. [L6]
- Do not expose tracebacks, SQL, credentials, tokens, or internal object representations in production responses.
- Log unexpected failures once at the boundary that can act on them, with a request identifier and safe context.
- Remember that a blueprint cannot handle a routing 404 before Flask knows which blueprint owns the URL; use an application-level handler when needed. [L2] [L6]
- Test both error status and response body, including errors raised by parsing, hooks, views, and teardown.

## Async and background work

- Install Flask's `async` extra before using coroutine routes, handlers, or hooks. [L7]
- Use async only for concurrent I/O that the called libraries support; async does not make CPU-bound work faster. [L7]
- Flask remains WSGI, so each async view still occupies one worker for its request. [L7]
- Do not call blocking database, filesystem, or HTTP code inside an async view unless the worker boundary is intentional.
- Do not spawn unowned background tasks in a view because unfinished tasks are cancelled when the event loop stops. [L7]
- Use a durable task queue for work that must survive request completion, retries, or process restart.
- Use an ASGI server and adapter only with a tested lifecycle, or choose an ASGI-first framework for a mainly async, long-lived, or websocket-heavy service. [L7]
- Test cancellation, timeout, cleanup, and partial-failure behavior for every async path.

## Security

- Serve authenticated traffic over HTTPS and make reverse-proxy trust explicit.
- On Flask 3.1+, set `TRUSTED_HOSTS` and configure trusted proxy values; on older versions, enforce allowed hosts at a trusted proxy or explicit early middleware. [L8] [L10]
- Keep Jinja autoescaping enabled, review `|safe` and generated HTML, and add a suitable Content Security Policy. [L10]
- Use CSRF protection for cookie sessions; Flask leaves this responsibility to the application or an extension. [L10]
- Set `SESSION_COOKIE_SECURE=True`, `SESSION_COOKIE_HTTPONLY=True`, and `SESSION_COOKIE_SAMESITE` to an appropriate value for deployed sessions. [L8] [L10]
- Set a long random `SECRET_KEY`, keep it out of source control, and rotate it according to the session policy. [L8]
- Configure exact CORS origins, methods, headers, and credentials when browser clients are cross-origin; CORS is not authentication.
- Apply request, upload, decompression, response-size, rate, and timeout limits at the edge and in the app.
- Treat uploaded files, unsafe redirects, raw SQL, and user-provided HTML as security-sensitive inputs.

## Configuration and deployment

- Load configuration early through `app.config`, environment or instance files, and the application factory. [L1] [L8]
- Keep development, test, and production configuration separate, and allow tests to pass an explicit configuration mapping. [L1]
- Use `from_prefixed_env()` or an equivalent typed loader for environment values, and fail startup on invalid required settings. [L8]
- Never enable debug mode in production and never commit a production secret key. [L8]
- Replace Flask's development server, debugger, and reloader with a dedicated production WSGI server. [L14]
- Put a reverse proxy or managed platform in front when it provides TLS termination, host filtering, buffering, or request limits. [L14]
- Configure process supervision, automatic restart, health checks, structured logs, metrics, timeouts, and graceful shutdown. [L14]
- Run migrations and other one-time preparation in one controlled process before workers accept traffic.
- Build an immutable artifact, pin dependencies, and size WSGI workers from measured latency, memory, and database connection limits.

## Testing

- Use an app fixture that calls `create_app()` and enables `TESTING=True`. [L9]
- Use Flask's test client for request, cookie, session, redirect, JSON, form, and error-handler behavior. [L9]
- Use the CLI runner for commands and database initialization workflows. [L9]
- Use an application or request context only for code that truly requires one. [L3] [L9]
- Use a full request when testing dispatch and `before_request`; a manually pushed request context does not run full dispatch. [L9]
- Test extension setup, teardown cleanup, database rollback, CSRF, host validation, and session flags.
- Keep external services behind explicit adapters and replace them with fakes or test endpoints in ordinary tests.
- Use the maintained Flask tutorial example as a compact reference for the factory, blueprints, extension setup, tests, and CLI workflow. [L13]

## Sources

### Official Flask and Python documentation

- [L1: Flask application factories](https://flask.palletsprojects.com/en/stable/patterns/appfactories/)
- [L2: Flask blueprints](https://flask.palletsprojects.com/en/stable/blueprints/)
- [L3: Flask application context](https://flask.palletsprojects.com/en/stable/appcontext/)
- [L4: Flask application lifecycle](https://flask.palletsprojects.com/en/stable/lifecycle/)
- [L5: Flask SQLAlchemy patterns](https://flask.palletsprojects.com/en/stable/patterns/sqlalchemy/)
- [L6: Flask error handling](https://flask.palletsprojects.com/en/stable/errorhandling/)
- [L7: Flask async and await](https://flask.palletsprojects.com/en/stable/async-await/)
- [L8: Flask configuration](https://flask.palletsprojects.com/en/stable/config/)
- [L9: Flask testing](https://flask.palletsprojects.com/en/stable/testing/)
- [L10: Flask web security](https://flask.palletsprojects.com/en/stable/web-security/)
- [L11: Flask WTForms pattern](https://flask.palletsprojects.com/en/stable/patterns/wtforms/)
- [L12: Flask SQLite pattern](https://flask.palletsprojects.com/en/stable/patterns/sqlite3/)
- [L14: Flask deploying to production](https://flask.palletsprojects.com/en/stable/deploying/)

### Maintainer example

- [L13: Pallets Flask maintained tutorial example](https://github.com/pallets/flask/blob/main/examples/tutorial/flaskr/__init__.py)
