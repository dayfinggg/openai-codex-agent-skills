# Connection handling

Size connection pools from measured concurrency and memory, and keep the aggregate active sessions below `max_connections`.
Do not raise `max_connections` as a substitute for pooling or query latency control because PostgreSQL allocates more shared resources as it rises.
Reserve emergency connection capacity for administrators and monitoring.
Use a pool that resets session state, rolls back failed transactions, and discards broken connections before reuse.
Never return a connection to the pool while it is inside a transaction or has session-local settings that the next request can inherit.
Set application-appropriate statement, lock, transaction, and idle-in-transaction timeouts.
Use `pg_stat_activity` with an application name to monitor active, idle, waiting, and long-running sessions.
Restrict `listen_addresses` to required interfaces and use network policy in addition to database authentication.
Configure TCP keepalives or connection checks when failure detection must be bounded by an operational requirement.
