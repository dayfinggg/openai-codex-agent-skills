# SQL and relational database quality reference

Use this reference for relational schemas, SQL statements, and database changes.
Treat it as a portable baseline, then follow the target engine, version, and repository rules.
Prefer constraints, explicit semantics, and measured plans over folklore or cargo-cult tuning.
## Authority and portability

- Treat SQL standard core features as the portability baseline, not as a promise that every engine behaves identically.
- Basic `SELECT`, DML, integrity constraints, and transaction control are standard features; vendor syntax extends that core.
- Index definition syntax is not part of the SQL standard, so isolate index DDL by engine when necessary.
- Record the supported engine and version beside every dialect-specific query or migration.
- Keep schema definitions, migrations, queries, and representative fixtures under version control.
- Prefer standard types and predicates when they express the requirement clearly.
- Put engine-specific types, hints, generated syntax, and index options behind a documented dialect boundary.
- Engine differences in null uniqueness, transaction isolation, composite-index access, DDL atomicity, and online schema changes belong in the target vendor reference and versioned tests.
- Run integration tests against every engine that production supports; a parser or ORM abstraction is not proof of portability.
## Relational schema and normalization

- State the grain of every table and result, such as “one row per order item.”
- Store one fact in one column and one row at the table’s declared grain.
- Split subject-based facts into related tables instead of repeating a customer, product, or address on every transaction row.
- First normal form removes repeating groups and multi-valued fields from ordinary relational columns.
- Second normal form requires every non-key fact to depend on the whole key, which matters most for composite keys.
- Third normal form removes facts that depend on another non-key fact rather than directly on the row key.
- A many-to-many relationship normally becomes a junction table with two foreign keys.
- Make the junction key match the relationship grain, often with a composite primary key or an explicit relationship identifier plus a unique constraint.
- Normalize first to protect update, insert, and delete integrity.
- Denormalize only for a measured access pattern, and document the duplicated fact, owner, refresh path, and consistency guarantee.
- A materialized summary is a cache or projection, not a second undocumented source of truth.
- Do not persist a value that can be safely derived unless its snapshot meaning or performance purpose is explicit.
- If a derived value is persisted, define who recomputes it and test stale-value behavior.
- Avoid generic entity tables that discard domain types, keys, and constraints merely to reduce table count.
- Model optional, repeating, and historical facts as separate relations when their lifecycles differ.
- Prototype the design with sample rows and the queries the application must answer.
## Keys, constraints, and nullability

- Give each durable table a primary key that uniquely identifies a row.
- Prefer a stable, immutable identifier; a mutable business attribute makes every reference and cache harder to maintain.
- A surrogate key does not replace a business invariant; keep alternate natural identifiers as named unique constraints.
- Use a composite key when the combination expresses the table’s true grain, especially for junction tables.
- A foreign key must reference a primary key or other unique key with compatible types and semantics.
- Name primary, foreign-key, unique, and check constraints deterministically, such as `pk_orders`, `fk_order_items_order`, and `uq_users_email`.
- Use `NOT NULL` for values required by the domain, rather than relying on application validation.
- Make a column nullable only when “unknown,” “not applicable,” or “not yet known” has a distinct business meaning.
- `NULL` is not an empty string, zero, or a default sentinel.
- SQL uses three-valued logic; an ordinary comparison involving `NULL` can evaluate to unknown.
- Test for absence with `IS NULL` or `IS NOT NULL`, never with `= NULL` or `<> NULL`.
- Review `NOT IN` predicates when the subquery can return null; use an explicit null policy or `NOT EXISTS`.
- A `CHECK` should express a row-level invariant, such as `amount >= 0`.
- Do not rely on a `CHECK` alone to reject `NULL`; pair it with `NOT NULL` when absence is invalid.
- Do not use a row `CHECK` to enforce a cross-table invariant; use a foreign key, unique or exclusion constraint, or a deliberate trigger.
- Declare the intended `ON DELETE` and `ON UPDATE` behavior instead of allowing accidental cascades.
- Use `CASCADE` only when the child has no independent lifecycle; prefer explicit deletion for independent business objects.
- Add an index to foreign-key columns when joins, parent deletes, or parent-key updates need fast child lookup.
- Do not assume every engine creates that child-side index automatically.
- Unique constraints enforce business identity, but null treatment differs between engines; test the intended behavior explicitly.
- Choose numeric precision, temporal precision, collation, and character semantics for the domain rather than using a convenient default.
- Treat defaults as database policy and test inserts that omit the column.
- Test every constraint with valid data, boundary data, null data, duplicate data, and invalid data.
## Naming and SQL clarity

