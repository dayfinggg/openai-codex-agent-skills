# Configuration and deployment

- Load configuration early through `app.config`, environment or instance files, and the application factory. [L1] [L8]
- Keep development, test, and production configuration separate, and allow tests to pass an explicit configuration mapping. [L1]
- Use `from_prefixed_env()` or an equivalent typed loader for environment values, and fail startup on invalid required settings. [L8]
- Never enable debug mode in production and never commit a production secret key. [L8]
- Replace Flask's development server, debugger, and reloader with a dedicated production WSGI server. [L14]
- Put a reverse proxy or managed platform in front when it provides TLS termination, host filtering, buffering, or request limits. [L14]
- Configure process supervision, automatic restart, health checks, structured logs, metrics, timeouts, and graceful shutdown. [L14]
- Run migrations and other one-time preparation in one controlled process before workers accept traffic.
- Build an immutable artifact, pin dependencies, and size WSGI workers from measured latency, memory, and database connection limits.
