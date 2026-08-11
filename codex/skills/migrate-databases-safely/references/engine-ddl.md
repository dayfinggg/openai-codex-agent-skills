# Engine DDL considerations

**Reviewed:** 2026-08-11
**Scope:** PostgreSQL 18 current pages, MySQL 8.4 pages, SQLite current pages, and MongoDB current manual. Use documentation matching the deployed engine and version.

## PostgreSQL

- Inspect lock level, table rewrite, validation, index-build mode, invalid index cleanup, transaction limits, WAL growth, replica impact, and disk needs.
- Separate creation and validation where supported when that reduces blocking without weakening the final invariant.
- Remember that concurrent index operations have restrictions and failure states. Monitor them explicitly.

## MySQL or MariaDB

- Verify the storage engine and supported `ALGORITHM` and `LOCK` behavior for the exact operation. A requested online mode can fall back or fail depending on version and table features.
- Account for rebuild space, metadata locks, binary log and replica effects, and failure cleanup.
- Use MariaDB documentation for MariaDB rather than assuming MySQL parity.

## SQLite

- Many schema changes rebuild tables. Rehearse the exact library version, foreign-key behavior, journal mode, disk space, and application connection lifecycle.
- Keep a verified backup and integrity check. Test interruption and restart behavior in an isolated copy.

## MongoDB

- Treat document validation, index builds, sharding keys, resharding, and collection transformations as data migrations with capacity and compatibility gates.
- Backfill in bounded batches and account for replication lag, write concern, retry semantics, and mixed-version clients.

## Official sources

- [PostgreSQL CREATE INDEX](https://www.postgresql.org/docs/current/sql-createindex.html)
- [PostgreSQL ALTER TABLE](https://www.postgresql.org/docs/current/sql-altertable.html)
- [MySQL online DDL](https://dev.mysql.com/doc/refman/8.4/en/innodb-online-ddl.html)
- [SQLite ALTER TABLE](https://www.sqlite.org/lang_altertable.html)
- [MongoDB schema versioning](https://www.mongodb.com/docs/manual/data-modeling/design-patterns/data-versioning/schema-versioning/)