- Choose one identifier convention and apply it consistently; lowercase `snake_case` is a common portable choice, not a SQL requirement.
- Avoid reserved words, ambiguous abbreviations, and quoted mixed-case identifiers.
- Case folding, quoting, and reserved-word rules differ across engines; avoid quoted mixed-case names when portability matters.
- Use names that reveal the domain and unit, such as `amount_cents`, `started_at`, or `retry_count`.
- Use consistent suffixes for identifiers and timestamps, such as `_id`, `_at`, and `_date`.
- Keep table and column naming singular or plural according to the repository convention, not personal preference.
- Name indexes with their table and purpose, such as `ix_orders_customer_created_at`.
- Select explicit columns at stable interfaces; do not expose `SELECT *` from APIs, views, or long-lived reports.
- Put one selected expression per line and keep a stable column order so diffs remain reviewable.
- Qualify columns with short, descriptive aliases whenever more than one table is present.
- Use comments to explain a business rule, invariant, or non-obvious optimizer tradeoff, not to narrate syntax.
- Format SQL with an agreed formatter and linter; configure the target dialect rather than linting everything as ANSI.
- SQLFluff is a concrete cross-dialect linting example; run `sqlfluff lint query.sql --dialect ansi` or the project’s dialect.
- Bind values through parameters or prepared statements; never concatenate untrusted values into SQL text.
- Allow-list dynamic identifiers and sort directions because ordinary bind parameters cannot represent identifiers.
- Give each statement one purpose and make its input, output grain, and side effects easy to state.
- Use a CTE to name a meaningful relational step, not to hide a trivial expression behind extra indirection.
## Queries and joins

- Write the expected result grain before reviewing a query that joins multiple relations.
- Use explicit `JOIN ... ON` syntax; an unqualified comma in `FROM` creates a Cartesian product.
- Use `CROSS JOIN` only when every pair is intentional and the row multiplication is bounded.
- Qualify every join column and verify the data types and collations on both sides.
- Choose `INNER JOIN` when an unmatched row should disappear and `LEFT JOIN` when the left row must remain.
- A `LEFT JOIN` produces nulls for missing right rows, so a right-table filter in `WHERE` can turn it into an inner join.
- Put predicates in `ON` when they define which right rows match, and put result filters in `WHERE` when unmatched rows should be removed.
- Avoid `NATURAL JOIN`; a future same-named column can silently change its join condition.
- Use `USING` only when same-named columns are intentionally the complete join key.
- Check one-to-one, one-to-many, and many-to-many cardinality assumptions with fixtures before adding `DISTINCT`.
- Do not use `DISTINCT` as a bandage for an unintended join; fix the key or relationship that multiplied rows.
- Aggregate the many side before joining when the result needs one row per parent.
- Prefer set-based operations and batch predicates over a loop that submits one statement per row.
- Select only the columns needed by the caller, especially across a network boundary.
- Make precedence visible with parentheses around mixed `AND` and `OR` conditions.
- Make ordering explicit whenever callers depend on row order.
- Keep predicates indexable where practical; use an expression or generated-column index only after measuring the workload.
- Inspect the target plan with `EXPLAIN` and, where safe, actual execution metrics on representative data.
- Compare estimated and actual rows, join order, scans, sort or spill work, and memory before changing SQL.
## Transactions and isolation

- Put a business operation that must be atomic inside one transaction and commit only after all required statements succeed.
- Roll back on failure and release the connection without leaving it idle in a transaction.
- Keep transactions short; do not hold locks while waiting on network calls, user input, or unrelated work.
- Set isolation deliberately when correctness depends on repeatable reads, predicate consistency, or serial execution.
- Transaction defaults, snapshots, locking, phantoms, and retry errors differ by engine and version; consult the target vendor reference and test the exact behavior.
- Isolation-level names describe minimum phenomena, but implementations can differ in how they achieve those guarantees.
- Use `SERIALIZABLE` for a proven invariant that requires it, and retry serialization failures as a complete transaction.
- Handle deadlocks with bounded retries and consistent lock ordering; never retry a non-idempotent side effect blindly.
- Lock the smallest set of rows that protects the invariant, and document `FOR UPDATE` or engine-specific hints.
- Use savepoints for a deliberate partial rollback, not as a substitute for a clear transaction boundary.
- Know whether the client runs in autocommit mode and make that behavior visible in tests.
- Treat DDL as a separate portability concern because transactional behavior differs across engines.
## Indexes and execution plans

