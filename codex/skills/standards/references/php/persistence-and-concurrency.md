# Persistence and concurrency

- Inspect query count, execution plans, indexes, and data volume before adding caching or changing storage. Avoid N+1 queries with focused eager loading or projections. Use bounded pagination/batches rather than loading an entire table into PHP memory.
- Put uniqueness and referential invariants in database constraints where supported. A check followed by an insert races. Map constraint failures to the application's expected outcome without hiding unrelated errors.
- Keep transactions short and own them at the operation boundary. Do not hold database locks during remote HTTP calls or user interactions. Understand the actual database's isolation, lock, and implicit-commit behavior.
- Select optimistic version checks or pessimistic locking from the contention and consistency requirement. On retryable deadlocks, retry the complete transaction only when effects are safe to repeat, with a bounded retry policy. Never repeat an external charge blindly.
- Treat ORM entities and their unit of work as scoped state. After rollback or a closed entity manager, follow the installed ORM's recovery contract rather than reusing potentially inconsistent objects.
- Publishing a message after commit avoids observing uncommitted rows but does not guarantee delivery if the process dies between commit and publish. Where durable delivery is required, use the existing transactional outbox or equivalent reliable mechanism.
- For rolling deployments, make schema changes compatible with old and new code before removing fields. Separate schema expansion, bounded backfill, and contraction when required. Test migration behavior against the actual database version and representative data.
- Do not infer portability from SQLite-only tests when production uses another database. Exercise affected locking, JSON, collation, and transaction behavior on the production engine.

Sources: [PDO transactions](https://www.php.net/manual/en/pdo.transactions.php) and [Doctrine transactions and concurrency](https://www.doctrine-project.org/projects/doctrine-orm/en/current/reference/transactions-and-concurrency.html). Use the installed database's reference for SQL and isolation semantics.
