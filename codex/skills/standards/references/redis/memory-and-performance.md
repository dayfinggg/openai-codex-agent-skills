# Memory and performance

- Budget value bytes, key and object overhead, allocator fragmentation, replicas, replication buffers, AOF buffers, and fork copy-on-write memory.
- Set `maxmemory` explicitly and leave headroom for buffers, failover, background persistence, and traffic bursts.
- Use `INFO memory`, `MEMORY USAGE`, `INFO stats`, and allocator metrics to measure real usage instead of estimating from payload size alone.
- Choose `noeviction` for authoritative data when rejected writes are safer than silent loss.
- Choose `allkeys-lru` or `allkeys-lfu` for a cache after measuring the access pattern.
- Use `volatile-*` policies only when every candidate key has a TTL and persistent keys must be protected.
- Redis LRU, LFU, and LRM policies are approximations. Benchmark policy and sample-size choices against production-shaped traffic.
- Small hashes, lists, integer sets, and sorted sets use compact encodings until configured thresholds are exceeded.
- Prefer compact encodings and hashes for small records, but benchmark before raising thresholds because conversion cost grows with collection size.
- Use bit-level or probabilistic structures when their semantics justify substantial memory savings.
- Bound every list, set, sorted set, hash, JSON document, and stream with a business or operational limit.
- Use `UNLINK` for large asynchronous deletion when temporary delayed reclamation is acceptable.
- Use aggregated commands or bounded pipelines to reduce round trips. A pipeline is not a transaction unless it uses `MULTI` and `EXEC`.
- Cap pipeline batches because queued replies consume server and client memory.
- Redis serves commands sequentially in a mostly single-threaded execution path, so one slow command delays other clients.
- Avoid unbounded `HGETALL`, `SMEMBERS`, large range reads, `SORT`, and set algebra on hot paths.
- Monitor latency, slowlog, hit rate, misses, evictions, expirations, rejected writes, fragmentation, and resident memory.
