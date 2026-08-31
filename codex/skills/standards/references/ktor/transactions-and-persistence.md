# Transactions and persistence
- Ktor leaves transaction policy to the selected database library, so make the boundary explicit in infrastructure.
- Keep the service responsible for the unit of work and the repository responsible for database-specific operations.
- The Ktor Exposed guide demonstrates an interface-backed repository, an in-memory fake, and a PostgreSQL repository.
- Treat JDBC access as blocking even when called from a `suspend` function and move it to an appropriate IO dispatcher.
- Use R2DBC or another non-blocking driver only when the complete data path supports that model.
- Do not share a transaction across unrelated coroutines or threads unless the driver explicitly supports it.
- Test database locking, isolation, constraints, migrations, and rollback behavior against a real database.
