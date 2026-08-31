# Distributed locks

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
