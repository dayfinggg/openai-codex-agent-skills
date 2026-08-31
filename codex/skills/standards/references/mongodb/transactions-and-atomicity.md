# Transactions and atomicity
A write affecting one document, including embedded subdocuments, is atomic.
Prefer a model that keeps an invariant in one document when that is practical.
Use a multi-document transaction when an invariant truly spans documents, collections, databases, or shards.
Transactions require a replica set or sharded cluster. Standalone deployments do not support them.
A committed transaction makes all its changes visible, while an aborted transaction exposes none of them.
During a cross-shard commit, outside `local` reads can briefly see some writes before all writes are visible.
Distributed transactions generally cost more than single-document writes and do not replace schema design.
Use the driver callback or convenient transaction API so transient transaction and unknown commit results can be retried. Assume the callback may run more than once. Keep it idempotent and do not perform unguarded external side effects inside it.
Pass the same session to every operation in the transaction.
Set read concern, write concern, and read preference at the transaction level.
Transactions containing reads must use primary read preference and route all operations to one member.
Keep transactions short, bounded, and abort them on every error.
The default transaction lifetime is less than one minute, and long transactions increase cache pressure and conflicts.
Each transaction oplog entry still must fit within the 16 MiB BSON limit.
Read [transactions](https://www.mongodb.com/docs/manual/core/transactions/) and [production considerations](https://www.mongodb.com/docs/manual/core/transactions-production-consideration/) for deployment limits.
