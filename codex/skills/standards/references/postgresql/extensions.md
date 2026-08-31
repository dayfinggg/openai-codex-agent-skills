# Extensions

Prefer a PostgreSQL extension over a pile of untracked functions, types, operators, and index support objects.
Install only extensions that have been reviewed for source, privileges, maintenance, and upgrade compatibility.
Use `CREATE EXTENSION ... SCHEMA ...` with a dedicated schema where the extension supports relocation.
Do not grant untrusted users `CREATE` on an extension's installation schema.
Treat a superuser extension installation script as executable privileged code and inspect it before installation.
Do not mark an extension trusted merely to simplify deployment; trusted scripts require stronger security review.
Keep extension member changes in versioned update scripts and apply them with `ALTER EXTENSION UPDATE`.
Do not patch an extension member only in the live database because `pg_dump` will not preserve an untracked definition change.
Schema-qualify extension references and use a secure `search_path` in privileged functions and scripts.
Use `SET search_path = trusted_schema, pg_temp` for `SECURITY DEFINER` functions, then revoke default `PUBLIC` execute when access must be restricted.
