# DynamoDB modeling

**Reviewed:** 2026-08-11
**Scope:** Amazon DynamoDB service documentation. Resolve region, table mode, quotas, SDK version, and deployed features first.

## Access patterns and partitions

- Start from request patterns and choose partition and sort keys that distribute traffic while grouping items needed by one query or transaction.
- Model entity type, relationship, and version within keys only when the existing application adopts that convention. Keep key strings and item sizes bounded.
- Estimate item size, read and write units, consistency, burst, adaptive-capacity behavior, and hot-partition risk for each pattern.

## Indexes and correctness

- Use global and local secondary indexes only for named patterns. Account for projection, eventual consistency, write amplification, backfill, throttling, and sparse membership.
- Protect invariants with conditional expressions, version attributes, idempotency records, or transactions. Handle partial batch responses and retries without duplicate effects.
- Query by key rather than defaulting to scans. Record consumed capacity and throttling under representative skew.
- Design TTL, streams, global tables, backup, and restore as asynchronous distributed workflows with explicit lag and conflict behavior.

## Official sources

- [DynamoDB data modeling](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/data-modeling.html)
- [Partitions and data distribution](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.Partitions.html)
- [Secondary indexes](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SecondaryIndexes.html)
- [Transactions](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/transactions.html)
- [Backup and restore](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/BackupRestore.html)
