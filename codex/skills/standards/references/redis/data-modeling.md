# Data modeling

- Start with access patterns, invariants, cardinality, update frequency, retention, and failure cost.
- Choose the native type that makes the required operation direct instead of serializing every value into an opaque blob.
- Use strings for opaque text or bytes, counters, flags, bitmaps, and small serialized values.
- Use hashes for flat records, field updates, counters, and grouped values that share a lifecycle.
- Use JSON for nested documents, arrays, path updates, and document search when RedisJSON is available.
- Use lists for short queues, stacks, and deques with head or tail operations.
- Use sets for unique membership, deduplication, and set algebra without ordering.
- Use sorted sets for unique members ordered by score, such as rankings, schedules, and priority queues.
- Use Streams for append-only event history, replay, retention, and consumer groups.
- Use bitmaps, HyperLogLog, Bloom filters, or other probabilistic types only when their accuracy and update semantics are acceptable.
- Current Redis releases also expose arrays and vector sets. Verify support in the target server and client before depending on them.
- Keep an aggregate's fields together when they share consistency and lifecycle requirements.
- Split very large aggregates into bounded shards rather than creating one hot or unbounded collection.
- Model secondary indexes explicitly with sets or sorted sets and update the index in the same atomic operation as the record.
- Delete or repair index entries when records change or expire. Redis does not infer application indexes.
- Duplicate read models when that removes expensive queries, but document the source of truth and rebuild procedure.
- Store a schema version in the key or value when rolling upgrades can encounter old representations.
- Record each key's value type, owner, allowed commands, TTL policy, and maximum expected size.
