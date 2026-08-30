# PostgreSQL quality standard

Use this review baseline for PostgreSQL schemas, queries, migrations, and operations.
Pin the deployed PostgreSQL major version in CI and verify version-sensitive behavior against it.
Treat DDL, roles, extensions, indexes, and maintenance settings as versioned code.
Prefer production-shaped data and measured plans over rules of thumb.

## Types

Choose a type that expresses the domain and has enough range for the expected lifetime of the data.
Use `integer` for ordinary bounded counts and `bigint` when the range may exceed 32 bits or IDs cross database boundaries.
Use `numeric(precision, scale)` for exact monetary or decimal quantities.
Use floating-point types only when approximation is part of the domain contract.
Specify numeric precision and scale when rounding and bounds must be explicit.
Use `text` unless a length limit is a business invariant; `varchar(n)` provides no performance advantage over `text`.
Avoid `char(n)` for normal strings because blank padding adds storage and can make it slower.
Use `timestamptz` for an instant; PostgreSQL stores it in UTC and renders it in the session time zone.
Use `timestamp without time zone` only when the value is intentionally a wall-clock value without an instant.
Store the relevant zone separately when a future local-time reconstruction is required.
Avoid `time with time zone` unless legacy interoperability requires it.
Use `uuid` when identifiers must be globally unique across independent writers.
PostgreSQL 18 provides native UUIDv4 and UUIDv7 generation, but a `uuid` column still needs a `PRIMARY KEY` or `UNIQUE` constraint.
Prefer identity columns over legacy `serial` for new generated keys, and choose `ALWAYS` or `BY DEFAULT` deliberately.
Identity generation does not guarantee uniqueness because sequences can be reset or explicit values can be supplied.
Use domains for reusable scalar invariants and range types for intervals with containment or overlap semantics.
Use an enum only when values are stable and removal is not part of the lifecycle; use a lookup table when values need metadata or flexible changes.

## Constraints

Put integrity rules in the database so every writer receives the same protection.
Mark required columns `NOT NULL`; PostgreSQL checks it more directly than an equivalent check constraint.
Remember that a `CHECK` expression passes when it returns `TRUE` or `NULL`; pair it with `NOT NULL` when null is invalid.
Keep `CHECK` constraints row-local and based on stable functions.
Do not make a `CHECK` depend on other table rows or mutable function behavior because dump and restore consistency can fail.
Use a primary key for stable row identity and unique constraints for alternate keys.
On PostgreSQL 15 and later, use `UNIQUE NULLS NOT DISTINCT` when null values must collide. On older supported releases, use a carefully tested expression or partial-index design. Ordinary unique constraints treat nulls as distinct.
Use foreign keys for referential integrity and choose `ON DELETE` and `ON UPDATE` actions explicitly.
Index referencing foreign-key columns when joins or parent updates and deletes must find children quickly.
PostgreSQL does not automatically create the child-side foreign-key index.
Use `EXCLUDE USING gist` for invariants such as non-overlapping reservations or ranges.
Name constraints predictably so migrations, diagnostics, and incident fixes can address them safely.

## Indexes

Create indexes for measured predicates, joins, and orderings rather than indexing every column.
Every index consumes storage and adds work to inserts, updates, deletes, vacuum, and backups.
Use B-tree by default for equality, ranges, anchored prefix patterns with the right collation or operator class, and ordered scans.
Use hash only for simple equality, and select GiST, SP-GiST, GIN, or BRIN from the operator class and data shape.
Use GIN for values with multiple searchable components such as arrays or JSONB.
Use BRIN when column values correlate with the table's physical block order.
Order multicolumn B-tree keys with leading equality predicates before range or ordering predicates.
Use partial indexes only for stable selective predicates that the planner can recognize in the query.
Do not use a collection of partial indexes as a substitute for declarative partitioning.
Use expression indexes when the query applies the same transformation, and keep every function and operator immutable.
Remember that expression indexes trade faster reads for extra computation on writes.
Use `INCLUDE` payload columns sparingly because wide payloads bloat indexes and can make inserts fail at the index size limit.
Expect index-only scans to win mainly when the visibility map marks many heap pages all-visible.
Create indexes on live large tables with `CREATE INDEX CONCURRENTLY` when the extra scans and I/O are acceptable.
Concurrent builds keep writers running but take longer, cannot run inside a transaction block, and can leave an invalid index after failure.
Drop an invalid failed concurrent index before retrying, or use the documented concurrent rebuild path.
Inspect `pg_stat_user_indexes` and query plans before removing an index; low `idx_scan` alone is not proof that it is unused.

