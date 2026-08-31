# Persistence, replication, and failure behavior

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
