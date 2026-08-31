# Concurrency and isolation

- SQLite supports multiple simultaneous readers but only one simultaneous writer per database file. [S3] [S4]
- SQLite obtains serializable isolation by serializing writes rather than by allowing multiple writers to commit concurrently. [S3]
- Rollback mode prevents readers from observing a write while pages are being written to the database file. [S3]
- WAL mode lets readers and a writer proceed concurrently, but WAL still has only one writer. [S5]
- A WAL reader sees a stable snapshot until its read transaction ends. [S3] [S5]
- A reader that upgrades to a writer can receive `SQLITE_BUSY` if another connection has already written. [S4]
- Use `BEGIN IMMEDIATE` when a unit of work must reserve the write slot before reading and changing data. [S4]
- Configure a bounded busy handler or timeout, and handle the remaining `SQLITE_BUSY` result explicitly. [S12]
- Keep write transactions short, finalize statements promptly, and never perform slow external work inside a write transaction.
- WAL requires participating processes to share one host and does not work over a network filesystem. [S5]
- The SQLite documentation currently records a rare WAL-reset corruption bug fixed in 3.51.3 and backported to 3.44.6 and 3.50.7. Pin a fixed build when deploying WAL. [S5]
