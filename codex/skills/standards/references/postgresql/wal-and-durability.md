# WAL and durability

- Treat WAL, checkpoints, archive retention, replication slots, and backups as one recoverability budget. Bound retained data and monitor the oldest consumer so a stalled slot or archive path cannot fill storage silently.
- Keep `fsync` and `full_page_writes` enabled for durable production data unless the entire instance is explicitly disposable. A faster acknowledgement is not useful when the recovery contract becomes false.
- Choose `synchronous_commit` per operation from the allowed loss and latency contract. Distinguish local WAL flush, remote write, remote flush, and remote apply instead of calling every synchronous mode durable in the same way.
- Set `wal_level`, archiving, and replica settings from the actual recovery and change-data-capture requirements. Verify that required WAL remains available through backup, restore, failover, and consumer lag.
- Enable and verify data checksums where their operational cost and lifecycle are acceptable. Checksums detect some corruption but do not repair data or replace backups.
- Inspect checkpoint frequency, duration, generated WAL, buffer writes, and current-version statistics such as `pg_stat_checkpointer` before tuning. Do not copy exact memory, interval, or cost constants from another release or workload.
