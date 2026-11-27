# Caching, Redis and Memcached

## Before you add a cache

A cache adds a second source of truth. Fix the query or the index first, and cache when the measured read cost still justifies stale data and invalidation code.

## Patterns

With cache-aside, read the cache, fall back to the store on a miss, and write the result with a time to live. On a write to the store, delete the key, because two requests writing new values can leave the older one. Give every key a time to live with random jitter so that keys written together expire apart.

Against a stampede on a popular key, let one request rebuild it under a short lock while others wait or serve the old value, or refresh shortly before expiry. Cache misses briefly when lookups of absent keys are common.

Put a version and the tenant or user into the key when the value depends on them, keep per-user responses under keys only that user reaches, and leave secrets out of the cache. Read your own write from the primary, since a replica may still return the old value.

## Redis

An instance used as a cache needs `maxmemory` and an eviction policy, usually `allkeys-lru`, or it grows until the host runs out of memory. Set value and expiry in one command, as in `SET key value EX 300`, because a plain `SET` clears an existing expiry. Iterate with `SCAN` or `redis-cli --scan`, since `KEYS` blocks the server while it walks every key. Delete large keys with `UNLINK`, pipeline commands in batches of a few thousand, and split huge keys.

Pick the structure by access pattern, such as a hash for an object, a sorted set for a ranking or time window, and a stream or list for a queue. Judge a cache by `keyspace_hits` and `keyspace_misses` in `INFO stats`. Check which server and version runs, because Redis and its forks differ in newer commands and licence.

## Memcached

Memcached holds opaque values with a time to live, evicts least recently used items when full, keeps nothing across a restart, and limits an item to 1 MB by default. Treat every read as a possible miss.
