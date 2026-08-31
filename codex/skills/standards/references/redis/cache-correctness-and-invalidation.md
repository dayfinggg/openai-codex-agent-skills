# Cache correctness and invalidation

- Use cache-aside for read-heavy data: read Redis, load the primary on a miss, then write the result with a bounded TTL.
- On an authoritative update, commit the primary write first and delete the cache key rather than trying to maintain a second mutable copy.
- Treat a failed or delayed invalidation as a real consistency failure. Retry it or use an outbox, versioned value, or repair worker.
- A TTL bounds staleness but does not guarantee freshness before expiry, so use explicit invalidation for stricter requirements.
- Cache negative results with a shorter TTL when repeated misses could overload the primary store.
- Prevent stampedes with request coalescing, a short single-flight lease, probabilistic early refresh, and TTL jitter.
- Store complete, validated values and reject oversized or malformed cache entries before they reach shared Redis.
- For multi-key cached views, publish a versioned snapshot or update all keys atomically and invalidate derived variants together.
- Redis client-side caching with `CLIENT TRACKING` sends invalidation messages when tracked keys change, expire, or are evicted.
- The client must remove its local copy on invalidation. A disconnected tracked connection loses its local cache state.
- Broadcasting tracking trades server-side tracking memory for broader invalidation traffic, so use it only for suitable key prefixes.
- Pub/Sub is at-most-once and has no history, so an offline subscriber misses invalidations permanently.
- Use a Stream or durable outbox when invalidation or change delivery must survive consumer disconnects.
- Measure hit rate, stale reads, cache load latency, stampede rate, invalidation lag, evictions, and primary fallback load.
