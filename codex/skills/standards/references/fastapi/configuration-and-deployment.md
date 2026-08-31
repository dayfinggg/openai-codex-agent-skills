# Configuration and deployment

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
