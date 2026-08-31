# Backups and file movement

- Rollback journal mode does not make a live byte-for-byte file copy safe; an active transaction can leave a copy with mixed old and new content. [S15]
- For a live database, choose one safe method: quiesce all transactions before copying, use the Online Backup API, or use `VACUUM INTO`. [S15] [S11]
- The Online Backup API can copy incrementally and produces a consistent snapshot while other users continue with short lock periods. [S11]
- `VACUUM INTO` writes the current database state to a separate file and is suitable for a live database. [S15] [S11]
- If an active `-journal`, `-wal`, or `-shm` sidecar exists, preserve the required sidecars with the database when moving it. [S15] [S5]
- Never detach, rename, delete, or mix a hot journal or WAL file with another database. [S15]
- A quiescent copy is safe only when no transactions are in progress during the copy. [S15]
- Verify copied files with `PRAGMA integrity_check`, `PRAGMA quick_check`, row counts, and `PRAGMA foreign_key_check` before release. [S2] [S6]
