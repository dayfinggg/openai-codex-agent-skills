<server_settings>
`ALTER SYSTEM`, `postgresql.conf` edits, and pooler config changes affect every session on the server. On a shared or production server they are production commands, so they need the user's confirmation first.
</server_settings>

<pooling>
Each PostgreSQL connection is a server process that costs memory. Without a pool, a burst of requests can exhaust `max_connections` and memory. Put a pooler such as PgBouncer between the app and the database. Many clients then share a small set of server connections. A starting pool size is about twice the CPU core count, tuned from measurements. This query shows how the current connections spread across states.

```sql
select count(*), state from pg_stat_activity group by state;
```

Transaction mode returns the server connection to the pool after each transaction and suits most apps. Session mode holds the connection for the whole client session. Session state such as `SET`, temporary tables, advisory locks, and `LISTEN` survives only in session mode. In transaction mode, use `SET LOCAL` or `set_config(name, value, true)` inside the transaction instead of `SET`.
</pooling>

<prepared_statements>
Prepared statements belong to one server connection, so transaction-mode pooling can route the next `EXECUTE` to a connection without them. Current PgBouncer tracks protocol-level named prepared statements in transaction mode when `max_prepared_statements` is above zero, and its default is 200. SQL-level `PREPARE` and `EXECUTE` still break under transaction pooling. Behind an older pooler, turn named statements off in the driver. postgres.js uses `prepare: false`, and the JDBC driver uses `prepareThreshold=0`.
</prepared_statements>

<timeouts>
An idle open transaction holds its locks and blocks vacuum, so it causes lock waits and table bloat. `idle_in_transaction_session_timeout` ends such sessions. `transaction_timeout`, added in PostgreSQL 17, limits the length of any transaction. `idle_session_timeout` ends idle sessions outside a transaction, but poolers react badly to closed connections. Apply it only to interactive roles. Set these per role or per database rather than for the whole server.

```sql
alter role app_user set idle_in_transaction_session_timeout = '30s';
alter role analyst set idle_session_timeout = '10min';
```

PgBouncer has its own idle settings in `pgbouncer.ini`.

```ini
server_idle_timeout = 60
client_idle_timeout = 300
```
</timeouts>

<privileges>
The application never connects as a superuser or as the table owner. Grant each role only the statements it needs. A role without `DELETE` cannot lose rows through a bug or an injection.

```sql
create role app_readonly nologin;
grant usage on schema public to app_readonly;
grant select on public.products, public.categories to app_readonly;

create role app_writer nologin;
grant usage on schema public to app_writer;
grant select, insert, update on public.orders to app_writer;
grant usage on sequence orders_id_seq to app_writer;

create role app_user login;
grant app_writer to app_user;

revoke all on schema public from public;
```

Set the login password outside migrations and source control, for example with psql's `\password`.
</privileges>

<row_level_security>
Row level security (RLS) lets the database filter rows per user or tenant. An app bug then cannot return another tenant's rows. Table owners skip RLS unless the table has `force row level security`. Superusers and roles with `BYPASSRLS` always skip it.

```sql
alter table orders enable row level security;
alter table orders force row level security;

create policy orders_tenant_policy on orders
  for all
  using (tenant_id = (select current_setting('app.tenant_id')::bigint));
```

The app sets the tenant inside each transaction. The third argument `true` limits the setting to the transaction. It then cannot leak to the next client of a pooled connection.

```sql
begin;
select set_config('app.tenant_id', $1, true);
select * from orders;
commit;
```

A function call in a policy can run once per row. Wrap a call that reads no row columns in `(select ...)`, as above. The planner then runs it once per query. Index every column that a policy filters on.

A `security definer` function runs with its owner's privileges and skips RLS on the tables it reads. Such a function suits a membership lookup inside a policy, but it must check the caller's identity itself. Keep it in a separate schema, and fix its `search_path`. Revoke `EXECUTE` from `PUBLIC` and grant it only to the roles whose queries use the policy. The policy calls the function as the querying role.

```sql
create or replace function private.is_team_member(p_team_id bigint)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.team_members
    where team_id = p_team_id
      and user_id = current_setting('app.user_id')::bigint
  );
$$;

revoke execute on function private.is_team_member(bigint) from public;
grant usage on schema private to app_user;
grant execute on function private.is_team_member(bigint) to app_user;

create policy team_orders_policy on orders
  using (private.is_team_member(team_id));
```
</row_level_security>
