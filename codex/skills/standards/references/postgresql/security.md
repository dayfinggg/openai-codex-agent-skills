# Security

Use separate non-login owner, application, migration, read-only, and operational roles where their capabilities differ.
Never use a superuser for application traffic, and avoid `CREATEROLE`, `CREATEDB`, `REPLICATION`, `BYPASSRLS`, and `ALTER SYSTEM` unless required.
Grant only the table, column, sequence, schema, function, and database privileges each role needs.
Audit default privileges and revoke accidental `PUBLIC` access, especially `CREATE` on `public` in upgraded clusters.
Treat `search_path` as a security boundary; remove schemas writable by untrusted users or schema-qualify sensitive references.
Remember that `pg_hba.conf` uses the first matching record and has no fall-through after an authentication failure.
Prefer `hostssl` rules with certificate validation or SCRAM-SHA-256 for remote password authentication.
Avoid clear-text `password` authentication unless the connection is protected by TLS and policy requires it.
Enable TLS, protect the server key, and use a CA-signed certificate in production.
Enable row-level security only with explicit `USING` and `WITH CHECK` policies for every required command.
Test RLS as table owner, ordinary role, superuser-equivalent role, and through backup or reporting paths because owners and bypass roles normally bypass RLS.
Remember that RLS does not replace table privileges and that referential-integrity checks can bypass RLS.
Treat `SECURITY DEFINER` functions as privileged entry points, lock their `search_path`, and restrict their execute privilege.
Review extension scripts, casts, triggers, and foreign-key privileges as code-execution surfaces.
