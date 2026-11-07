<n_plus_one>
An N+1 pattern runs one query per item in a loop, so 100 users cost 101 round trips. Collect the IDs and query once with an array parameter, or join the tables. The application passes the IDs as one array value.

```sql
select * from orders where user_id = any($1::bigint[]);

select u.id, u.name, o.*
from users u
left join orders o on o.user_id = u.id
where u.active = true;
```
</n_plus_one>

<keyset_pagination>
`OFFSET` pagination reads and discards every skipped row, so deep pages get slower. Keyset pagination starts after the last row of the previous page and uses the index at any depth. The cursor must include every sort column, with a unique column such as `id` last.

```sql
select * from products order by id limit 20;
select * from products where id > $1 order by id limit 20;

select * from products
where (created_at, id) > ($1, $2)
order by created_at, id
limit 20;
```
</keyset_pagination>

<upsert>
A `SELECT` followed by an `INSERT` races, because two requests can both find nothing and both insert. `INSERT ... ON CONFLICT` does the check and the write in one atomic statement. It needs a unique constraint or index on the conflict columns.

```sql
insert into settings (user_id, key, value)
values ($1, $2, $3)
on conflict (user_id, key)
do update set value = excluded.value, updated_at = now()
returning *;

insert into page_views (page_id, user_id)
values ($1, $2)
on conflict (page_id, user_id) do nothing;
```
</upsert>

<short_transactions>
A transaction holds its locks until it ends, so keep it short. Make HTTP calls, file I/O, and validation before `BEGIN`, never between `BEGIN` and `COMMIT`. A conditional `UPDATE` with `RETURNING` often replaces a `SELECT ... FOR UPDATE` followed by an update.

```sql
begin;
update orders
set status = 'paid', payment_id = $1
where id = $2 and status = 'pending'
returning *;
commit;
```

`SET LOCAL statement_timeout = '5s'` inside a transaction stops a runaway statement in that transaction only.
</short_transactions>

<deadlocks>
A deadlock happens when two transactions lock the same rows in opposite order. Lock the rows in one consistent order, usually by primary key, before you update them. A single statement that updates all the rows also takes its locks together.

```sql
begin;
select * from accounts where id in (1, 2) order by id for update;
update accounts set balance = balance - 100 where id = 1;
update accounts set balance = balance + 100 where id = 2;
commit;
```

`pg_stat_database.deadlocks` counts deadlocks per database. Turn on `log_lock_waits` to log every lock wait longer than `deadlock_timeout`.
</deadlocks>

<queues>
Workers that claim jobs with plain `FOR UPDATE` wait on each other. `FOR UPDATE SKIP LOCKED` lets each worker take the next unlocked row instead. This statement claims one job and marks it in one atomic step.

```sql
update jobs
set status = 'processing', worker_id = $1, started_at = now()
where id = (
  select id from jobs
  where status = 'pending'
  order by created_at
  limit 1
  for update skip locked
)
returning *;
```
</queues>

<explain>
`EXPLAIN ANALYZE` runs the query and shows the real plan, row counts, and timings. PostgreSQL 18 adds buffer counts to `EXPLAIN ANALYZE` by default, and older versions need `BUFFERS`. The statement really executes, so wrap a write in a transaction that ends with `ROLLBACK`.

```sql
explain (analyze, buffers)
select * from orders where customer_id = 123 and status = 'pending';
```

Some signs in the plan point to a fix.
- A `Seq Scan` on a large table with many `Rows Removed by Filter` points to a missing index.
- Many more buffers `read` than `hit` means the data was not in cache.
- A `Sort Method: external merge` means the sort spilled to disk because `work_mem` is too low.
- Estimated rows far from actual rows mean stale statistics, so run `ANALYZE`.

The `pg_stat_statements` extension finds the queries that cost the most time in total. It must be listed in `shared_preload_libraries` before `create extension` works.

```sql
select calls,
       round(total_exec_time::numeric, 2) as total_ms,
       round(mean_exec_time::numeric, 2) as mean_ms,
       query
from pg_stat_statements
order by total_exec_time desc
limit 10;
```
</explain>

<statistics>
The planner picks plans from table statistics, and stale statistics lead to bad plans. Autovacuum updates them, but it can lag after a bulk load or a large backfill. Run `ANALYZE` on the table after such a change. A table with heavy churn can get lower autovacuum thresholds than the 20 percent and 10 percent defaults.

```sql
analyze orders;

alter table orders set (
  autovacuum_vacuum_scale_factor = 0.05,
  autovacuum_analyze_scale_factor = 0.02
);

select relname, last_autovacuum, last_analyze, last_autoanalyze
from pg_stat_user_tables
order by last_analyze nulls first;
```
</statistics>

<bulk_loads>
Single-row inserts cost one round trip each. Send many rows in one multi-row `INSERT`, about 1000 rows per statement. For large imports, `COPY` is the fastest path. `COPY ... FROM 'file'` reads a file on the database server, while psql's `\copy` reads a file on the client.

```sql
insert into events (user_id, action) values
  (1, 'click'),
  (1, 'view'),
  (2, 'click');

copy events (user_id, action, created_at)
from stdin with (format csv, header true);
```

Load an import into a staging table first when it may hold bad rows. Validate it there, then move the rows into the real table in one statement.
</bulk_loads>
