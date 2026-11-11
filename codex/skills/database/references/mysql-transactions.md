<contents>
This file has these sections, in order.
- isolation levels
- row locks
- deadlocks
- connections
</contents>

<isolation_levels>
Keep the InnoDB default of `REPEATABLE READ`. It is the most tested level and prevents phantom reads. Change the level only per session and only with a measured reason.

```sql
SELECT @@transaction_isolation;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

With the default `autocommit=1`, each statement is its own transaction. With `autocommit=0`, a transaction lasts until `COMMIT` or `ROLLBACK`.

Plain `SELECT` statements are consistent reads from an MVCC snapshot. They take no locks and do not block writers. `SELECT ... FOR UPDATE`, `SELECT ... FOR SHARE`, `UPDATE`, and `DELETE` are locking reads.

The four levels behave differently.
- `REPEATABLE READ` takes its snapshot at the first read, and later plain reads in the transaction see that snapshot. Locking reads use next-key locks, which cover the row and the gap before it. A unique index search with a unique condition locks only the index record. It suits OLTP, check-then-insert logic, financial logic, and consistent reports.
- `READ COMMITTED` takes a fresh snapshot for each `SELECT` and uses record locks only. Gap locks remain only for foreign key and duplicate key checks. It gives more concurrency but allows phantoms. Use it per session for confirmed gap-lock deadlocks or contended bulk imports.
- `SERIALIZABLE` turns plain `SELECT` statements into `SELECT ... FOR SHARE` when autocommit is off, which causes heavy contention. Prefer explicit `SELECT ... FOR UPDATE` at `REPEATABLE READ`.
- `READ UNCOMMITTED` allows dirty reads and has no valid production use.

A transaction that mixes locking statements and plain `SELECT` statements can see two states. The locking statements read the current rows, while the plain reads see the snapshot. Never switch the isolation level globally, because check-then-insert code breaks under `READ COMMITTED`. Use `INSERT ... ON DUPLICATE KEY UPDATE` or `FOR UPDATE` in such code.
</isolation_levels>

<row_locks>
InnoDB locks rows, but the locked range is often wider than the rows a statement touches. Under `REPEATABLE READ`, a range scan with a locking read locks every gap in the range. In this example, another session that inserts `id = 7` waits until the lock is released.

```sql
SELECT * FROM orders WHERE id BETWEEN 5 AND 10 FOR UPDATE;
```

A locking read on a row that does not exist still takes a gap lock. Concurrent inserts into that gap then wait.

```sql
SELECT * FROM orders WHERE id = 999 FOR UPDATE;
```

An `UPDATE` or `DELETE` whose `WHERE` column has no index scans the table and locks every row it examines. InnoDB never escalates row locks to a table lock, but locking all rows has the same effect. Index the `WHERE` columns of every `UPDATE` and `DELETE`.

```sql
UPDATE orders SET processed = 1 WHERE status = 'pending';
CREATE INDEX idx_status ON orders (status);
```

`SELECT ... FOR SHARE` takes shared locks. Several sessions can share a lock on one row. An `UPDATE` of that row waits for all of them. Gap locks still apply to shared locks under `REPEATABLE READ`.

`INSERT ... ON DUPLICATE KEY UPDATE` takes an exclusive lock on a duplicate row. It locks the index record for a duplicate primary key and takes a next-key lock for a duplicate unique key. Concurrent upserts on nearby keys therefore often deadlock on gap locks.
</row_locks>

<deadlocks>
InnoDB detects deadlocks and rolls back one transaction, usually the one with fewer changed rows. Deadlocks are normal in concurrent systems, so the goal is fewer of them, not zero. These causes are the most common.
- Transactions touch the same rows in opposite order. Access rows in one consistent order, usually by primary key.
- Next-key locks under `REPEATABLE READ` conflict. Narrow the lock scope, or use `READ COMMITTED` per session.
- An `UPDATE` or `DELETE` without an index on its `WHERE` column locks far more rows than it changes.
- Concurrent inserts contend on the auto-increment lock. The default `innodb_autoinc_lock_mode=2` gives the most concurrency, so check that the server has not set a lower value.

`READ COMMITTED` removes many gap-lock deadlocks. It does not prevent deadlocks from opposite ordering or missing indexes.

These queries show the last deadlock and the current lock waits.

```sql
SHOW ENGINE INNODB STATUS\G

SELECT object_name, lock_type, lock_mode, lock_status, lock_data
FROM performance_schema.data_locks WHERE lock_status = 'WAITING';

SELECT w.requesting_thread_id, w.blocking_thread_id,
       l.lock_type, l.lock_mode, l.lock_data
FROM performance_schema.data_lock_waits w
JOIN performance_schema.data_locks l ON w.requested_lock_id = l.lock_id;
```

The `LATEST DETECTED DEADLOCK` section of the status output shows both transactions and their locks. Keep transactions short, do I/O outside them, and use `FOR UPDATE` sparingly. Split large updates into batches.

An application can retry a transaction that failed with error 1213. Retry only when the whole transaction is idempotent, including side effects outside the database. This SQLAlchemy helper retries with exponential backoff.

```python
import time

from sqlalchemy.exc import OperationalError


def execute_with_retry(engine, fn, max_retries=3):
    for attempt in range(max_retries):
        try:
            with engine.begin() as conn:
                return fn(conn)
        except OperationalError as e:
            if e.orig.args[0] == 1213 and attempt < max_retries - 1:
                time.sleep(0.05 * 2**attempt)
                continue
            raise
```
</deadlocks>

<connections>
Each MySQL connection costs memory for its buffers. Too many connections cause out-of-memory errors or `Too many connections` errors. The default `max_connections` is 151. Raise it only with evidence, because each connection adds memory and contention.

```sql
SHOW VARIABLES LIKE 'max_connections';
SHOW STATUS LIKE 'Max_used_connections';
SHOW STATUS LIKE 'Threads_connected';
```

Start with a small pool, and tune it from `Threads_connected` and `Max_used_connections`. Connections beyond the CPU-bound optimum add context switches without more throughput. MySQL runs one thread per connection by default, so `max_connections` also sets the thread count. Raise `thread_cache_size` when connections open and close often.

`wait_timeout` and `interactive_timeout` close idle connections, and both default to 8 hours. An idle connection with an open transaction keeps its locks until that timeout, so commit or roll back promptly. Set an application-level transaction timeout as well. `net_read_timeout` defaults to 30 seconds and `net_write_timeout` to 60 seconds. Raise them only for errors such as `Lost connection to MySQL server during query` in bulk transfers. `SET GLOBAL` changes every new session on the server, so it needs the user's confirmation on a shared server. These statements close idle connections after 5 minutes.

```sql
SET GLOBAL wait_timeout = 300;
SET GLOBAL interactive_timeout = 300;
```

Several mistakes exhaust connections.
- ORM pools are per process, so total connections equal the pool size times processes times servers.
- PHP and CGI models open a new connection per request without a pool. Use persistent connections or a proxy such as ProxySQL.
- All servers reconnect at once after a deploy. Stagger restarts, warm pools gradually, or put a proxy in front.

Prepared statements cut parsing work and keep values out of the SQL text. They belong to one connection, though some pools and drivers cache them. A proxy such as ProxySQL helps when several services share a database or when reads and writes need routing. It also helps when connection demand exceeds a safe `max_connections`.
</connections>