## EXPLAIN

Use `EXPLAIN` to inspect the planner's chosen plan before changing SQL or adding an index.
Run `EXPLAIN (ANALYZE, BUFFERS)` on representative data to compare estimated and actual rows and I/O.
Treat large row-estimate errors as a statistics, correlation, predicate, or data-distribution problem to investigate.
Read node times together with `loops`; per-loop values must be multiplied to understand total work.
Treat planner costs as arbitrary units rather than milliseconds.
Remember that `EXPLAIN ANALYZE` executes the statement and triggers its side effects.
Wrap data-modifying analysis in a transaction and roll it back when a safe rehearsal is possible.
Do not extrapolate a plan from a toy table to production scale, and record relevant planner settings with the plan.

## Transactions and locking

Keep transactions short and contain only the atomic state change that must commit together.
Never hold a transaction open while waiting on a user, network call, queue, or unrelated batch.
Read Committed is the default; each statement gets a snapshot, so successive statements can see different committed data.
Use Repeatable Read or Serializable only when the invariant requires it and retry the whole transaction on serialization failure.
Use row locks deliberately; they block writers and lockers of the same row but do not block ordinary readers.
Acquire locks on multiple objects in a consistent order to prevent deadlocks.
Treat a deadlock error as a failed transaction and retry the transaction after rollback.
Use `pg_locks` with `pg_stat_activity` to identify blockers, waiters, and long-running transactions.
Use `lock_timeout` to fail fast on DDL or lock acquisition, and use `statement_timeout` to cap execution time.
Set those timeouts per role, session, or migration rather than globally when different workloads need different budgets.
Use `idle_in_transaction_session_timeout` where appropriate because idle transactions retain locks and delay removal of dead tuples.
Do not assume an index or foreign key is lock-free; inspect the command's documented lock level before production use.

## JSONB

Use `jsonb` for queryable JSON documents; use `json` only when preserving the exact input text matters.
`jsonb` validates JSON and stores a decomposed binary representation that avoids reparsing on every read.
Keep JSONB structure predictable, and promote stable, frequently filtered, or strongly constrained fields to typed columns.
Use a `CHECK` constraint or a vetted validation function for essential document shape and business rules.
Remember that SQL `NULL` and JSON `null` are different values.
Keep JSONB documents manageable because updating any field locks the whole containing row.
Use the default GIN operator class for key existence, containment, and JSONPath operators when those are the query operators.
Use `jsonb_path_ops` only when its narrower operator set matches the workload and its measured trade-offs are favorable.
Write predicates against the indexed expression; for example, `doc -> 'tags' ? 'x'` may need an expression index rather than a plain `doc` GIN index.
Treat JSONB as a flexible boundary, not as permission to omit data ownership, constraints, or migration plans.

## Extensions

Prefer a PostgreSQL extension over a pile of untracked functions, types, operators, and index support objects.
Install only extensions that have been reviewed for source, privileges, maintenance, and upgrade compatibility.
Use `CREATE EXTENSION ... SCHEMA ...` with a dedicated schema where the extension supports relocation.
Do not grant untrusted users `CREATE` on an extension's installation schema.
Treat a superuser extension installation script as executable privileged code and inspect it before installation.
Do not mark an extension trusted merely to simplify deployment; trusted scripts require stronger security review.
Keep extension member changes in versioned update scripts and apply them with `ALTER EXTENSION UPDATE`.
Do not patch an extension member only in the live database because `pg_dump` will not preserve an untracked definition change.
Schema-qualify extension references and use a secure `search_path` in privileged functions and scripts.
Use `SET search_path = trusted_schema, pg_temp` for `SECURITY DEFINER` functions, then revoke default `PUBLIC` execute when access must be restricted.

