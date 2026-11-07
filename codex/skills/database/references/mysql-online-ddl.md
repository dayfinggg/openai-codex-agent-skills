<algorithms>
Some `ALTER TABLE` statements block writes for their whole run. The algorithm decides how much the table stays available, as this table shows.

| Algorithm | What happens | DML during the change |
|---|---|---|
| `INSTANT` | Changes metadata only | Allowed |
| `INPLACE` | Rebuilds or changes the table in the background | Usually allowed |
| `COPY` | Copies the full table to a temporary table | Blocked |

MySQL picks the fastest algorithm available. State the algorithm explicitly, so the statement fails instead of silently falling back to `COPY`.

```sql
ALTER TABLE orders ADD COLUMN note VARCHAR(255) DEFAULT NULL, ALGORITHM=INSTANT;
```
</algorithms>

<instant_operations>
On MySQL 8.4 and 9.x, `INSTANT` is the default for adding and dropping a column. It also covers these changes.
- Adding a column at any position.
- Dropping a column.
- Renaming a column that keeps its type and nullability.
- Setting or dropping a column default.
- Adding `ENUM` or `SET` members at the end of the list, when the storage size stays the same.

Each instant add or drop creates a new row version. A table allows 64 row versions, or 255 from MySQL 9.1. After that limit, instant add and drop fail with error 4092 until a rebuild with `COPY`, `INPLACE`, or `OPTIMIZE TABLE`. `INFORMATION_SCHEMA.INNODB_TABLES.TOTAL_ROW_VERSIONS` shows the current count.

Several common changes are not instant. Adding a secondary index runs `INPLACE` and allows concurrent DML. Dropping an index runs `INPLACE` and is usually metadata-only. Growing a `VARCHAR` runs `INPLACE` only while it stays on one side of the 256-byte boundary. A column type change needs `COPY`.
</instant_operations>

<lock_levels>
The `LOCK` clause states how much concurrency the change must allow.
- `LOCK=NONE` allows concurrent reads and writes.
- `LOCK=SHARED` allows reads only.
- `LOCK=EXCLUSIVE` blocks reads and writes.
- `LOCK=DEFAULT` lets the server choose the most concurrency it can give.

Request `LOCK=NONE` together with an explicit `ALGORITHM`. A conflict then shows up as an error before the change starts.
</lock_levels>

<large_tables>
An `INPLACE` change still takes a short exclusive metadata lock at its start and at its end. The final step waits for every open transaction on the table to finish. A long-running transaction can therefore block the DDL, and all queries queue behind it. Set `lock_wait_timeout` low for the session, as the main skill describes.

Tables with millions of rows need an online schema change tool for blocking changes.
- `pt-online-schema-change` builds a shadow table and syncs it with triggers.
- `gh-ost` builds a shadow table and syncs it from the binlog without triggers. It suits tables with heavy writes.
</large_tables>

<replication>
DDL replicates to replicas and runs there again, which can cause replication lag. A `COPY` or rebuilding `INPLACE` change causes the most lag. An `INSTANT` change finishes fast and adds little lag. An `INPLACE` change can still cause metadata lock waits on replicas while it applies.

Never run `ALTER TABLE` on a large production table without checking the algorithm first. A surprise `COPY` on a 100M-row table can block writes for hours.
</replication>
