---
name: working-with-databases
description: Design or change schemas, SQL queries, migrations, indexes or ORM data access. Covers transactions and persistence compatibility for the affected database.
---

# Working with databases

Inspect the database, ORM versions, schema conventions and affected callers. Read [orms.md](orms.md) for the ORM actually used. Confirm version-specific features before applying them.

Use constraints for real integrity rules, explicit foreign-key behavior and appropriate types for money, instants and calendar values. Preserve existing key and timestamp contracts. Identity or UUID defaults, SQLite STRICT tables and WAL are choices for the workload and version, not a reason to migrate every existing schema.

Parameterize values and allowlist dynamic identifiers. Select the data required by the caller, avoid queries per row, and bound or paginate growing result sets. Use deterministic ordering with a unique tie-breaker. Cursor values and comparisons must match that ordering. Choose cursor or offset pagination from the actual compatibility contract.

Keep related writes atomic. Keep transactions short and avoid external waits while holding locks. Use conditional writes, consistent lock ordering or an appropriate lock when concurrent writers require it. Retry only transient transaction failures with a bounded policy and safe replay semantics.

Use the existing connection lifecycle. Pool where the driver and runtime support it, accounting for limits across processes. Check pooler compatibility before relying on session state, advisory locks or prepared statements.

Justify indexes with the workload and a query plan. Composite indexes and planner behavior depend on the engine, so do not assume a universal left-prefix rule. EXPLAIN ANALYZE executes statements, and rollback does not make every side effect harmless.

Review generated migrations and do not rewrite migrations already applied elsewhere. For rolling deployments, use compatible add, backfill, switch and remove steps when coexistence is needed. For large tables, plan locks and engine-specific online operations. Preparing a migration does not authorize running it on production data.
