# Redis quality reference

Use this as default guidance for Redis Open Source applications, then follow the deployment's exact server, module, and client versions.
Treat Redis as a data-structure server whose correctness depends on explicit keys, bounded state, and documented failure behavior.

## Data modeling

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

## Key naming

- Redis keys are binary-safe and Redis has no built-in namespace, so collisions are an application responsibility.
- Use a stable, documented shape such as `app:environment:tenant:entity:id:variant`.
- Use lower-case, ASCII-safe segments and a consistent delimiter, normally `:`.
- Prefix keys by application and environment when deployments share an instance.
- Validate tenant and user-derived segments for length and allowed characters before composing a key.
- Never put secrets or unnecessary personal data in key names because keys appear in logs, metrics, and diagnostics.
- Treat key names as a compatibility surface. Changing them requires a migration or dual-read plan.
- Keep names readable and reasonably short, but do not remove segments that prevent collisions or clarify ownership.
- Use `SCAN` with a cursor for administrative iteration and make the operation safe to repeat because results can duplicate.
- Avoid `KEYS` in request paths because a large scan can block the server. Reserve it for controlled diagnostics.
- Check command complexity before applying a range, set algebra, sort, or full-collection read to an unbounded value.

## TTLs and expiration

- Treat expiration as part of the data contract, not as an incidental cleanup task.
- Prefer `SET key value EX seconds` or `SET key value PX milliseconds` so creation and expiry are one operation.
- Use `EXPIRE` or `PEXPIRE` for an existing key and use `TTL` or `PTTL` to inspect the remaining lifetime.
- `TTL` returns `-1` for an existing key without expiry and `-2` for a missing key.
- Redis stores expiration timestamps with millisecond accuracy and expiration time advances while the server is stopped.
- Expiration is passive when an expired key is accessed and active when Redis samples expiring keys for cleanup.
- An expired key can therefore consume memory briefly if nothing accesses it. Do not use expiration as an exact-time scheduler.
- Overwriting commands such as `SET` clear a key's TTL, while in-place updates such as `HSET`, `INCR`, and list pushes preserve it.
- Use `PERSIST` deliberately when a key must remain persistent for the remainder of its lifecycle.
- On Redis 7.4 and later, use `HEXPIRE`, `HPEXPIRE`, `HTTL`, and `HPTTL` when individual hash fields need independent lifetimes.
- Add bounded random jitter to mass-created TTLs to avoid synchronized expiry and renewal load.
- Choose cache and negative-cache TTLs from the tolerated stale or invisible-data window.
- Reapply TTLs in tests and migrations after any write that overwrites a key or replaces a value.
- Keep wall clocks synchronized because absolute expiry and lease behavior depend on system time.

## Memory and performance

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

## Atomicity, transactions, Lua, and Functions

- Prefer a single native command such as `INCR`, `HINCRBY`, `SET ... NX`, `LMOVE`, or `GETDEL` when it expresses the invariant.
- `MULTI` queues commands and `EXEC` runs them sequentially without another client's command interleaving.
- `DISCARD` clears a queued transaction without executing it.
- A syntax or queueing error can abort the transaction, but a runtime error does not roll back earlier or later commands.
- Redis transactions have no rollback. Validate types and inputs before `EXEC` and design partial-error handling explicitly.
- Use `WATCH` for optimistic compare-and-set. A change, eviction, or expiration of a watched key makes `EXEC` return a null reply.
- Retry a failed `WATCH` transaction with a bounded, jittered backoff and a clear collision limit.
- Pipelining reduces round trips and preserves send order, but it does not provide isolation or all-or-nothing behavior.
- Use Lua when a bounded read-compute-write or multi-key invariant is simpler and faster on the server.
- Use `KEYS` for every key a script accesses and `ARGV` for values. Do not construct key names from untrusted values inside a script.
- Scripts and Functions execute atomically and block other server activity for their whole runtime, so keep them short and bounded.
- Keep scripts deterministic and avoid hidden time, randomness, or unbounded loops when effects must replicate consistently.
- `EVALSHA` depends on a volatile script cache. Reload scripts after restart or failover and handle `NOSCRIPT`.
- Redis 7 and later Functions are named, deployable libraries stored with the dataset and replicated or persisted with it.
- A Function library is updated as a whole, and Function execution still blocks the server, so deploy and test it like application code.
- Redis 8.4 and later provide string compare-and-set options and `DELEX` compare-and-delete. Use them only after checking server compatibility.

## Cache correctness and invalidation

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

## Distributed locks

