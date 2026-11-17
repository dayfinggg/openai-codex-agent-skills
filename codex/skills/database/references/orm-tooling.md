# ORM and migration tooling

Read this when a task upgrades an ORM, adapter, migration CLI, or query generator, or when the generated SQL differs from expectations. These tools change independently. Check the project's lockfile, the installed CLI help, and official documentation for each installed version before relying on package or command behavior.

- Check the CLI, runtime library, client generator, database adapter, and engine versions as separate components. Do not assume a global or package-manager `latest` command matches the application's pinned version.
- Locate which config supplies the runtime connection and which supplies the migration connection. Keep migrations and administrative dumps on the direct connection where transaction pooling would break session-dependent behavior.
- Generate and read the exact SQL or schema change before applying it. Inspect rename operations, default values, indexes, constraints, transactions, and implicit data-loss prompts. A rename represented as drop and add can lose data.
- Do not run schema-push or reset commands against a shared database as a substitute for the reviewed migration path. Read the command's installed help to identify implicit reset, seed, generation, or drift behavior.
- Confirm how the selected adapter handles TLS validation, connection limits, timeouts, prepared statements, and transaction pooling. Fix trust configuration instead of disabling certificate checks.
- Test the generated migration on a disposable copy running the target engine version. Record every generated artifact that the project expects to commit; never edit generated migration snapshots by hand unless the tool's current documentation requires it.

The main database skill already covers parameterized SQL, migration locks, transaction boundaries, and ORM-specific migration traps. Use those sections as well.
