<contents>
This file has these sections, in order.
- data types
- primary keys
- foreign key indexes
- idempotent constraints
- identifiers
- partial indexes
- jsonb indexes
</contents>

<data_types>
The right column types prevent overflow, time zone bugs, and rounding errors.
- Use `bigint` for IDs, because `int` overflows at about 2.1 billion.
- Use `text` for strings unless a length limit is a real business rule. It performs the same as `varchar(n)`.
- Use `timestamptz` for points in time. A plain `timestamp` drops the time zone.
- Use `boolean` for flags and `numeric` for money, never strings or `float`.
- Use `text` with a `CHECK` constraint, or an enum type, for a fixed set of values.

This table follows those rules.

```sql
create table users (
  id bigint generated always as identity primary key,
  email text not null,
  created_at timestamptz not null default now(),
  is_active boolean not null default true,
  balance numeric(12,2) not null default 0
);
```
</data_types>

<primary_keys>
A single database uses `bigint generated always as identity`. `serial` still works, but identity columns are the SQL standard and the better choice for new tables. Use UUIDv7 when several systems create IDs or when IDs appear in URLs. PostgreSQL 18 has a built-in `uuidv7()` function, and older versions need an extension. Random UUIDv4 keys scatter inserts across the index and fragment it on large tables.

```sql
create table users (
  id bigint generated always as identity primary key
);

create table orders (
  id uuid default uuidv7() primary key
);
```
</primary_keys>

<foreign_key_indexes>
PostgreSQL does not index foreign key columns automatically. Without an index, joins on the column scan the table. An `ON DELETE CASCADE` or a delete on the parent table also scans the child table. Create the index on the referencing column, with `CONCURRENTLY` on an existing large table.

```sql
create index concurrently orders_customer_id_idx on orders (customer_id);
```

This query lists foreign key columns that no index has as its first column.

```sql
select
  c.conrelid::regclass as table_name,
  a.attname as fk_column
from pg_constraint c
join pg_attribute a on a.attrelid = c.conrelid and a.attnum = any(c.conkey)
where c.contype = 'f'
  and not exists (
    select 1 from pg_index i
    where i.indrelid = c.conrelid and i.indkey[0] = a.attnum
  );
```
</foreign_key_indexes>

<idempotent_constraints>
PostgreSQL has no `ADD CONSTRAINT IF NOT EXISTS`, and a migration that uses it fails with a syntax error. A `DO` block checks `pg_constraint` first and adds the constraint only when it is missing. The same block works for `CHECK`, `UNIQUE`, and foreign key constraints.

```sql
do $$
begin
  if not exists (
    select 1 from pg_constraint
    where conname = 'profiles_account_id_unique'
      and conrelid = 'public.profiles'::regclass
  ) then
    alter table public.profiles
      add constraint profiles_account_id_unique unique (account_id);
  end if;
end $$;
```
</idempotent_constraints>

<identifiers>
PostgreSQL folds unquoted identifiers to lowercase. A quoted mixed-case name such as `"firstName"` needs quotes in every query forever, and many tools fail on it. Use lowercase `snake_case` for tables and columns. Prisma creates quoted names from the model by default, so map them with `@@map` and `@map`. If a schema already has mixed-case names, a view can expose snake_case names during a migration.

```sql
create view users as
select "userId" as user_id, "firstName" as first_name from "Users";
```
</identifiers>

<partial_indexes>
A partial index holds only the rows that match its `WHERE` clause. It is smaller and faster for queries with that filter. The planner uses it only when the query repeats the same condition. A partial unique index also enforces uniqueness among live rows when soft-deleted rows share values.

```sql
create unique index users_active_email_idx on users (email)
where deleted_at is null;

select * from users where email = $1 and deleted_at is null;
```
</partial_indexes>

<jsonb_indexes>
A `jsonb` query without a matching index scans the whole table. A GIN index serves the containment operators `@>`, `?`, `?&`, and `?|`. The `jsonb_path_ops` operator class serves only `@>`, but the index is much smaller. A lookup of one key with `->>` needs an expression index instead.

```sql
create index products_attrs_gin on products using gin (attributes jsonb_path_ops);
select * from products where attributes @> '{"color": "red"}';

create index products_brand_idx on products ((attributes->>'brand'));
select * from products where attributes->>'brand' = 'Nike';
```
</jsonb_indexes>
