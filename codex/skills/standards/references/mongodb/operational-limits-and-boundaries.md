# Operational limits and boundaries
One BSON document is limited to 16 MiB, including embedded data and arrays.
MongoDB supports at most 100 levels of BSON nesting.
A collection can have at most 64 indexes, and a compound index can have at most 32 fields.
The default `indexMaxNumGeneratedKeysPerDocument` limit is 100,000 generated keys.
An aggregation pipeline can contain at most 1000 stages.
Blocking aggregation stages use a 100 MiB memory threshold before disk spilling or failure, depending on configuration.
Collections and databases have no MongoDB hard size limit, but filesystems, hardware, and working-set memory remain limits.
Use GridFS or another object store for large binary payloads instead of forcing them into one document.
In sharded collections, a unique index generally must include the full shard key as a prefix.
Do not use a monotonically increasing shard key for high insert throughput without understanding the hot-chunk effect.
See [MongoDB limits and thresholds](https://www.mongodb.com/docs/manual/reference/limits/) for hard limits and deployment-specific restrictions.
