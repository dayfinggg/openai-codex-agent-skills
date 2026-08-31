# Migrations and upgrades

- Treat each schema migration as a versioned, reviewed change tested on a copy containing production-shaped data.
- `ALTER TABLE` may use `COPY`, `INPLACE`, or `INSTANT`; `COPY` blocks concurrent DML, while the other algorithms have different lock and rebuild behavior. [M14]
- Specify `ALGORITHM=INSTANT` or `ALGORITHM=INPLACE` when the migration must fail rather than silently fall back to a more disruptive operation. [M14]
- Check metadata locks, available disk space, replica lag, foreign-key dependencies, and forward-fix procedures before a large alteration.
- Add nullable columns or compatible defaults before deploying application code that writes them, then backfill in bounded batches.
- Separate destructive cleanup from an expand-and-contract rollout when old application versions may still run.
- MySQL documents in-place, logical dump/load, and replication-topology paths for server upgrades. [M15]
- Run the upgrade checker, test and benchmark the application, rehearse the final procedure, and verify a restorable backup first. [M15]
- Do not skip a required major-version path merely because the binaries appear compatible. [M15]
- Pin an LTS or innovation release track deliberately and document the exact server and connector versions. [M16]
- The CI-backed `sqldef` example exposes `mysqldef` dry-run and apply commands; review generated DDL and test it on the target data before applying. [G1]
