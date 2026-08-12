# Database Design Decisions

## Model from ownership and invariants

- Define each record or document's identity, owner, lifecycle, and deletion boundary.
- Start relational designs with normalized facts when independent updates, cross-entity integrity, joins, or flexible querying dominate.
- Embed documents when contained data shares one owner and lifecycle, is usually read together, and fits the database's atomic update boundary.
- Reference separate documents when data has an independent lifecycle, high fan-out, or unbounded growth.
- Duplicate data only with an authoritative source, a propagation rule, and a reconciliation mechanism.
- Keep derived values computable or define exactly when and how they are refreshed.

## Choose keys and constraints

- Use stable primary keys that do not encode mutable business meaning.
- Preserve meaningful candidate keys with uniqueness constraints even when using surrogate identifiers.
- Define nullability, defaults, ranges, state transitions, and uniqueness deliberately; distinguish absent, unknown, and empty values.
- Enforce referential integrity in the database when supported and operationally appropriate. If integrity remains in application code, document the failure mode and repair process.
- Include tenant or ownership boundaries in keys and uniqueness rules when cross-tenant collisions or reads must be impossible.
- Design new constraints so they can be introduced after existing data has been checked or repaired.

## Set transaction and consistency boundaries

- Define the smallest atomic unit that preserves each invariant.
- Select isolation from the anomalies that must be prevented, not from a blanket preference for the strongest level.
- List the records read and written by a critical transaction and evaluate stale reads, lost updates, write skew, phantoms, deadlocks, and retries.
- Use optimistic version checks or compare-and-set for low-contention conflicts that callers can retry.
- Use explicit locking or serialization for high-contention invariants that cannot tolerate concurrent decisions; acquire resources in a stable order.
- Make retried writes idempotent with a durable operation or idempotency key when duplicates would violate correctness.
- In document databases, align invariants with atomic document boundaries where possible. For cross-document invariants, verify transaction support or define a convergent workflow and repair path.
- For eventual consistency, state staleness bounds, conflict resolution, convergence criteria, and which decisions require authoritative reads.

## Derive access paths from queries

- Record each important query's predicates, join or lookup keys, ordering, projection, expected result size, and frequency.
- Design composite indexes around verified predicate and ordering patterns, accounting for prefix behavior and engine-specific rules.
- Avoid speculative indexes. Every index must have an owner query or integrity purpose.
- Evaluate selectivity and skew with representative data; averages can hide hot tenants, keys, or partitions.
- Inspect estimated and actual plans where available. Check row estimates, scan volume, join strategy, sort or spill behavior, and index usage.
- Measure the read benefit against write amplification, storage, cache pressure, replication cost, and maintenance time.
- Reassess indexes after workload changes and remove redundant ones only after observing their real use and rollback options.

## Address scale and distribution

- Add partitioning or sharding only for a demonstrated capacity, locality, retention, or operational need.
- Choose keys that distribute load while preserving required locality; test monotonic keys, popular tenants, and time-based hotspots.
- Define cross-partition transaction, uniqueness, and query behavior before committing to a distribution scheme.
- Include growth estimates and thresholds that would trigger a redesign instead of optimizing for hypothetical scale.
