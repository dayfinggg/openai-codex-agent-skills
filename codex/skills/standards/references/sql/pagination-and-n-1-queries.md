# Pagination and N+1 queries

- Use a unique, deterministic `ORDER BY`, including a stable tie-breaker, for every page boundary.
- `LIMIT` and `OFFSET` are adequate for shallow pages, administrative screens, or small stable result sets.
- Large offsets still require the server to compute and discard skipped rows, and concurrent inserts can make pages drift.
- Prefer keyset or seek pagination for deep pages and feeds: filter on the last seen ordered key and fetch the next bounded batch.
- For a compound order, carry the complete cursor, apply the matching tuple or lexicographic predicate, and keep the cursor opaque to clients.
- Keyset pagination is faster and more stable for sequential navigation, but it does not directly jump to arbitrary page numbers.
- Define whether a feed uses a live view, a transaction snapshot, or a fixed cutoff timestamp.
- An N+1 pattern issues one parent query and then one related query per returned row.
- Replace N+1 with a join, an `IN` batch, a set-based aggregate, or deliberate eager loading.
- Choose the shape that preserves the requested grain; one huge join can multiply rows and cost more than two bounded batches.
- Detect N+1 with query logs, per-request query counts, tracing, and regression tests with more than one parent row.
- The PyCon talk in Sources demonstrates identifying N+1 and using aggregation or lateral joins in ORM-backed applications.
