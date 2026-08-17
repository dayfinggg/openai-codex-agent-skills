---
name: design-nosql-database
description: Design and evolve document, key-value, wide-column, and other NoSQL data stores. Use for access-pattern modeling, documents or items, partition keys, denormalization, indexes, consistency, transactions, capacity, migrations, security, and recovery.
---

# Design NoSQL Database

## Workflow

1. Identify the exact product and version. Record access patterns, cardinality, fan-out, latency, throughput, item size, tenancy, retention, TTL, and recovery requirements.
2. Model aggregates around atomic updates and reads. Choose embedding, references, and denormalization deliberately, including ownership and repair paths for duplicated data.
3. Define a document or item contract and version it even when the store is schema-flexible. Validate critical fields at the trusted boundary and in the database when supported.
4. Choose partition or shard keys from distribution and access patterns. Analyze hot keys, growth, limits, and capacity behavior.
5. Add indexes only for named access patterns and verify them with product tools and representative data.
6. State the required consistency for each operation. Prefer single-item atomicity and use distributed transactions only when a proven invariant requires them.
7. Plan mixed-version reads, staged writes, backfill, validation, rollback or repair, IAM, encryption, backup, and restore. Test failure and retry behavior.

Do not apply relational normalization mechanically or use CAP as a substitute for product-specific consistency analysis.

Read [NoSQL database practices](references/practices.md) for MongoDB and DynamoDB guidance.
