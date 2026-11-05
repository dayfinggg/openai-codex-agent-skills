---
name: database
description: Inspects and changes SQL schemas, queries, indexes, migrations, ORM data access, and MongoDB documents, queries, indexes, and driver pools. Use when editing SQL, migrations, schemas, indexes, ORM models or queries, or when the user mentions PostgreSQL, MySQL, SQLite schema design, Prisma, EF Core, Doctrine, SQLAlchemy, MongoDB, N+1, slow queries, pagination, or transactions. Redis and HTTP caching belong to caching.
---

1. Identify the requested result and authorized database, schemas, environment, and role. For review-only work, inspect and report without applying changes. A reachable connection or generated command does not authorize execution.
2. Read the affected schema, migration history, query, and callers before editing. Establish engine, ORM, driver, migration-runner, and runtime versions from project metadata and the actual connection when available. Resolve version conflicts before selecting commands. Preserve the existing provider and major version unless their change is requested.
3. Load only the relevant procedures.

- Read [PostgreSQL](references/postgres.md) for schema exploration, SQL semantics, plans, or index decisions.
- Read [Prisma](references/prisma.md) for Prisma setup, commands, generation, or client code. Its command list applies to version 7 only.
- Read [ORM review](references/orm-review.md) for generated SQL, loading, pagination, unit-of-work behavior, or concurrency. Read only the matching provider paragraphs.
- Read [Migrations](references/migrations.md) before authoring or applying schema or data migrations, including ORM-generated migrations.
- Read [PostgreSQL extensions](references/postgres-extensions.md) only for explicitly selected PostGIS, pgvector, TimescaleDB, or hybrid-search work.
- Read [MongoDB](references/mongodb.md) for document design, query meaning, indexes, aggregation, driver lifecycle, or pool diagnosis. The SQL-specific steps below apply to MongoDB by analogy: collections instead of tables, the aggregation plan instead of EXPLAIN, and the driver's emitted commands instead of generated SQL.

4. Define the result contract before changing SQL. Establish row grain, join keys, tenant and soft-delete filters, NULL behavior, ordering, page/count consistency, write invariants, and side effects. Resolve material ambiguity from schema and callers, then ask only for semantics the evidence cannot establish. Keep unresolved assumptions visible until settled.
5. Capture the evidence appropriate to the task. For correctness, use representative expected identities and values. For ORM changes, inspect emitted SQL and round trips. For index changes, inspect physical indexes and the actual plan with representative parameters. A valid plan, generated client, migration success, or matching row count alone does not establish semantic equivalence.
6. Make the smallest change that preserves that contract. Parameterize values and safely quote or allowlist identifiers. Do not repair connection problems with schema resets, suppress translation failures by loading unbounded rows, or replace database constraints with application checks.
7. Verify the changed behavior through the real caller on an authorized fixture or representative copy. Check relevant empty, NULL, duplicate, tied-order, missing-relation, access-isolation, and concurrent-write cases. For a bug, reproduce the failure before the fix when practical. Check rollback and interrupted retry when the change introduces those paths. Do not weaken expected results to match generated SQL.
8. Review the complete final change, including generated SQL and migration artifacts. Report what was changed or found, the checks actually executed, and any remaining execution or rollout requirement. Scope performance claims to measured data, parameters, plans, and environment. Source-only review establishes source findings, not runtime speedups or deployed schema state.

If a check exposes a violated invariant, restate that specific invariant in the working context, correct the change, and rerun the affected check. Do not add unrelated global rules or continue from a failed migration as if it succeeded.
