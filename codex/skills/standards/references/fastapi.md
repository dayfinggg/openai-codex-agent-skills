# FastAPI web standards

Use this reference for FastAPI services and APIs.
Use `python.md` for Python naming, typing, packaging, exceptions, async primitives, and general testing rules.
Prefer FastAPI's typed request, response, dependency, and lifespan contracts before adding framework layers.
Treat the current FastAPI and Starlette documentation as normative when it conflicts with this reference.

## Application and module boundaries

- Keep `main.py` small and use it as the composition root for the `FastAPI` app, middleware, lifespan, and routers. [F1]
- Use one `APIRouter` per business capability or bounded route group.
- Apply a router's prefix, tags, common responses, and shared dependencies at the router boundary. [F1]
- Keep route modules focused on transport concerns and call application functions for business workflows.
- Keep domain code independent of `Request`, `Response`, `Depends`, and other FastAPI objects where practical.
- Use `Depends()` for authentication, authorization, database sessions, shared policy, and resource lifetime. [F2]
- Prefer `Annotated` dependency declarations so type information remains visible to editors and checkers. [F2]
- Avoid import-time database calls, network calls, and mutable global request state.
- Do not create controller, service, repository, and mapper layers by habit.
- Add an application service only when a use case spans entities, requires one transaction, or coordinates external effects.

## Input and output contracts

- Declare request bodies with Pydantic models and constrain path, query, header, cookie, and form values at the boundary. [F3]
- Treat Pydantic validation as input parsing, not as a replacement for authorization or cross-record business rules.
- Reject or explicitly handle unknown fields when the API contract is closed.
- Declare return types or `response_model` for every public operation. [F4]
- Use output models to validate and document responses and to filter fields that must not leave the service. [F4]
- Use different input and output models for passwords, tokens, internal IDs, audit fields, and write-only data. [F4]
- Keep ORM or persistence objects internal and map them to response schemas.
- Never merge arbitrary request data into a persistence object or return a persistence object without an output contract.
- Keep status codes, pagination, error shapes, and OpenAPI metadata stable once clients depend on them.
- Test malformed input, boundary values, missing fields, response filtering, and serialization failures.

## Persistence and application services

- FastAPI does not force a database or ORM; choose the SQL or document toolkit that fits the service. [F5]
- Use the selected ORM or query toolkit directly for ordinary CRUD and query composition.
- Add a repository only for a real persistence boundary, multiple stores, or a testable adapter contract.
- Provide a database session through a dependency with `yield`, and close or roll back it in the cleanup path. [F6]
- Scope a session to the request unless a longer lifetime is explicit and safe.
- Keep transaction orchestration in an application function when a workflow writes several entities.
- Make commits, rollbacks, retries, idempotency, and external side effects explicit.
- Do not publish a message, invalidate a cache, or enqueue work before the transaction that makes it valid commits.
- Keep query helpers near the capability that owns their meaning, and measure query count before optimizing.

## Request lifecycle and errors

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

## Async and concurrency

- Use `async def` when the libraries in the call chain expose awaitable I/O. [F10]
- Use a normal `def` path operation for blocking I/O because FastAPI runs sync path operations and dependencies in a threadpool. [F10]
- Do not assume a normal `def` utility called from an async function is offloaded; it runs directly and can block the event loop. [F10]
- Prefer async database and HTTP clients for an async path, or move blocking work behind an intentional worker boundary.
- Do not use async merely to wrap CPU-bound code; use a process, worker, or task queue for expensive computation.
- Bound concurrency with connection pools, semaphores, queue limits, request limits, and deadlines.
- Treat cancellation as normal, release resources in `finally` or dependency cleanup, and avoid unowned fire-and-forget tasks.
- Use a durable task queue for work that must survive a request, process restart, or retry.
- Test timeout, cancellation, backpressure, and partial-failure behavior rather than only successful awaits.

## Security

- Use FastAPI `Security` utilities and a documented OAuth2 or equivalent scheme for authentication and authorization. [F11]
- Treat OpenAPI security metadata as documentation and dependency wiring, not as enforcement by itself.
- Verify tokens, scopes, tenant access, and resource ownership in dependencies or application policy code.
- Enforce HTTPS at the proxy or platform, configure trusted proxy headers deliberately, and restrict accepted hosts.
- Configure CORS with exact allowed origins, methods, headers, and credentials; CORS is not authentication.
- Apply request, upload, decompression, and response-size limits at the edge and in the app.
- Hash passwords with a maintained password-hashing library, never log credentials, and never return a password field.
- Use parameterized database queries and treat raw SQL, unsafe redirects, file names, and HTML rendering as security-sensitive.
- Add rate limits and replay or idempotency defenses to authentication, password reset, and other high-impact endpoints.

