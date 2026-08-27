# Data modeling

Choose structures from invariants and access patterns. Do not use a database category or schema pattern because it is fashionable.

## Choose the storage model

1. Prefer a relational database when the domain needs cross-entity constraints, joins, flexible queries, atomic multi-row changes, mature transactions, or strong ad hoc reporting.
2. Prefer a document model when a bounded aggregate is normally read and written together, its nested structure is natural, and document growth and duplication remain controlled.
3. Prefer a key-value or native data-structure store when access is primarily by known keys and the required atomic operations, expiration, ordering, or queue behavior map directly to supported primitives.
4. Keep the system on one durable store when it satisfies the requirements. Polyglot persistence adds synchronization, operational, backup, testing, privacy, and incident-response costs.
5. For distributed stores, model partition keys, hotspots, locality, item size, fan-out, consistency, and resharding before implementation. A scalable product does not make every key distribution safe.

## Design schemas and constraints

1. Give every durable entity a stable identifier. Choose types that preserve domain meaning and avoid ambiguous sentinels, implicit timezone assumptions, floating-point money, or undocumented units.
2. Make nullability intentional. Distinguish absent, unknown, empty, zero, and not yet computed only when the domain does.
3. Use foreign keys for relationships the database owns. Define delete and update behavior deliberately rather than relying on driver or ORM defaults.
4. Use unique and check constraints to close race windows that application prechecks cannot close. Keep application validation for user feedback, but let the database remain authoritative.
5. Normalize mutable facts so one change has one authoritative write path. Split tables or collections around stable ownership and lifecycle, not merely to reduce row width.
6. Denormalize only after measuring a costly read pattern. Record the source of truth, all writers, staleness tolerance, transaction or event mechanism, reconciliation job, and repair procedure.
7. For documents, embed when related data shares lifecycle, bounded size, access, and atomic updates. Reference when children grow without bound, change independently, participate in many-to-many relationships, or need independent queries.

## Design indexes from evidence

1. Start with the query, representative parameters, data distribution, and execution plan. Do not add indexes from column names or generic selectivity rules alone.
2. Index predicates, joins, ordering, and uniqueness that matter to measured workloads. Order composite keys according to actual equality, range, and ordering needs for the engine in use.
3. Account for write amplification, storage, cache pressure, vacuum or compaction, build time, replication lag, and planner statistics. An index that is unused or duplicates a prefix has a continuing cost.
4. Use partial, covering, expression, full-text, spatial, or specialized indexes only when the selected engine, operator classes, and query shapes support them.
5. Build or remove indexes with the engine's online or concurrent mechanism when production writes must continue. Verify the lock mode and failure cleanup for the exact version.

## Design queries and pagination

1. Select only required data, bound result sizes, and avoid per-row query patterns. Let the database perform set operations when the plan is efficient and semantics remain clear.
2. Inspect estimated and actual rows, scan and join methods, filters, sorts, memory, temporary storage, buffers or I/O, and planning statistics. Large estimate errors often indicate stale statistics or skewed data.
3. Test plans with production-like cardinality and parameter distributions. A fast plan for an empty development database proves little.
4. Give every paginated result a deterministic total order with a unique tie-breaker. Without one, inserts, deletes, or equal sort values can duplicate or omit rows.
5. Prefer cursor or keyset pagination for large or changing ordered sets. Use offset pagination only when its scan cost and instability are acceptable for the expected depth.
6. Keep page tokens opaque and versioned when they leave the service boundary. Validate filters, tenant, direction, and ordering encoded in the token.

## Protect private and tenant data

1. Store only data needed for a declared purpose. Define retention, archival, deletion, export, and audit behavior before accumulating personal or regulated data.
2. Choose shared rows, shared schemas, separate schemas, shards, or separate databases from isolation, restore granularity, customization, noisy-neighbor, residency, scale, and cost requirements.
3. In shared tables, make tenant identity mandatory in keys, uniqueness rules, queries, jobs, caches, and audit records. Test cross-tenant denial explicitly.
4. Use row-level security only when the engine and operational model support it and tenant identity is reliably propagated. Test privileged roles, owners, maintenance tasks, backups, and policy bypass paths.
5. Encrypt transport and protected data, isolate credentials, and grant each service only the required database, schema, table, row, and operation privileges.