## Migrations

Use an expand, migrate, and contract sequence when old and new application versions must overlap during deployment. For a simple offline or atomic migration with no mixed-version window, use the smallest safe transaction and verification plan instead.
Review the lock level of every `ALTER TABLE`; unless documented otherwise, it acquires `ACCESS EXCLUSIVE`, and a combined statement takes the strictest required lock.
On current supported releases, a non-volatile default when adding a column is stored in metadata without rewriting existing rows.
Treat volatile defaults, stored generated columns, identity columns, constrained domains, and most type changes as potential table rewrites.
Add foreign-key and check constraints as `NOT VALID` when a large-table scan must be separated from enforcement. PostgreSQL 18 and later also support `NOT VALID` for `NOT NULL`. On older releases, add and validate an equivalent check before `SET NOT NULL`.
Validate later with `VALIDATE CONSTRAINT`; new writes are protected while existing rows are checked under a less restrictive lock.
Use a validated nullability check to let `SET NOT NULL` skip a redundant full-table scan where the release supports that optimization.
Build a unique index concurrently first, then attach it as a unique or primary-key constraint with `USING INDEX` when the index qualifies.
Run `CREATE INDEX CONCURRENTLY` outside the migration transaction and plan cleanup for an invalid index after failure.
For partitioned tables, build child indexes concurrently and attach them to a parent index because concurrent parent builds are unsupported.
Backfill in small committed batches, throttle when necessary, and make each batch restartable and observable.
Use per-migration lock and statement timeouts so a waiting deployment fails instead of queueing application traffic.
Use a dedicated migration role that can alter schema without granting those powers to the application role.
For large or live migrations, test duration, lock waits, rewrite space, replica impact, and rollback or forward-fix procedures on production-scale data. For small offline migrations, verify the transaction, resulting schema and data, and recovery path in proportion to risk.
The reviewed `strong_migrations` GitHub examples illustrate concurrent indexes, batched throttled backfills, lock timeouts, and a separate migration user.

## Partitioning

Partition only when data volume, access locality, or retention operations justify the added hierarchy.
Choose range, list, or hash partitioning from query predicates, data distribution, and lifecycle operations.
Choose a partition key that common `WHERE` clauses can use for pruning and that matches the unit of data you remove together.
Define non-overlapping bounds and create the next partition before inserts need it, or provide a deliberate default partition policy.
Partition pruning uses partition bounds rather than indexes, so keep pruning enabled and verify it in `EXPLAIN`.
Do not create more partitions than the workload can prune; planning time and per-session metadata memory grow when many remain relevant.
Remember that a partitioned parent stores no tuples and that parent indexes and unique constraints are virtual child structures.
Design global uniqueness early because a partitioned primary key or unique constraint must include every partition-key column.
Use `DROP` or `DETACH PARTITION` for bulk retention work instead of row-by-row deletes when the lifecycle allows it.
Use a matching `CHECK` constraint before `ATTACH PARTITION` to avoid a validation scan under a stronger lock.
Run manual `ANALYZE` on the partitioned parent after initial population and when partition distributions change materially.
Rehearse partition creation, attachment, detachment, default-partition behavior, and out-of-range inserts before production rollout.

## Vacuum and statistics

Keep autovacuum enabled unless a documented exception has a compensating maintenance plan.
Vacuum reclaims dead-tuple space for reuse, updates planner statistics, maintains the visibility map, and prevents transaction-ID wraparound.
Use ordinary `VACUUM` for routine concurrent maintenance; reserve `VACUUM FULL` for planned rewrites because it takes `ACCESS EXCLUSIVE` and extra disk space.
Use `VACUUM (ANALYZE)` after bulk loads or major distribution changes when the normal schedule is too slow.
Tune autovacuum thresholds and scale factors per high-churn table instead of disabling the daemon globally.
Monitor `n_dead_tup`, `n_mod_since_analyze`, last vacuum and analyze times, freeze age, and autovacuum duration.
Watch for long or idle transactions because they can prevent vacuum from removing row versions visible to their snapshots.
Remember that autovacuum processes partitions but does not analyze the partitioned parent; schedule parent `ANALYZE` explicitly.
Use higher per-column statistics targets only for skewed, high-value predicates that need better estimates.
Use `CREATE STATISTICS` for correlated columns, functional dependencies, most-common combinations, or expressions.
Re-run `ANALYZE` after creating expression indexes, extended statistics, or bulk data changes.
Treat anti-wraparound vacuum warnings as an operational incident, not as an ordinary performance symptom.

