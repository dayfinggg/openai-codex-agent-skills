# Clustering and high availability

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
