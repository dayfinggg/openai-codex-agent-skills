---
name: application-cache-change
description: "Change application or Redis caching with key, invalidation, concurrency, failure, and data-isolation verification. Use for cache-aside, TTL, cache stampedes, or stale application data."
---

Preserve the application's data contract while changing its cache.

1. Establish the source of truth, existing cache client and server versions, serialization format, key construction, TTL, and invalidation path. Identify shared keys and all readers and writers.
2. Determine which inputs affect the cached value. Include the verified identity and schema dimensions needed for correctness. Do not assume that a namespaced key replaces authorization.
3. Trace writes, commits, events, and invalidation. Check races between reading old data, writing new data, and repopulating the cache. Publish invalidation at the appropriate transaction boundary.
4. Define behavior for simultaneous misses, partial failures, negative results, and unavailable Redis. Use bounded concurrency or existing atomic primitives where needed. Do not silently make a correctness-critical store optional.
5. For locks, verify ownership tokens, expiration, renewal, and atomic release against the actual client and Redis version. A successful SET does not by itself establish a distributed correctness guarantee.
6. Check compatibility of serialized values during rolling releases. Avoid clearing all keys or changing global Redis settings to resolve one application's issue.
7. Verify miss, hit, update, expiration, concurrent access, and relevant outage paths. Measure origin load and latency only with comparable data and conditions.

Use installed Redis specialists for command, connection, or cluster details. Preserve durability-sensitive data that happens to share the Redis instance.

Consult [Redis caching patterns](https://redis.io/docs/latest/develop/use/) and version-matched client documentation. Finish with evidence that both cached and uncached behavior satisfy the requested contract.

