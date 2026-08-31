# Atomicity, transactions, Lua, and Functions

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
