# Database and ORM upgrades

Use this workflow for a database engine, connection pooler, driver, ORM, or migration-tool upgrade. Product versions, support windows, and security advisories change, so check the official release notes for the installed and target versions instead of copying an old version table.

- Record the current engine, extensions, pooler, drivers, ORM, migration tool, and provider. Confirm the supported upgrade path and read release notes for every intervening major version.
- Check breaking changes to SQL behavior, defaults, authentication, TLS, extensions, collations, replication, generated SQL, schema formats, and command-line behavior. Confirm that client and server versions are compatible.
- Restore a recent backup to an isolated copy, then rehearse the upgrade and the application's migrations there. Test representative reads and writes, background jobs, authentication, and backup restoration.
- Plan capacity, disk space, maintenance time, active transactions, connection pools, and replication lag before changing a shared environment. Use the project's approved staging checks and rollback path.
- Decide whether rollback requires the prior binaries and data format to remain compatible, or requires restoring a backup. Do not assume that reinstalling an older version can read data upgraded by a newer version.
- Upgrade one authorized environment at a time. Verify server and extension versions, application queries, migration status, replication, error rates, and a usable backup before continuing.
- Check current security advisories from the product or provider and prioritize supported security updates. Do not rely on dated CVE or end-of-life lists copied into a skill.