- Add indexes for observed lookup, join, uniqueness, ordering, or range workloads, not for every column.
- An index can accelerate reads but adds storage, write, vacuum or maintenance, and planning overhead.
- Primary and unique constraints commonly create supporting indexes, but verify the target engine before adding duplicates.
- Index foreign-key columns used to find children during joins, deletes, or parent-key changes.
- Design a composite index from actual predicates and ordering; column order and skip-scan behavior are engine-specific.
- Verify composite-index access with the target vendor reference and `EXPLAIN`; do not infer later-column behavior from another engine.
- Consider a covering index only when its extra width pays for fewer table lookups on a measured hot query.
- Partial, expression, included-column, and filtered indexes are useful extensions but require dialect-specific migrations.
- Remove duplicate and unused indexes after observing production workload and write cost.
- Use `EXPLAIN` to understand a plan; use `EXPLAIN ANALYZE` carefully because it executes the statement.
- Test plans with realistic data distributions, parameter values, statistics, and concurrency.
- A sequential scan can be correct for a small or low-selectivity table; do not force an index without evidence.
- Online index builds, lock modes, and transactional DDL are engine-specific; use the target vendor’s documented migration path.
## Pagination and N+1 queries

- Use a unique, deterministic `ORDER BY`, including a stable tie-breaker, for every page boundary.
- `LIMIT` and `OFFSET` are adequate for shallow pages, administrative screens, or small stable result sets.
- Large offsets still require the server to compute and discard skipped rows, and concurrent inserts can make pages drift.
- Prefer keyset or seek pagination for deep pages and feeds: filter on the last seen ordered key and fetch the next bounded batch.
- For a compound order, carry the complete cursor, apply the matching tuple or lexicographic predicate, and keep the cursor opaque to clients.
- Keyset pagination is faster and more stable for sequential navigation, but it does not directly jump to arbitrary page numbers.
- Define whether a feed uses a live view, a transaction snapshot, or a fixed cutoff timestamp.
- An N+1 pattern issues one parent query and then one related query per returned row.
- Replace N+1 with a join, an `IN` batch, a set-based aggregate, or deliberate eager loading.
- Choose the shape that preserves the requested grain; one huge join can multiply rows and cost more than two bounded batches.
- Detect N+1 with query logs, per-request query counts, tracing, and regression tests with more than one parent row.
- The PyCon talk in Sources demonstrates identifying N+1 and using aggregation or lateral joins in ORM-backed applications.
## Migrations and schema evolution

- Treat an applied migration as immutable history; add a new migration instead of editing an old one.
- Give each migration a clear forward purpose, preconditions, postconditions, and operational notes.
- Prefer expand, migrate, and contract for live systems that may run old and new application versions together.
- Expand additively, deploy code that reads or writes the new shape, backfill in bounded batches, then contract after old readers are gone.
- Make dual writes temporary, observable, and reconciled before switching the source of truth.
- Backfill by stable key ranges or batches, with progress, throttling, restart safety, and a repair path.
- Add a new nullable column before making it required; validate existing rows before adding `NOT NULL`.
- Deploy a new index separately when its build duration or lock behavior could affect application traffic.
- DDL atomicity, transactional behavior, locking, and `ALTER TABLE` capabilities differ by engine and version; consult vendor references before choosing a migration shape.
- Keep dialect-specific DDL isolated in migration files and test it on the exact production engine and version.
- Test lock duration, table size, replica lag, disk headroom, and failure recovery on production-like data.
- Run migrations in CI from a clean schema and from representative prior versions.
- Verify row counts, null counts, uniqueness, foreign keys, and old-versus-new query results before removing the old shape.
- Keep irreversible data deletion in a separately reviewed step with backups or a verified archive.
## Testing and maintainable SQL sizing

