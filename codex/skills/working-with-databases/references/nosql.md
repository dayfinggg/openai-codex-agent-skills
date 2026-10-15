# NoSQL stores

NoSQL design starts from access patterns, not from entities. Write down the queries, their frequency, and the data size before designing documents or keys.

## Contents

- MongoDB
- DynamoDB
- Redis

## MongoDB

### Modeling

- Data that is accessed together is stored together. Embed child data that is read with the parent, owned by it, and bounded in size.
- Reference data that is large, shared by many parents, grows without limit, or is read on its own.
- Documents are limited to 16 MB, so design to stay far below that.
- Enforce structure with `$jsonSchema` validation on collections, and give documents a `schemaVersion` field when their shape evolves.
- Store dates as BSON dates, money as `Decimal128`, and identifiers consistently as `ObjectId` or strings.

### Patterns

| Pattern | Use when |
|---|---|
| Computed | Values are read far more often than the data behind them changes, so store totals or counts on write |
| Bucket | Time series or many small events, grouped per time window or per count |
| Subset | A document holds a long list but readers need only the latest items, so keep those embedded and the rest elsewhere |
| Extended reference | A reader needs a few fields of a referenced document, so copy those fields to avoid a lookup |
| Outlier | A few documents have far more related items than the rest, so handle the overflow separately |
| Polymorphic | Related kinds of entity share one collection and most of their fields |
| Schema versioning | Documents of different shapes coexist during a migration |

Copied data, as in extended references, needs an update strategy, so copy only fields that rarely change.

### Anti-patterns

- Unbounded arrays that grow forever inside one document.
- Bloated documents carrying data the common reads do not need.
- Too many collections, such as one per customer or per day.
- Unnecessary or duplicate indexes.
- Frequent `$lookup` across collections, which signals a relational design forced into documents.
- Case-insensitive queries without a case-insensitive index or collation.

### Queries and safety

- Build filters from typed values, never pass request bodies straight into a filter, and reject keys that start with `$`.
- Use projections to return only needed fields.
- Follow the equality, sort, range rule for compound index field order.
- Use multi-document transactions only when the model truly needs them, and prefer designing so that one document changes atomically.
- Set write concern `majority` for important writes.

## DynamoDB

- List access patterns first, then design partition and sort keys to serve them, since anything outside them needs expensive scans.
- Keep related items together under one partition key and use the sort key to order and filter them, as in `PK = CUSTOMER#42` with `SK = ORDER#2026-10-07#ord_1001`.
- Choose high-cardinality partition keys so traffic spreads evenly and no partition gets hot.
- Use as few tables as the access patterns allow. A single table is common for related entities, while very different workloads such as time series can live separately.
- Add global secondary indexes for additional access patterns, and project only the attributes those reads need.
- Items are limited to 400 KB, so store large payloads in object storage and keep a pointer.
- Use `Query`, not `Scan`, on request paths. Use condition expressions for optimistic locking and uniqueness, and TTL for expiring data.

## Redis

- Name keys with a namespace and colons, as in `app:user:42:profile`, and keep the scheme consistent.
- Give every cache key an expiry, and decide how it is invalidated when the source changes.
- Use cache-aside by default. Read from the cache, on a miss load from the database and store with a TTL, and delete the key when the data changes.
- Protect hot keys from stampedes with a lock, request coalescing, or early refresh.
- Choose the data structure that fits, such as hashes for objects, sorted sets for rankings and time windows, and streams for durable queues.
- Avoid `KEYS` and other blocking commands in production, use `SCAN`.
- Keep values small, and remember that Redis memory is the limit.
- Treat Redis as rebuildable unless persistence and replication are deliberately configured.
