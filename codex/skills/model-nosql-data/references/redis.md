# Redis modeling

**Reviewed:** 2026-08-11
**Scope:** Redis Open Source current documentation. Resolve server version, deployment mode, persistence, eviction, and client behavior first.

## Data structures and keys

- Select strings, hashes, sets, sorted sets, streams, probabilistic types, or JSON modules from required operations and bounds, not familiarity.
- Keep key names stable, namespaced by an existing convention, and free of secrets. Bound key, field, member, stream, and value growth.
- In cluster mode, design hash slots and multi-key operations intentionally. A hot logical key remains hot even when the cluster has many nodes.

## Atomicity, durability, and capacity

- Use single-command atomicity when possible. Understand that `MULTI` and `EXEC` queue commands but do not provide relational rollback semantics.
- Use optimistic locking, Lua or functions, or transactions only with exact-version semantics and bounded execution. Never run untrusted scripts.
- Define persistence, replication, acknowledgment, failover, and data-loss tolerance. A cache eviction policy is not a durable-storage contract.
- Measure memory, fragmentation, slow operations, latency, hot keys, eviction, replication lag, and blocked clients. Avoid broad key scans and unbounded commands on shared production instances.
- Define TTL and invalidation ownership, stampede protection, stale-value behavior, and recovery from cache loss.

## Official sources

- [Redis data types](https://redis.io/docs/latest/develop/data-types/)
- [Transactions](https://redis.io/docs/latest/develop/using-commands/transactions/)
- [Redis Cluster specification](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/)
- [Key eviction](https://redis.io/docs/latest/develop/reference/eviction/)
- [Persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/)
