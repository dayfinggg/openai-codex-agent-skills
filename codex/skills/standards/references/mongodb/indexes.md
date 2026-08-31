# Indexes
Map indexes to real query shapes, including equality filters, ranges, sorts, projections, and joins.
Create indexes for frequent selective queries on production-representative data.
Every index consumes disk and memory and adds work to inserts, updates, and deletes.
Inspect index use periodically and remove indexes that no longer serve a query.
Use [`explain("executionStats")`](https://www.mongodb.com/docs/manual/tutorial/analyze-query-plan/) to compare documents examined, keys examined, time, and winning plans.
The [indexing strategies guide](https://www.mongodb.com/docs/manual/applications/indexes/) recommends profiling candidate configurations rather than guessing.
Compound indexes serve the complete key pattern and its prefixes.
An index `{a: 1, b: 1}` can support `{a: ...}` but not a query on `b` alone.
MongoDB permits at most 32 fields in one compound index.
Apply ESR by placing equality keys first, then sort keys, then range keys.
Use ERS instead when a highly selective range should reduce the rows that an in-memory sort processes.
Equality keys can appear in any order relative to one another, but precede sort and range keys.
Do not rely on the index order until `explain` confirms it for the actual query.
See the [ESR guideline](https://www.mongodb.com/docs/manual/tutorial/equality-sort-range-guideline/) and [compound-index guide](https://www.mongodb.com/docs/manual/core/indexes/index-types/index-compound/create-compound-index/).
Use unique indexes for database-enforced uniqueness, including compound business keys.
Use partial indexes when only a filtered subset needs indexing, and include the filter in usable queries.
Prefer partial indexes over sparse indexes when the condition is more precise than field existence.
Use TTL indexes for finite-lived sessions, logs, or machine-generated data.
Use hidden indexes to test the effect of dropping an index without dropping it.
These properties and their restrictions are summarized in [index properties](https://www.mongodb.com/docs/manual/core/indexes/index-properties/).
An index on an array becomes a multikey index automatically.
A compound multikey index can have at most one array-valued indexed field per document.
Large arrays generate many index keys and can trigger index-key or memory limits.
Do not use an unbounded array as a substitute for a child collection.
See [multikey indexes](https://www.mongodb.com/docs/manual/core/indexes/index-types/index-multikey/) before indexing nested arrays.