## Connection handling

Size connection pools from measured concurrency and memory, and keep the aggregate active sessions below `max_connections`.
Do not raise `max_connections` as a substitute for pooling or query latency control because PostgreSQL allocates more shared resources as it rises.
Reserve emergency connection capacity for administrators and monitoring.
Use a pool that resets session state, rolls back failed transactions, and discards broken connections before reuse.
Never return a connection to the pool while it is inside a transaction or has session-local settings that the next request can inherit.
Set application-appropriate statement, lock, transaction, and idle-in-transaction timeouts.
Use `pg_stat_activity` with an application name to monitor active, idle, waiting, and long-running sessions.
Restrict `listen_addresses` to required interfaces and use network policy in addition to database authentication.
Configure TCP keepalives or connection checks when failure detection must be bounded by an operational requirement.

## Security

Use separate non-login owner, application, migration, read-only, and operational roles where their capabilities differ.
Never use a superuser for application traffic, and avoid `CREATEROLE`, `CREATEDB`, `REPLICATION`, `BYPASSRLS`, and `ALTER SYSTEM` unless required.
Grant only the table, column, sequence, schema, function, and database privileges each role needs.
Audit default privileges and revoke accidental `PUBLIC` access, especially `CREATE` on `public` in upgraded clusters.
Treat `search_path` as a security boundary; remove schemas writable by untrusted users or schema-qualify sensitive references.
Remember that `pg_hba.conf` uses the first matching record and has no fall-through after an authentication failure.
Prefer `hostssl` rules with certificate validation or SCRAM-SHA-256 for remote password authentication.
Avoid clear-text `password` authentication unless the connection is protected by TLS and policy requires it.
Enable TLS, protect the server key, and use a CA-signed certificate in production.
Enable row-level security only with explicit `USING` and `WITH CHECK` policies for every required command.
Test RLS as table owner, ordinary role, superuser-equivalent role, and through backup or reporting paths because owners and bypass roles normally bypass RLS.
Remember that RLS does not replace table privileges and that referential-integrity checks can bypass RLS.
Treat `SECURITY DEFINER` functions as privileged entry points, lock their `search_path`, and restrict their execute privilege.
Review extension scripts, casts, triggers, and foreign-key privileges as code-execution surfaces.

## Operationally safe schema design

Make ownership, naming, comments, retention, and data classification explicit in the schema.
Use explicit schemas and qualify objects in DDL, security-sensitive code, and migration scripts.
Keep stable relational attributes typed and constrained, and isolate flexible or externally owned payloads behind clear boundaries.
Choose key types, collations, and partition keys with future volume, replication, sharding, and retention in mind.
Treat collation as part of the schema contract; provider or locale changes can alter ordering and equality behavior used by indexes.
Prefer stable `C` or built-in collations where bytewise ordering is acceptable, and use natural-language collations only where they are needed.
Keep rows and frequently updated documents bounded enough to avoid unnecessary lock contention and write amplification.
Avoid accidental table rewrites, unbounded JSONB growth, unbounded indexes, and unbounded transaction duration.
Record an owner and a purpose for every non-obvious index, constraint, extension, trigger, and scheduled maintenance action.
Back up and restore-test schema, extension files, roles, privileges, and collation assumptions before declaring a design production-ready.

## Sources

### Official PostgreSQL documentation