- For best-effort coordination on one Redis instance, acquire with `SET lock token NX PX ttl`.
- Use a cryptographically strong unique token and release with `DELEX lock IFEQ token` on Redis 8.4 or later.
- On older servers, release with a Lua compare-and-delete script rather than unconditional `DEL`.
- A lock with a TTL is a lease. It expires even if the holder is paused, partitioned, or still doing work.
- Finish work within the validity window or renew only when the token still matches, and bound renewal attempts.
- Protect the downstream resource with a monotonically increasing fencing token when stale holders could corrupt data.
- Use random backoff, short acquisition timeouts, and prompt cleanup of partially acquired locks.
- Redis documents Redlock as a majority algorithm across independent masters, but its safety depends on timing and clock assumptions.
- The Redis lock documentation itself calls for fencing tokens and warns that TTL expiry uses a non-monotonic wall clock.
- Martin Kleppmann's critique concludes that Redlock is unsuitable when correctness depends on the lock and recommends consensus or transactional storage.
- Use Redis locks as efficiency hints unless the downstream system can reject stale owners with fencing or another invariant.
- Prefer idempotency keys, unique constraints, or a durable queue when duplicate work is safer than lock complexity.

## Streams and messaging

- Use `XADD` to append entries with server-assigned time-ordered IDs and `XREAD` for direct ordered reads.
- Use `XREADGROUP` when workers should share entries within a consumer group.
- Multiple consumer groups can independently read the same stream and maintain separate progress.
- Consumer groups provide at-least-once delivery, not exactly-once side effects.
- A delivered but unacknowledged entry remains in the group's pending entries list.
- Acknowledge only after the side effect is durable, and make handlers idempotent by event ID or application key.
- Monitor `XPENDING` and reclaim stale work with `XCLAIM` or `XAUTOCLAIM` after a consumer failure.
- Decide how to handle poison messages, delivery-count limits, and dead-letter storage before production.
- Bound retention with `XADD ... MAXLEN ~ N` or `XTRIM MINID ~ id` based on replay needs and worst consumer lag.
- Trimming can remove a payload before it is acknowledged. Route missing payloads to a dead-letter or repair path.
- Partition streams by tenant, region, or entity only when the resulting hot keys and ordering guarantees are acceptable.
- Pub/Sub is appropriate for transient notifications, while Streams provide history, replay, acknowledgement, and recovery.

## Persistence, replication, and failure behavior

- Disable persistence only when data is rebuildable and loss on restart is acceptable.
- RDB provides compact point-in-time snapshots, good backups, and generally faster large restarts, but can lose writes since the last snapshot.
- AOF records write commands and can be configured with `appendfsync always`, `everysec`, or `no`.
- `everysec` is a common durability and latency compromise and can lose about one second of writes after a hard failure.
- AOF files are usually larger than RDB files and can add disk, rewrite, and latency pressure.
- Combining RDB and AOF provides snapshots and recovery detail. When both exist, Redis uses the more complete AOF on restart.
- Plan peak RAM for BGSAVE and AOF rewrite copy-on-write, not only steady-state dataset size.
- Back up persistence files off-host and regularly test restore, failover, and corruption-recovery procedures.
- Current Redis versions can load an AOF with a truncated final command when configured to tolerate it. Inspect logs and keep an original copy.
- Replication is asynchronous by default, so replicas can lag and an acknowledged write can be lost during failover.
- `WAIT` confirms that prior writes reached a requested number of replicas, but it does not make Redis strongly consistent or guarantee survival of failover.
- A master with persistence disabled and automatic restart can restart empty and erase replicas during resynchronization. Avoid that topology for important data.
- Treat a client timeout after a write or `EXEC` as outcome-unknown. Reconcile state or use idempotent request identifiers before retrying.
- Read replicas only when stale reads are acceptable, and expose freshness or replication lag to callers where it matters.

## Clustering and high availability

- Redis Cluster shards keys across 16,384 CRC16 hash slots rather than using consistent hashing.
- A multi-key command, transaction, or script works only when all referenced keys share one hash slot.
- Use an intentional hash tag such as `user:{123}:profile` and `user:{123}:quota` to co-locate related keys.
- Avoid broad hash tags that create hot slots or concentrate many tenants on one node.
- Redis Cluster supports database zero only. Do not design clustered code around `SELECT` or multiple logical databases.
- Use a cluster-aware client that handles `MOVED` and `ASK` redirections and refreshes its slot map.
- Resharding can move slots without stopping single-key operations, but multi-key operations can temporarily return `TRYAGAIN`.
- Each slot needs a reachable master, and replicas can be promoted after a master failure.
- Cluster availability can still fail when the majority of masters is unavailable or slot coverage is incomplete.
- `READONLY` reads from replicas may be stale and should not serve data that requires primary freshness.
- Sentinel is the high-availability option for a non-clustered primary and replicas. It monitors, promotes, and publishes the new master address.
- Run at least three Sentinels on failure-independent hosts and distinguish failure-detection quorum from failover authorization majority.
- Clients must use Sentinel discovery and reconnect to the promoted master after failover.
- Test partitions, delayed packets, resharding, failover, reconnects, duplicate requests, and lost writes before relying on HA claims.

