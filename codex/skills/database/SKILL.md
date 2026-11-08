---
name: database
description: Change PostgreSQL or MySQL schema, queries, or data, or operate a production database.
---

Confirm the engine, version, target host, and database without exposing credentials.
Production writes and destructive commands require explicit authorization for the target and effect. Reuse authorization already given for that operation.
Before a destructive change, preserve a recoverable backup and count the rows using the same predicate.
Use a transaction where supported, compare affected rows before committing, and keep backups private.
Investigate production data read-only. EXPLAIN ANALYZE executes its statement.
Do not reset a database to resolve migration drift. Report the drift and its cause.
For migrations, inspect the generated SQL and test on a disposable or restored database first.
Check locks, table rewrites, old-application compatibility, and rollback. Set a deliberate lock timeout.
Separate expansion, backfill, switched reads, and removal when old and new code must coexist.
Use bounded, restartable batches for backfills. Keep them separate from schema changes.
Bind query values and allowlist dynamic identifiers.
Select the engine reference for the work.
- PostgreSQL tables and constraints use [postgres-schema.md](references/postgres-schema.md).
- PostgreSQL queries and transactions use [postgres-queries.md](references/postgres-queries.md).
- PostgreSQL connections and access control use [postgres-operations.md](references/postgres-operations.md).
- MySQL schema changes use [mysql-online-ddl.md](references/mysql-online-ddl.md).
- MySQL locking and transactions use [mysql-transactions.md](references/mysql-transactions.md).

Report unresolved lock, compatibility, or recovery risks and any migration stages left for later deployment.
