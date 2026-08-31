# Architecture and deployment model

- SQLite is an in-process library with no database server process; the application opens the database file directly. [S10]
- A database is normally one local file, which makes packaging, transport, and per-device storage simple. [S10]
- Copying the library and creating a file is often the whole installation procedure. [S10]
- SQLite is a strong fit for local application state, embedded devices, caches, single-host services, and low-writer workloads. [S10]
- A client/server database is usually a better fit when many computers send SQL directly to one shared database over a network. [S10]
- Avoid network filesystems for shared SQLite databases because broken or slow file locking can cause poor performance or corruption. [S10]
- Use separate database files for independent domains or tenants when application-level sharding can reduce writer contention. [S10]
- The official SQLite GitHub repository is a mirror; the project's Fossil repository is the source of truth for check-ins. [S13]