## Security

- Keep Redis on a private network, firewall the port, bind only required interfaces, and never expose an unauthenticated instance to the Internet.
- Protected mode is a safety net, not a substitute for network isolation and explicit authentication.
- Prefer Redis ACL users with least-privilege commands, key patterns, and Pub/Sub channel patterns.
- Key patterns do not restrict database-wide commands such as `FLUSHALL`, `FLUSHDB`, or `SWAPDB`. Deny those commands explicitly for application users.
- Use TLS for client traffic, replication links, the Cluster bus, and Sentinel connections when traffic crosses a trust boundary.
- When TLS client authentication is enabled, Redis uses mutual certificate authentication by default.
- Do not rely on legacy `requirepass` alone because authentication without TLS exposes credentials to network observers.
- Use client parameterization and binary-safe protocol arguments, and never build Lua source from untrusted input.
- Restrict `CONFIG`, `DEBUG`, `MONITOR`, `SAVE`, `SHUTDOWN`, scripting, and module administration to trusted operator roles.
- Run Redis as an unprivileged OS user with restricted persistence directories and backup access.
- Validate untrusted payload sizes and collection growth to reduce denial-of-service risk from expensive commands or oversized values.
- Rotate ACL secrets, audit `ACL LOG`, and test permissions against the exact commands and key patterns used by each service.

## Sources

### Official Redis documentation

- [Redis data types](https://redis.io/docs/latest/develop/data-types/) and [comparison guide](https://redis.io/docs/latest/develop/data-types/compare-data-types/)
- [Redis keys and values](https://redis.io/docs/latest/develop/use/keyspace/) and [hashes](https://redis.io/docs/latest/develop/data-types/hashes/)
- [EXPIRE](https://redis.io/docs/latest/commands/expire/) and [TTL](https://redis.io/docs/latest/commands/ttl/) command references
- [Redis memory optimization](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/memory-optimization/) and [key eviction](https://redis.io/docs/latest/develop/reference/eviction/)
- [Redis pipelining](https://redis.io/docs/latest/develop/using-commands/pipelining/) and [transactions](https://redis.io/docs/latest/develop/using-commands/transactions/)
- [Redis programmability](https://redis.io/docs/latest/develop/programmability/), [Lua scripting](https://redis.io/docs/latest/develop/programmability/eval-intro/), and [Functions](https://redis.io/docs/latest/develop/programmability/functions-intro/)
- [Redis cache-aside](https://redis.io/docs/latest/develop/use-cases/cache-aside/) and [client-side caching](https://redis.io/docs/latest/develop/clients/client-side-caching/)
- [Redis distributed locks](https://redis.io/docs/latest/develop/clients/patterns/distributed-locks/) and [SET locking pattern](https://redis.io/docs/latest/commands/set/)
- [Redis streaming](https://redis.io/docs/latest/develop/use-cases/streaming/) and [XACK](https://redis.io/docs/latest/commands/xack/)
- [Redis persistence](https://redis.io/docs/latest/operate/oss_and_stack/management/persistence/), [replication](https://redis.io/docs/latest/operate/oss_and_stack/management/replication/), and [WAIT](https://redis.io/docs/latest/commands/wait/)
- [Redis Cluster scaling](https://redis.io/docs/latest/operate/oss_and_stack/management/scaling/) and [Cluster specification](https://redis.io/docs/latest/operate/oss_and_stack/reference/cluster-spec/)
- [Redis Sentinel](https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/)
- [Redis security](https://redis.io/docs/latest/operate/oss_and_stack/management/security/), [ACL](https://redis.io/docs/latest/operate/oss_and_stack/management/security/acl/), and [TLS](https://redis.io/docs/latest/operate/oss_and_stack/management/security/encryption/)
- [Redis latency diagnosis](https://redis.io/docs/latest/operate/oss_and_stack/management/optimization/latency/)

### Maintainer examples

- [Redis source repository](https://github.com/redis/redis), [Cluster create-cluster example](https://github.com/redis/redis/blob/unstable/utils/create-cluster/README), and [redis-py examples](https://github.com/redis/redis-py)

### Talks and practitioner material

- [Salvatore Sanfilippo, Redis patterns for coding](https://antirez.com/news/161) and [Redis patterns for coding agents](https://redis.antirez.com/)
- [Redis reliability patterns video](https://redis.io/resources/videos/debug-faster-safely-reprocess-events-and-prove-system-reliability/)
- [Martin Kleppmann, How to do distributed locking](https://martin.kleppmann.com/2016/02/08/how-to-do-distributed-locking.html)
