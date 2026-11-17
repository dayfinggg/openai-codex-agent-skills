# PostgreSQL versioned features

Treat this page as a dated index, not as an installed-server guarantee. Check the server version, the official documentation for that exact release, and the managed provider's supported features before using recent syntax. A feature described on a development-version page is not evidence that a released server supports it.

The PostgreSQL 18 documentation describes `OLD` and `NEW` values in `RETURNING` for `INSERT`, `UPDATE`, `DELETE`, and `MERGE`, and the built-in `uuidv7()` function. Check the [PostgreSQL 18 `RETURNING` documentation](https://www.postgresql.org/docs/18/dml-returning.html) and the [PostgreSQL 18 UUID functions](https://www.postgresql.org/docs/18/functions-uuid.html).

The PostgreSQL 19 documentation checked on 2026-11-17 describes `INSERT ... ON CONFLICT ... DO SELECT`, `REPACK`, and `WAIT`, while also marking version 19 as development and unsupported. Do not use those features on a stable server unless the installed version and provider explicitly support them. Check the [PostgreSQL 19 `INSERT` reference](https://www.postgresql.org/docs/19/sql-insert.html) and [PostgreSQL 19 release notes](https://www.postgresql.org/docs/19/release-19.html) again before relying on release status.

When a feature affects data definition or locking, verify its transaction behavior, required privileges, provider support, and interaction with the project's migration runner. Test the generated SQL on a disposable database running the target version.
