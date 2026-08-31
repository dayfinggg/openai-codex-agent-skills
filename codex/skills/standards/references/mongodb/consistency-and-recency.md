# Consistency and recency
Read concern controls the consistency and isolation level of reads.
`local` can return data that is not majority committed and may later roll back.
`majority` returns data acknowledged by a majority and durable under the deployment’s majority-journal settings.
`snapshot` provides a point-in-time view in supported operations and transactions.
`linearizable` is for a uniquely identified single-document read on the primary and can wait, so use `maxTimeMS`.
Read concern alone does not make a secondary current.
Write concern controls when the server acknowledges a write, and `w: "majority"` is the usual durability choice.
`w: 1` can acknowledge before replication and can roll back after primary failure.
In MongoDB 8.0 and later, majority writes can be acknowledged after durable oplog writes while a secondary still applies the change asynchronously.
If a read must follow a write across members, use a causally consistent session with majority reads and writes.
Only one thread should use a causally consistent session at a time.
Non-primary read preferences may return stale data. Set `maxStalenessSeconds` when bounded staleness is acceptable.
See [read concern](https://www.mongodb.com/docs/manual/reference/read-concern/), [write concern](https://www.mongodb.com/docs/manual/reference/write-concern/), [read isolation](https://www.mongodb.com/docs/manual/core/read-isolation-consistency-recency/), and [read preference](https://www.mongodb.com/docs/manual/core/read-preference/).