## Configuration and deployment

- Define settings with `pydantic_settings.BaseSettings` for Pydantic 2, and read environment values through typed fields and validation. [F12]
- Keep settings in a dedicated module and expose them through a cached dependency when tests need overrides. [F12]
- Keep production secrets in environment or secret storage, not in source, `.env` files committed to the repository, or OpenAPI schemas.
- Fail startup when required settings, database connectivity, migrations, or key material are invalid.
- Terminate HTTPS outside the app or on the managed platform, and run the ASGI app under Uvicorn or an equivalent production server. [F15]
- Use a process supervisor or platform that starts the service automatically and restarts crashed processes. [F15]
- Add workers or replicas from measured load, remembering that each process has its own memory and database connections. [F15]
- Run migrations and other one-time preparation in one controlled process before workers accept traffic. [F15]
- Add readiness and liveness checks, graceful shutdown, structured logs, metrics, timeouts, and database pool limits.
- Use the maintained full-stack template as an example of PostgreSQL, Pydantic, tests, Docker Compose, proxying, and CI, not as a mandatory stack. [F14]
- Treat the FastAPI creator's PyCon Sweden keynote listing as conference context, not as a substitute for current API documentation. [T1]

## Testing

- Use `TestClient` for ordinary synchronous pytest request tests. [F13]
- Use HTTPX `AsyncClient` with `ASGITransport` and an async pytest plugin for async tests. [F16]
- Use `app.dependency_overrides` to replace databases, authentication providers, settings, and external services in focused tests. [F17]
- Use `with TestClient(app)` when a test must execute the app lifespan and cleanup. [F18]
- Test router prefixes, OpenAPI output, response filtering, validation errors, authorization scopes, and error handlers.
- Test database rollback, unique conflicts, transaction boundaries, idempotency, retries, and background-job handoff.
- Keep external integration tests explicit and limited, and do not call paid or stateful services from ordinary unit tests.

## Sources

### Official FastAPI and maintainer documentation

- [F1: FastAPI bigger applications](https://fastapi.tiangolo.com/tutorial/bigger-applications/)
- [F2: FastAPI dependencies](https://fastapi.tiangolo.com/tutorial/dependencies/)
- [F3: FastAPI request bodies](https://fastapi.tiangolo.com/tutorial/body/)
- [F4: FastAPI response models](https://fastapi.tiangolo.com/tutorial/response-model/)
- [F5: FastAPI SQL databases](https://fastapi.tiangolo.com/tutorial/sql-databases/)
- [F6: FastAPI dependencies with yield](https://fastapi.tiangolo.com/tutorial/dependencies/dependencies-with-yield/)
- [F7: FastAPI handling errors](https://fastapi.tiangolo.com/tutorial/handling-errors/)
- [F8: FastAPI middleware](https://fastapi.tiangolo.com/tutorial/middleware/)
- [F9: FastAPI lifespan events](https://fastapi.tiangolo.com/advanced/events/)
- [F10: FastAPI concurrency and async](https://fastapi.tiangolo.com/async/)
- [F11: FastAPI security first steps](https://fastapi.tiangolo.com/tutorial/security/first-steps/)
- [F12: FastAPI settings and environment variables](https://fastapi.tiangolo.com/advanced/settings/)
- [F13: FastAPI testing](https://fastapi.tiangolo.com/tutorial/testing/)
- [F15: FastAPI deployment concepts](https://fastapi.tiangolo.com/deployment/concepts/)
- [F16: FastAPI async tests](https://fastapi.tiangolo.com/advanced/async-tests/)
- [F17: FastAPI testing dependency overrides](https://fastapi.tiangolo.com/advanced/testing-dependencies/)
- [F18: FastAPI testing lifespan events](https://fastapi.tiangolo.com/advanced/testing-events/)

### Maintainer example

- [F14: FastAPI maintained full-stack template](https://github.com/fastapi/full-stack-fastapi-template/blob/master/README.md)

### Practitioner and community material

- [T1: PyCon Sweden program listing Sebastián Ramírez's FastAPI keynote](https://pycon.se/2023/)
