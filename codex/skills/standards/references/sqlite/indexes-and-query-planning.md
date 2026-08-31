# Indexes and query planning

- SQLite's cost-based planner depends on programmer-created indexes and can use indexes for both searching and sorting. [S7]
- A covering index can avoid table lookups when it contains every value required by the query. [S7]
- Design composite indexes from actual equality, range, join, and ordering predicates, and remove redundant indexes after measuring write cost.
- Create child-key indexes for foreign-key checks and parent deletes even though SQLite does not require those child indexes. [S6]
- Use `EXPLAIN QUERY PLAN` during interactive tuning to see `SCAN`, `SEARCH`, index names, covering use, and temporary sort b-trees. [S8]
- Treat `EXPLAIN QUERY PLAN` output as diagnostic text, not as a stable application interface because its format can change between releases. [S8]
- Run `ANALYZE` or the appropriate statistics maintenance for the deployed workload before judging a plan. [S7]
- Prefer parameter binding and prepared statements, and make the bound value's intended type explicit at the application boundary. [S1]
- Recheck plans after data growth, statistics changes, SQLite upgrades, or index changes.
