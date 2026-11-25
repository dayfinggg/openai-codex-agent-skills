# Caching, Redis and Memcached

## Before you add a cache

A cache hides a slow query and adds a second source of truth. Fix the query or the index first, and add a cache when the measured cost of the read still justifies stale data and invalidation code.

## Patterns

With cache-aside, the code reads the cache, falls back to the store on a miss, and writes the result with a time to live. On a write to the store, delete the cached key, since writing the new value to the cache from two requests can leave the older one. Give every key a time to live, and add random jitter to it so that keys written together do not expire together.

A stampede happens when a popular key expires and many requests rebuild it at once. Let one request rebuild it under a short lock while the others wait or serve the old value, or refresh a key shortly before it expires. Cache a miss for a short time when lookups of absent keys are common.

Put a version and the tenant or the user into the key when the value depends on them. Never store a response that belongs to one user under a key that another user can reach, and do not cache secrets. A read from a replica right after a write can return the old value, so read your own write from the primary.

## Redis

Set `maxmemory` and an eviction policy on an instance used as a cache. `allkeys-lru` is the usual choice, and without a limit the instance grows until the host runs out of memory. Set the value and its expiry in one command, as in `SET key value EX 300`, because a plain `SET` removes an existing expiry. Iterate with `SCAN` and never with `KEYS` in application code, since `KEYS` blocks the server while it walks every key. Delete a large key with `UNLINK`, which frees memory in the background. Send many commands in a pipeline, in batches of a few thousand.

Pick the structure by the access pattern, such as a hash for an object with fields, a sorted set for a ranking or a time window, and a stream or a list for a queue. One huge key is slow to read, move and delete, so split it. Check the hit ratio from `keyspace_hits` and `keyspace_misses` in `INFO stats` before you call a cache useful.

Find out which server and version runs, because Redis and its forks differ in newer commands and in licence.

## Memcached

Memcached holds opaque values under string keys with a time to live, evicts the least recently used items when memory is full, and keeps nothing across a restart. An item is limited to 1 MB by default. Treat every read as something that can miss.
