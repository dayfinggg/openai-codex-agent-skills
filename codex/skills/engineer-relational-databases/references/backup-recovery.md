# Backup and recovery

**Reviewed:** 2026-08-11
**Scope:** Engine-native backup, restore, point-in-time recovery, and integrity verification.

## Recovery contract

1. Identify the authoritative data owner, protected datasets, topology, engine and extension versions, encryption keys, retention, legal constraints, target RPO, and target RTO.
2. Select a supported logical, physical, snapshot, replication, or continuous-archive mechanism from those requirements. A filesystem copy of a live database is not automatically consistent.
3. Protect backup credentials and media with least privilege, encryption, access logging, retention enforcement, and deletion policy. Keep backups isolated from the same failure domain and credentials where required.
4. Verify backup completion, consistency, expected contents, and chain continuity. Monitor age and failed jobs.
5. Restore into an authorized isolated target using documented versions and keys. Verify schema, row or object integrity, application reads, transaction consistency, and measured recovery time.
6. Record gaps between observed and required RPO or RTO. Do not claim recoverability from a successful backup command alone.

## Official sources

- [PostgreSQL backup and restore](https://www.postgresql.org/docs/current/backup.html)
- [PostgreSQL continuous archiving](https://www.postgresql.org/docs/current/continuous-archiving.html)
- [MySQL backup and recovery](https://dev.mysql.com/doc/refman/8.4/en/backup-and-recovery.html)
- [SQLite backup API](https://www.sqlite.org/backup.html)
