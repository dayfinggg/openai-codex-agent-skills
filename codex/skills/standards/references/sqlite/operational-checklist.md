# Operational checklist

- Record SQLite version, compile-time options, VFS, filesystem, journal mode, synchronous setting, collation, and foreign-key setting in deployment metadata.
- Keep one SQLite build in the process when possible, and open connections in the process that owns them rather than carrying them across `fork()`. [S15]
- Use a connection pool only when its transaction, statement-finalization, and busy-timeout behavior is explicit.
- Measure representative queries with `EXPLAIN QUERY PLAN`; do not infer index use from schema text alone. [S8]
- Test multiple connections under reader, writer, lock-wait, busy, checkpoint, and crash-recovery workloads.
- Use the Online Backup API or `VACUUM INTO` for live backups, and keep sidecars paired during file movement. [S15] [S11]
- Treat a SQLite file as application data with a lifecycle, migration policy, backup policy, and version compatibility policy.
