# Row-level security edge cases

Read this with [postgres-operations.md](postgres-operations.md) when row-level security (RLS) enforces tenant boundaries. The PostgreSQL 18 [row-security documentation](https://www.postgresql.org/docs/18/ddl-rowsecurity.html) and [policy reference](https://www.postgresql.org/docs/18/sql-createpolicy.html) define the policy behavior.

- Test as the same non-owner application role used by the service. Table owners usually bypass RLS, and superusers or roles with `BYPASSRLS` always bypass it unless the table forces row security.
- Check `SELECT`, `INSERT`, `UPDATE`, `DELETE`, and `RETURNING` separately. An update or delete can silently affect zero rows when its target row is not visible under the applicable policy. A `WITH CHECK` failure rejects the new row.
- Keep tenant identity in tenant-scoped unique keys. Unique and foreign-key checks are not filtered like ordinary row reads, so constraint failures can reveal that another tenant's value exists.
- Set application-specific context inside each transaction with a transaction-local setting such as `set_config('app.tenant_id', value, true)`. Test transaction-pool reuse and rollback paths. Do not assume an arbitrary session setting is isolated between clients.
- A view normally uses the view owner's rights on its base tables. If RLS must follow the caller, confirm that the installed PostgreSQL version supports `security_invoker` and apply it explicitly. See the [PostgreSQL 18 `CREATE VIEW` reference](https://www.postgresql.org/docs/18/sql-createview.html).
- A `SECURITY DEFINER` function can bypass RLS through its owner. Keep a fixed safe `search_path`, revoke `EXECUTE` from `PUBLIC`, grant it narrowly, and verify the function checks the caller's identity.

Cover allowed and denied tenant reads, cross-tenant writes, row counts, returned rows, and uniqueness conflicts in tests. Do not rely on a successful query run as the owner.
