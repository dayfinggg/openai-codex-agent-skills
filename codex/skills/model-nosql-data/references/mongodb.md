# MongoDB modeling

**Reviewed:** 2026-08-11
**Scope:** Current MongoDB manual. Resolve server version, feature compatibility version, topology, and driver version first.

## Model and consistency

- Choose embedding when data is read, updated, owned, and bounded together. Choose references when lifecycles, cardinality, sharing, or size require separation.
- Keep documents and arrays bounded. Account for the document size limit, growing-array rewrite cost, and shard distribution.
- Use schema validation for cross-writer invariants it can express. Roll validation out compatibly against existing documents.
- Set read concern, write concern, read preference, retry behavior, and session transaction semantics from the actual durability and staleness contract.

## Indexes and measurement

- Design compound index order from equality, sort, and range patterns plus selectivity and projection needs.
- Inspect multikey, partial, sparse, text, TTL, wildcard, unique, and collation semantics before use.
- Use query-plan and execution statistics on representative data. Measure write amplification, working set, cache pressure, and index build impact.
- For sharded collections, validate shard key cardinality, frequency, monotonicity, targeting, and zone needs. Avoid hot shards and scatter-gather as defaults.

## Official sources

- [Data modeling](https://www.mongodb.com/docs/manual/data-modeling/)
- [Indexes](https://www.mongodb.com/docs/manual/indexes/)
- [Transactions](https://www.mongodb.com/docs/manual/core/transactions/)
- [Schema validation](https://www.mongodb.com/docs/manual/core/schema-validation/)
- [Explain results](https://www.mongodb.com/docs/manual/reference/explain-results/)
