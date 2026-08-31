# Redis quality reference

Use this as default guidance for Redis Open Source applications, then follow the deployment's exact server, module, and client versions.
Treat Redis as a data-structure server whose correctness depends on explicit keys, bounded state, and documented failure behavior.

## Reference map

- [Data modeling](data-modeling.md)
- [Key naming](key-naming.md)
- [TTLs and expiration](ttls-and-expiration.md)
- [Memory and performance](memory-and-performance.md)
- [Atomicity, transactions, Lua, and Functions](atomicity-transactions-lua-and-functions.md)
- [Cache correctness and invalidation](cache-correctness-and-invalidation.md)
- [Distributed locks](distributed-locks.md)
- [Streams and messaging](streams-and-messaging.md)
- [Persistence, replication, and failure behavior](persistence-replication-and-failure-behavior.md)
- [Clustering and high availability](clustering-and-high-availability.md)
- [Security](security.md)
- [Sources](sources.md)
