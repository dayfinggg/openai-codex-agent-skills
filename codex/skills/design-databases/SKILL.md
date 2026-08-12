---
name: design-databases
description: Design relational or document schemas, constraints, transactions, indexes, and migrations from verified workloads and invariants. Use for database changes; exclude API contracts, pipelines, and broad codebase migrations.
---

# Design Databases

## Establish the evidence

Inspect the existing schema, migrations, queries, repository conventions, and operational data before proposing a design. Identify the database engine and version before relying on engine-specific syntax, locking behavior, index features, or consistency guarantees. Separate observed facts, requirements, assumptions, and unresolved questions; do not invent workloads or guarantees.

Describe the workload in terms of read and write operations, cardinality, growth, latency targets, contention, tenancy, retention, and failure behavior. Express each hard invariant as a condition that must remain true under concurrency and retries. Prefer database-enforced integrity when the database can express the invariant without unacceptable operational cost.

## Design the data model

Read [design-decisions.md](references/design-decisions.md) when selecting relational versus document structure, identity, constraints, transaction boundaries, consistency, concurrency control, partitioning, or indexes.

Design from access patterns and invariants rather than object shapes alone. Name the authoritative copy of duplicated data and define how divergence is detected and repaired. Keep engine-specific choices explicit and justified by verified capabilities.

For every proposed index, identify the query shape it serves and the expected tradeoff in write cost, storage, and maintenance. Confirm decisions with representative plans and measurements when the system or data is available; do not infer production performance from schema shape alone.

## Plan safe changes

Read [change-safety.md](references/change-safety.md) before changing a production schema, rewriting data, tightening constraints, backfilling rows or documents, applying retention, or removing data.

Preserve compatibility across all application versions that may run during rollout. Separate schema expansion, data movement, verification, and contraction when an atomic change would lock, rewrite, or invalidate live traffic. Make retry behavior, checkpoints, throttling, observability, abort conditions, and rollback or forward-fix strategy concrete before execution.

Treat destructive changes as irreversible unless restore and replay have been demonstrated. Distinguish rolling back application code from restoring transformed or deleted data.

## Verify the result

Validate the design against each invariant and critical operation, including concurrent and failure cases. Test migrations and backfills on production-like volume when practical. Compare representative query plans, latency, resource use, lock duration, replication effects, and write amplification before and after the change.

Report the resulting schema or document shape, enforced invariants, transaction and consistency model, access paths, rollout sequence, verification gates, and recovery path. State remaining uncertainty and the evidence needed to resolve it.
