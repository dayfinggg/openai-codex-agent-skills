# Testing and maintainable SQL sizing

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
- Keep fixtures, migration notes, and query plans close to the SQL they validate or explain. Do not add comments that merely restate a statement.
