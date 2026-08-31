# Deployment and operations

- Package, service, and container deployments all run `mysqld`; persist the data directory and pin a versioned image or package. [M17]
- The Oracle Docker instructions use version tags and require persisted data and configuration for container upgrades. [M17]
- The Docker Official Image repository is maintained by the Docker Community and MySQL Team and exposes the packaging source. [M23]
- Keep credentials out of command lines and source control, and use the server's account and privilege system for least privilege.
- Monitor connection pressure, lock waits, deadlocks, slow queries, disk space, redo and undo pressure, and replication health.
- Verify backups by restoring them, not merely by checking that a dump or snapshot file exists.
- Test failover, restart recovery, migration rollback or forward-fix, and client reconnection behavior before relying on them.
