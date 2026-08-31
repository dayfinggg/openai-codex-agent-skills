# Performance and operations

- Measure before optimizing with request logs, Active Support instrumentation, database statistics, and representative load.
- Inspect slow relations with `EXPLAIN` and fix the query, index, cardinality, or pagination strategy that the plan exposes.
- Prevent N+1 queries with deliberate eager loading and use `strict_loading` in paths where lazy loading is forbidden.
- Avoid unbounded lists; paginate or batch both database work and response rendering.
- Add indexes for real filters, joins, and ordering, then verify that the database uses them.
- Use fragment or low-level caching for measured hot paths and choose keys that change when the data changes.
- Keep cache invalidation close to the write and avoid caching personalized or secret data in shared stores.
- Treat asynchronous query loading and concurrency settings as measured options, not automatic improvements.
- Watch database connection pool size, job worker concurrency, and external service limits together.
- Instrument important jobs and requests with stable names and useful tags, without putting secrets in query comments.
- Prefer a simple query and clear index over speculative denormalization or a cache that no one can invalidate.
- Recheck memory use when replacing a batch relation with arrays, hashes, or eager-loaded object graphs.