Official types: [numeric](https://www.postgresql.org/docs/current/datatype-numeric.html), [character](https://www.postgresql.org/docs/current/datatype-character.html), [date/time](https://www.postgresql.org/docs/current/datatype-datetime.html), [UUID](https://www.postgresql.org/docs/current/datatype-uuid.html), [identity](https://www.postgresql.org/docs/current/ddl-identity-columns.html), [domains](https://www.postgresql.org/docs/current/domains.html), and [ranges](https://www.postgresql.org/docs/current/rangetypes.html).
Official integrity: [constraints](https://www.postgresql.org/docs/current/ddl-constraints.html) and [ALTER TABLE](https://www.postgresql.org/docs/current/sql-altertable.html).
Official indexes: [index types](https://www.postgresql.org/docs/current/indexes-types.html), [CREATE INDEX](https://www.postgresql.org/docs/current/sql-createindex.html), [multicolumn indexes](https://www.postgresql.org/docs/current/indexes-multicolumn.html), [partial indexes](https://www.postgresql.org/docs/current/indexes-partial.html), [expression indexes](https://www.postgresql.org/docs/current/indexes-expressional.html), and [index-only scans](https://www.postgresql.org/docs/current/indexes-index-only-scans.html).
Official plans and concurrency: [EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html), [transaction isolation](https://www.postgresql.org/docs/current/transaction-iso.html), [explicit locking](https://www.postgresql.org/docs/current/explicit-locking.html), and [viewing locks](https://www.postgresql.org/docs/current/monitoring-locks.html).
Official JSONB: [JSON types](https://www.postgresql.org/docs/current/datatype-json.html).
Official extensions: [CREATE EXTENSION](https://www.postgresql.org/docs/current/sql-createextension.html) and [extension packaging and security](https://www.postgresql.org/docs/current/extend-extensions.html).
Official partitioning: [table partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html).
Official maintenance: [routine vacuuming](https://www.postgresql.org/docs/current/routine-vacuuming.html), [VACUUM](https://www.postgresql.org/docs/current/sql-vacuum.html), [ANALYZE](https://www.postgresql.org/docs/current/sql-analyze.html), [planner statistics](https://www.postgresql.org/docs/current/planner-stats.html), [CREATE STATISTICS](https://www.postgresql.org/docs/current/sql-createstatistics.html), and [vacuum configuration](https://www.postgresql.org/docs/current/runtime-config-vacuum.html).
Official connections: [connection settings](https://www.postgresql.org/docs/current/runtime-config-connection.html), [client timeouts](https://www.postgresql.org/docs/current/runtime-config-client.html), and [client authentication](https://www.postgresql.org/docs/current/client-authentication.html).
Official security: [pg_hba.conf](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html), [password authentication](https://www.postgresql.org/docs/current/auth-password.html), [TLS](https://www.postgresql.org/docs/current/ssl-tcp.html), [role attributes](https://www.postgresql.org/docs/current/role-attributes.html), [privileges](https://www.postgresql.org/docs/current/ddl-priv.html), [schemas and search_path](https://www.postgresql.org/docs/current/ddl-schemas.html), [RLS](https://www.postgresql.org/docs/current/ddl-rowsecurity.html), and [secure functions](https://www.postgresql.org/docs/current/sql-createfunction.html).
Official localization: [collation support](https://www.postgresql.org/docs/current/collation.html).
### Maintainer guidance

Maintainer guidance: Laurenz Albe's [foreign-key indexing analysis](https://www.cybertec-postgresql.com/en/index-your-foreign-key/), [enum versus lookup analysis](https://www.cybertec-postgresql.com/en/lookup-table-or-enum-type/), and [collation guidance](https://www.cybertec-postgresql.com/en/c-collation-best-for-postgresql-clusters/).
### Verified examples

Verified GitHub examples: the [ankane/strong_migrations README](https://github.com/ankane/strong_migrations) documents concurrent indexes, batched backfills, lock timeouts, and separate migration permissions.
### Practitioner talk

Traceable talk: Chris Ellis's POSETTE talk [Even JSONB In Postgres Needs Schemas](https://learn.microsoft.com/en-us/shows/posette-an-event-for-postgres-2024/even-jsonb-in-postgres-needs-schemas) demonstrates JSONB shape and CHECK-constraint considerations.
