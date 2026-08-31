# Types

Choose a type that expresses the domain and has enough range for the expected lifetime of the data.
Use `integer` for ordinary bounded counts and `bigint` when the range may exceed 32 bits or IDs cross database boundaries.
Use `numeric(precision, scale)` for exact monetary or decimal quantities.
Use floating-point types only when approximation is part of the domain contract.
Specify numeric precision and scale when rounding and bounds must be explicit.
Use `text` unless a length limit is a business invariant; `varchar(n)` provides no performance advantage over `text`.
Avoid `char(n)` for normal strings because blank padding adds storage and can make it slower.
Use `timestamptz` for an instant; PostgreSQL stores it in UTC and renders it in the session time zone.
Use `timestamp without time zone` only when the value is intentionally a wall-clock value without an instant.
Store the relevant zone separately when a future local-time reconstruction is required.
Avoid `time with time zone` unless legacy interoperability requires it.
Use `uuid` when identifiers must be globally unique across independent writers.
PostgreSQL 18 provides native UUIDv4 and UUIDv7 generation, but a `uuid` column still needs a `PRIMARY KEY` or `UNIQUE` constraint.
Prefer identity columns over legacy `serial` for new generated keys, and choose `ALWAYS` or `BY DEFAULT` deliberately.
Identity generation does not guarantee uniqueness because sequences can be reset or explicit values can be supplied.
Use domains for reusable scalar invariants and range types for intervals with containment or overlap semantics.
Use an enum only when values are stable and removal is not part of the lifecycle; use a lookup table when values need metadata or flexible changes.
