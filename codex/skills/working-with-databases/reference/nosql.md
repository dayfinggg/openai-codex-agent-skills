# NoSQL stores

NoSQL design starts from access patterns. Write down the queries, their frequency, and the data size before designing documents or keys.

## MongoDB

- Embed child data that is read with the parent, owned by it, and bounded in size. Reference data that is large, shared by many parents, grows without limit, or is read on its own.
- Documents are limited to 16 MB, so design to stay far below that.
- Enforce structure with `$jsonSchema` validation, and give documents a `schemaVersion` field when their shape evolves.
- Store dates as BSON dates, money as `Decimal128`, and identifiers consistently as `ObjectId` or strings.
- Known patterns are computed, bucket, subset, extended reference, outlier, polymorphic, and schema versioning. Copy only fields that rarely change into an extended reference, because copies need an update strategy.
- Anti-patterns are unbounded arrays, bloated documents, a collection per customer or per day, unnecessary or duplicate indexes, frequent `$lookup`, and case-insensitive queries without a matching collation or index.
- Order compound index fields by equality, sort, range, and use projections to return only needed fields.
- Prefer a design where one document changes atomically over multi-document transactions. Use write concern `majority` for important writes.

## DynamoDB

- List the access patterns first and design partition and sort keys to serve them, because anything else needs expensive scans. Related items share a partition key and the sort key orders them, as in `PK = CUSTOMER#42` with `SK = ORDER#2026-10-07#ord_1001`.
- Choose high-cardinality partition keys so no partition gets hot.
- Use as few tables as the access patterns allow. Add global secondary indexes for further patterns and project only the attributes those reads need.
- Items are limited to 400 KB, so keep large payloads in object storage with a pointer.
- Use `Query`, not `Scan`, on request paths. Use condition expressions for optimistic locking and uniqueness, and TTL for expiring data.

## Redis

- Name keys with a namespace and colons, as in `app:user:42:profile`.
- Use cache-aside by default. Read the cache, on a miss load from the database and store with a TTL, and delete the key when the data changes.
- Protect hot keys from stampedes with a lock, request coalescing, or early refresh.
- Use `SCAN` in production instead of `KEYS` and other blocking commands.
- Treat Redis as rebuildable unless persistence and replication are deliberately configured.
