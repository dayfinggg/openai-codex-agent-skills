# PostgreSQL quality standard

Use this review baseline for PostgreSQL schemas, queries, migrations, and operations.
Pin the deployed PostgreSQL major version in CI and verify version-sensitive behavior against it.
Treat DDL, roles, extensions, indexes, and maintenance settings as versioned code.
Prefer production-shaped data and measured plans over rules of thumb.

## Reference map

- [Types](types.md)
- [Constraints](constraints.md)
- [Indexes](indexes.md)
- [EXPLAIN](explain.md)
- [Transactions and locking](transactions-and-locking.md)
- [JSONB](jsonb.md)
- [Extensions](extensions.md)
- [Migrations](migrations.md)
- [Partitioning](partitioning.md)
- [Vacuum and statistics](vacuum-and-statistics.md)
- [WAL and durability](wal-and-durability.md)
- [Connection handling](connection-handling.md)
- [Security](security.md)
- [Operationally safe schema design](operationally-safe-schema-design.md)
- [Sources](sources.md)
