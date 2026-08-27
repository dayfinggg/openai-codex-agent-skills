---
name: database
description: Design, change, query, migrate, and validate production data stores using the actual database engine, version, workload, and operational constraints. Use for relational, document, key-value, schema, query, transaction, migration, backfill, pooling, backup, recovery, privacy, and multitenancy work.
---

# Database

Preserve data integrity first. Prefer the simplest schema and storage model that satisfies confirmed access, consistency, scale, privacy, and recovery requirements.

## Start from the actual system

1. Identify the exact database product and version, extensions, topology, replication mode, driver, ORM or query builder, migration framework, connection pool, and deployment process. Use official documentation for those versions.
2. Establish the required invariants, read and write access patterns, data volume and distribution, concurrency, latency and throughput targets, consistency model, retention, privacy, tenant isolation, and recovery objectives before choosing a design.
3. Inspect the current schema, constraints, migrations, generated SQL, representative query plans, statistics, production-like data shape, tests, backup configuration, and supported application versions.
4. Preserve existing public behavior, persisted formats, compatibility promises, and requested scope. Do not replace the database, ORM, schema style, or migration system without a demonstrated requirement.

## Make integrity explicit

1. Represent stable business invariants with database types and constraints when the engine can enforce them. Prefer primary keys, foreign keys, unique, check, not-null, and exclusion constraints over application-only assumptions.
2. Keep one authoritative representation of mutable facts. Normalize by default where duplication would require coordinated writes. Denormalize only for a measured access path with explicit ownership, synchronization, repair, and validation.
3. Use transactions for the smallest unit that must commit atomically. Select an isolation level from the anomalies the operation must prevent, not from habit.
4. Make retries and repeated jobs safe through idempotent operations, stable operation identifiers, uniqueness constraints, compare-and-set semantics, or durable progress checkpoints.
5. Parameterize values and identifiers through supported APIs. Apply least privilege, tenant isolation, encryption, retention, and deletion requirements at every data boundary.

## Load conditional guidance

1. Read [references/modeling.md](references/modeling.md) when choosing a data store, designing schemas, constraints, indexes, queries, pagination, denormalization, privacy, or multitenancy.
2. Read [references/operations.md](references/operations.md) when working with transactions, locking, consistency, migrations, backfills, pooling, backups, recovery, or database tests.
3. Do not load either reference for a trivial query or mapping change whose behavior is fully determined by adjacent code and existing tests.

## Change data safely

1. Treat schema and data changes as deployment workflows, not isolated SQL statements. Account for old and new application versions running concurrently.
2. Prefer expand, migrate, verify, and contract across separate deployable steps. Do not remove or reinterpret data while any supported reader or writer still depends on the old representation.
3. Make every migration reversible when the original state can be recovered safely. If an operation is inherently destructive, declare the exact point of irreversibility, preconditions, backup or copy, verification, rollback boundary, and roll-forward recovery path.
4. Keep backfills bounded, resumable, idempotent, observable, throttled, and compatible with live writes. Avoid long transactions and full-table updates on production-sized data.
5. Do not add an index, partition, cache, replica, shard, or duplicate field without a measured query or operational need and a stated maintenance cost.

## Validate with the real semantics

1. Test against the same database engine and compatible version used in production when constraints, types, transactions, locking, query planning, or migrations matter. In-memory substitutes do not prove production behavior.
2. Verify schema creation from an empty database and upgrades from every supported starting version. Test rollback or the documented recovery path at the irreversibility boundary.
3. Exercise constraints, invalid data, duplicate and concurrent writes, transaction retries, partial failure, tenant separation, pagination stability, pool exhaustion, and cancellation where relevant.
4. Capture query text, representative parameters, plan, actual row counts, timing, buffers or I/O, and data distribution before and after performance changes. An estimated plan alone is not proof.
5. Validate backups by restoring them into an isolated environment and checking application-visible invariants. Replication without tested restore is not a backup strategy.
6. Review the final migration and schema diff for unintended drops, implicit casts, lock scope, default rewrites, data loss, missing constraints, redundant indexes, unbounded work, and version-specific syntax.
