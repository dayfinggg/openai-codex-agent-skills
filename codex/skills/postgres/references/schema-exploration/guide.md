# Explore a PostgreSQL database

Start with the user's question, not a full-database audit unless that is the explicit ask. Use the database connection already available to you; if none is available, ask for access or work from provided schema files. Stay within the database and schemas the user has authorized. Catalog metadata can reveal sensitive names or source code: do not export it unnecessarily.

## Workflow

1. Establish the current database, server version, role, and scope. Use [overview](references/overview.md) for a small inventory. Choose relevant schemas; do not assume `public` contains the application.
2. Pick the most promising object(s) and read **only** the matching drill-down reference: [tables](references/tables.md), [partitioning/inheritance](references/partitioning-and-inheritance.md), [foreign tables](references/foreign-tables.md), [views](references/views.md), [routines](references/routines.md), [triggers](references/triggers.md), [security/RLS](references/security.md), or [extensions](references/extensions.md). Follow cross-references only when the question requires them.
3. Corroborate meaning with comments, definitions, keys, and known dependencies. Names are clues, not proof of business meaning. If data-derived values would help, use [data-derived values](references/data-values.md) within existing authorization for the required columns and access method. Ask the user when semantics remain ambiguous.
4. If the user wants SQL, follow [query authoring](references/query-authoring.md): establish join keys and grain, then validate a vetted read-only query with plain `EXPLAIN` where authorized. Do not mistake a valid plan for proof of business semantics.
5. Stop once you can answer. Report the specific schema-qualified objects and evidence, distinguish observations from inferences, and state limitations (permissions, stale statistics, missing dependencies, unknown application logic).

## Example finding

Illustrative only; report facts verified in the target database:

- **Observed:** `sales.orders` has a primary key on `order_id` and a foreign key from `account_id` to `sales.accounts.account_id`.
- **Inferred:** `sales.orders` likely records one row per order; the keys support this, but do not establish what the business calls an “order.”
- **Unresolved:** The catalog does not show whether canceled orders remain in this table. Confirm with the application owner before assuming they do.

## Safety and execution

- Prefer structural catalog queries; `pg_stats` is data-derived and requires task-relevant authorization too. Do not change schema, data, roles, or session-wide settings without authorization. Never call discovered functions or procedures, refresh materialized views, or run `EXPLAIN ANALYZE` on unknown queries. A function marked `STABLE` or `IMMUTABLE` is not a safety guarantee.
- If your client supports transactions, use a read-only transaction and a reasonable statement timeout for exploration. Metadata queries are not a license to run full-table counts or unrestricted scans. Sample only when necessary and already authorized, with explicit limits and a clear understanding of table size and access controls. Ask only when that scope is not established.
- All reference queries are plain PostgreSQL SQL. Bind `$1`, `$2`, etc. as values using your client's API. `psql` users can follow the optional [psql adapter](references/psql.md). **Never interpolate an untrusted object name as raw SQL**; placeholders cannot replace SQL identifiers in data queries.
- Queries target PostgreSQL 18. Each version-sensitive section notes alternatives for older majors where applicable. Check `server_version_num` first. If a query fails due to permissions or version differences, report the limitation instead of guessing.
