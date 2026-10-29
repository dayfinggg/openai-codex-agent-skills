---
name: database-migration-rollout
description: "Plan and validate schema migrations with lock, data, application-compatibility, rollout, and restoration checks. Use for migration files or schema-change deployment."
---

Make the migration compatible with the database and the application versions that coexist during rollout.

1. Establish the engine and exact version, migration runner, current schema, data volume, indexes, replication, and deployment order. Inspect existing migration conventions before choosing a mechanism.
2. Identify invariants, affected reads and writes, constraint violations, and dependent objects. Separate a structural change from data transformation and access-policy changes.
3. Consult version-matched DDL documentation for lock level, table rewrite, transaction restrictions, and online or concurrent behavior. Do not infer safety from a fast empty-table test.
4. Prefer an expand, compatible application change, bounded resumable backfill, and contract sequence when coexistence requires it. A simple atomic change does not need a speculative multistage rollout.
5. Bound lock acquisition and retry according to actual traffic and operational constraints. Preserve data and stop on unexpected state. Do not cancel unrelated sessions or weaken constraints to make the migration finish.
6. Validate on an authorized representative copy or fixture. Check values, constraints, query behavior, invalid indexes, migration-runner bookkeeping, and interrupted retry where relevant.
7. Establish restoration before production execution. Distinguish transactional rollback, application rollback, compensating migration, and backup restoration. A down migration that drops newly written data is not lossless.
8. Apply only within existing authorization and verify schema, data invariants, application compatibility, waits, and replication afterward.

Read the [PostgreSQL migration procedure](../postgres/references/postgres-database-migration.md) for PostgreSQL-specific DDL. Read [PostgreSQL ALTER TABLE](https://www.postgresql.org/docs/current/sql-altertable.html) or the selected engine's official reference for its actual version.

