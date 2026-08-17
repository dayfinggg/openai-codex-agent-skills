---
name: design-sql-database
description: Design and evolve relational databases and SQL workloads. Use for schemas, keys, constraints, queries, indexes, transactions, isolation, locks, migrations, tenancy, permissions, backup, restore, and query performance.
---

# Design SQL Database

## Workflow

1. Identify the database product and version, data ownership, invariants, access patterns, scale, retention, tenancy, and recovery objectives.
2. Model stable entities and relationships. Make keys, nullability, types, defaults, uniqueness, checks, and referential actions explicit so the database protects critical invariants.
3. Write clear parameterized queries. Select only needed columns and make ordering, pagination, and locking behavior explicit.
4. Add indexes for observed access paths, considering selectivity, write cost, storage, and redundant prefixes. Verify with execution plans and representative data.
5. Define transaction boundaries and isolation from business invariants. Account for contention, deadlocks, retries, and idempotency.
6. Migrate through compatible stages such as expand, backfill, switch, validate, and contract. Use product-specific online operations and rehearse rollback or forward repair.
7. Apply least privilege and tenant isolation. Test constraints, queries, concurrency, migration, backup, and restore.

Do not rely on application checks alone for critical relational invariants or claim performance from a query plan without representative conditions.

Read [SQL database practices](references/practices.md) for product documentation and migration guidance.