- Test observable results and invariants, not just whether a SQL string parses.
- Include fixtures for empty sets, nulls, duplicates, boundary dates, large values, and each relationship cardinality.
- Test constraint failures, cascade or restrict behavior, transaction rollback, and concurrent conflict handling.
- Test pagination across inserts, duplicate sort values, the first page, the end page, and an invalid cursor.
- Test every migration on a clean schema and an upgraded schema containing realistic data.
- Assert row grain and expected counts so an accidental many-side multiplication fails loudly.
- Run integration tests against the actual engine and version used in production.
- Keep plan tests focused on broad regressions such as an unexpected full scan on a large fixture, not brittle node text.
- Use engine-native database testing where useful; pgTAP provides schema assertions and rolls back each test’s changes.
- Lint and format SQL in CI, then execute representative statements against the target dialect.
- Use parameterized-query tests and security review for every path that accepts external values.
- There is no universal SQL line, statement, or CTE limit; cohesion and reviewability are better signals than raw length.
- Split a statement when it mixes grains, unrelated business rules, repeated logic, or separate operational concerns.
- Keep a long statement intact when its single relational purpose is clear and the alternative would create trivial wrapper views.
- Treat a statement that needs several screens or cannot state its result grain in one sentence as a review trigger.
- Extract a view, stored procedure, or query module when it has a named contract, multiple consumers, and independent tests.
- Avoid layers of one-line views that force readers to chase definitions across schemas.
- Keep comments, fixtures, migration notes, and query plans close to the SQL they explain.
## Sources

### Standards and vendor documentation

- Vendor pages below support portable concepts; use them only to resolve explicitly labeled target-engine differences.
- [PostgreSQL SQL-standard feature matrix](https://www.postgresql.org/docs/current/features-sql-standard.html)
- [Microsoft Support: Database design basics](https://support.microsoft.com/en-us/access/database-design-basics)
- [PostgreSQL: Constraints](https://www.postgresql.org/docs/current/ddl-constraints.html)
- [PostgreSQL: Table expressions and joins](https://www.postgresql.org/docs/current/queries-table-expressions.html)
- [PostgreSQL: Lexical structure and identifiers](https://www.postgresql.org/docs/current/sql-syntax-lexical.html)
- [PostgreSQL: Logical operators and three-valued logic](https://www.postgresql.org/docs/current/functions-logical.html)
- [PostgreSQL: Transaction isolation](https://www.postgresql.org/docs/current/transaction-iso.html)
- [PostgreSQL: START TRANSACTION](https://www.postgresql.org/docs/current/sql-start-transaction.html)
- [PostgreSQL: Indexes](https://www.postgresql.org/docs/current/indexes.html)
- [PostgreSQL: CREATE INDEX](https://www.postgresql.org/docs/current/sql-createindex.html)
- [PostgreSQL: Using EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html)
- [PostgreSQL: LIMIT and OFFSET](https://www.postgresql.org/docs/current/queries-limit.html)
- [PostgreSQL: ALTER TABLE](https://www.postgresql.org/docs/current/sql-altertable.html)
- [MySQL 8.4: InnoDB transaction isolation](https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-isolation-levels.html)
- [MySQL 8.4: Multiple-column indexes](https://dev.mysql.com/doc/refman/8.4/en/multiple-column-indexes.html)
- [MySQL 8.4: Statements that cause an implicit commit](https://dev.mysql.com/doc/refman/8.4/en/implicit-commit.html)
- [MySQL 8.4: Atomic DDL statement support](https://dev.mysql.com/doc/refman/8.4/en/atomic-ddl.html)
- [MySQL 8.4: Online DDL operations](https://dev.mysql.com/doc/refman/8.4/en/innodb-online-ddl-operations.html)
- [SQL Server: SET TRANSACTION ISOLATION LEVEL](https://learn.microsoft.com/en-us/sql/t-sql/statements/set-transaction-isolation-level-transact-sql?view=sql-server-ver17)
- [SQLite: Isolation](https://sqlite.org/isolation.html)
- [SQLite: Query planning](https://sqlite.org/queryplanner.html)
- [SQLite: ALTER TABLE](https://sqlite.org/lang_altertable.html)
### Practitioner material

- [Markus Winand: Keyset pagination and the no-offset method](https://use-the-index-luke.com/no-offset)
- [PyCon US: Big O No, ORM runtime complexity and LATERAL JOINs](https://us.pycon.org/2020/schedule/presentation/157/)
- [Stripe Engineering: Online migrations at scale](https://stripe.com/blog/online-migrations)
- [GitLab Docs: Avoiding required stops](https://docs.gitlab.com/development/avoiding_required_stops/)
- [OWASP: SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [SQLFluff GitHub repository](https://github.com/sqlfluff/sqlfluff)
- [SQLFluff: Layout and whitespace configuration](https://docs.sqlfluff.com/en/latest/configuration/layout.html)
- [mattm/sql-style-guide GitHub repository](https://github.com/mattm/sql-style-guide)
- [pgTAP: Unit testing for PostgreSQL](https://pgtap.org/)
- [theory/pgtap GitHub repository](https://github.com/theory/pgtap)
