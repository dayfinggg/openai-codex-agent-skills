# Database boundary

- Create one async database pool before `HttpServer::new`, wrap the shared handle in `web::Data`, and clone the handle into each app instance [D1] [B1].
- Keep SQL, row mapping, and driver errors in a repository or infrastructure module rather than in route modules.
- Let an application service own use-case transaction scope and keep transactions narrow [D2].
- Acquire connections close to the query and release them before unrelated awaits.
- Use bound parameters and database constraints, and consider SQLx compile-time checked queries when SQLx is selected [D3].
- Configure pool size, acquire timeout, query timeout, and shutdown behavior from deployment limits [D1].
- Test migrations, constraints, query shape, and rollback against an isolated real database.
