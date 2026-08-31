# TTLs and expiration

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
