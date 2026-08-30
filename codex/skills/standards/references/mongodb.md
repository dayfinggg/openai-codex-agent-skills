# MongoDB document modeling reference
This reference reflects the current MongoDB manual pages reviewed on 2026-08-30.
Version-specific behavior is marked because server and driver versions matter.
## Start with the workload
MongoDB collections are flexible by default: documents need not share fields or field types.
That flexibility does not remove the need for an intentional model.
Start with the application’s read, write, update, sort, join, and archival paths.
Record expected frequency, latency, cardinality, growth, and read-to-write ratio.
The core rule is to store data that the application accesses together.
Design a document around a useful unit of work, not around every domain noun.
Use the [data-modeling overview](https://www.mongodb.com/docs/manual/data-modeling/) and [best-practices guide](https://www.mongodb.com/docs/manual/data-modeling/best-practices/) as the starting checklist.
MongoDB supports one-to-one, one-to-many, and many-to-many relationships.
Choose embedding or referencing separately for each relationship.
A collection may intentionally contain polymorphic document shapes when that helps the workload.
Plan the model before production scale, then measure representative queries and revise it.
## Embedding versus references
Embedding stores related documents or arrays inside one BSON document.
It usually gives one read, fewer round trips, and one-document atomic updates.
Embed `has-a`, `contains`, or bounded one-to-many data that is normally read with its parent.
Embedding also fits data that is updated or archived with the parent.
Embed when the child has no useful life outside the parent context.
Embedding can duplicate immutable, historical, or deliberately stale-tolerant values.
Duplicate only fields whose update cost and consistency policy are understood.
References store identifiers that the application or an aggregation resolves later.
Reference when the child is independently queried, updated, archived, or owned.
Reference when embedding would duplicate frequently changing data.
Reference complex many-to-many relationships and large hierarchical data sets.
Use an array of child references for a bounded or moderate one-to-many relationship whose children stand alone.
Use a parent reference on each child for one-to-squillions relationships such as logs or events.
Use two-way references only when both access paths justify the maintenance cost.
Two-way references require coordinated updates and are not atomic across documents without a transaction.
References add a second read, an application join, or a `$lookup`.
Index the foreign join field, and reduce the number of local documents entering a `$lookup`.
MongoDB warns that excessive `$lookup` use can be slower than an embedded model.
The [reference guide](https://www.mongodb.com/docs/manual/data-modeling/referencing/) and [`$lookup` reference](https://www.mongodb.com/docs/manual/reference/operator/aggregation/lookup/) describe the tradeoffs.
Denormalization is a workload choice, not a default mandate.
Favor it for frequently read, rarely updated values when some staleness is acceptable.
Use transactions, application code, or triggers when duplicated data must remain synchronized.
The MongoDB team’s [six rules of thumb](https://www.mongodb.com/company/blog/mongodb/6-rules-of-thumb-for-mongodb-schema-design) describe one-to-few, one-to-many, and one-to-squillions choices.
The [MongoDB University relationship video](https://learn.mongodb.com/learn/course/relational-to-document-model/relational-to-document-model/design-relationships?client=customer&page=2) frames the decision around simplicity, access, updates, cardinality, size, growth, and individuality.
## Schema validation
Flexible schema means the server does not enforce one shape unless you configure it.
Use per-collection validation after the application’s intended structure is known.
Use `$jsonSchema` with `bsonType`, `required`, `properties`, ranges, enums, array bounds, and descriptions.
MongoDB implements JSON Schema draft 4 with MongoDB-specific BSON types and differences.
Combine `$jsonSchema` with query expressions or `$expr` for cross-field rules.
Validation is a database guardrail, not a replacement for API input validation or authorization.
See [schema validation](https://www.mongodb.com/docs/manual/core/schema-validation/) and [specify JSON Schema](https://www.mongodb.com/docs/manual/core/schema-validation/specify-json-schema/).
The default `validationLevel` is `strict`, so inserts and updates must satisfy the validator.
`moderate` validates inserts and updates to documents that were already valid.
Use `moderate` only as a deliberate migration bridge, then clean old documents and return to `strict`.
The default `validationAction` is `error`, which rejects invalid writes.
`warn` permits the write and records a validation warning in the server log.
MongoDB 8.1 adds `errorAndLog`, which rejects and logs invalid writes.
Existing documents are not scanned merely because a validator was added.
Query existing invalid documents with `$nor` and the same `$jsonSchema` before tightening rules, as shown in [the validation query example](https://www.mongodb.com/docs/manual/core/schema-validation/use-json-schema-query-conditions/).
Use `collMod` to change validation on an existing collection.
`bypassDocumentValidation` is per operation and requires the corresponding privilege when access control is enabled.
Do not give ordinary application users `dbAdmin` or `restore` merely to bypass validation.
## Indexes
Map indexes to real query shapes, including equality filters, ranges, sorts, projections, and joins.
Create indexes for frequent selective queries on production-representative data.
Every index consumes disk and memory and adds work to inserts, updates, and deletes.
Inspect index use periodically and remove indexes that no longer serve a query.
Use [`explain("executionStats")`](https://www.mongodb.com/docs/manual/tutorial/analyze-query-plan/) to compare documents examined, keys examined, time, and winning plans.
The [indexing strategies guide](https://www.mongodb.com/docs/manual/applications/indexes/) recommends profiling candidate configurations rather than guessing.
Compound indexes serve the complete key pattern and its prefixes.
An index `{a: 1, b: 1}` can support `{a: ...}` but not a query on `b` alone.
MongoDB permits at most 32 fields in one compound index.
Apply ESR by placing equality keys first, then sort keys, then range keys.
Use ERS instead when a highly selective range should reduce the rows that an in-memory sort processes.
Equality keys can appear in any order relative to one another, but precede sort and range keys.
Do not rely on the index order until `explain` confirms it for the actual query.
See the [ESR guideline](https://www.mongodb.com/docs/manual/tutorial/equality-sort-range-guideline/) and [compound-index guide](https://www.mongodb.com/docs/manual/core/indexes/index-types/index-compound/create-compound-index/).
Use unique indexes for database-enforced uniqueness, including compound business keys.
Use partial indexes when only a filtered subset needs indexing, and include the filter in usable queries.
Prefer partial indexes over sparse indexes when the condition is more precise than field existence.
Use TTL indexes for finite-lived sessions, logs, or machine-generated data.
Use hidden indexes to test the effect of dropping an index without dropping it.
These properties and their restrictions are summarized in [index properties](https://www.mongodb.com/docs/manual/core/indexes/index-properties/).
An index on an array becomes a multikey index automatically.
A compound multikey index can have at most one array-valued indexed field per document.
Large arrays generate many index keys and can trigger index-key or memory limits.
Do not use an unbounded array as a substitute for a child collection.
See [multikey indexes](https://www.mongodb.com/docs/manual/core/indexes/index-types/index-multikey/) before indexing nested arrays.
## Transactions and atomicity
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
## Aggregation
An aggregation pipeline passes documents through ordered stages such as `$match`, `$group`, `$sort`, `$unwind`, `$project`, `$lookup`, and `$merge`.
`aggregate()` is read-only unless the pipeline uses `$merge` or `$out`.
Put selective `$match` filters early so indexes can reduce the input stream.
The optimizer may move independent `$match` predicates before projections, but verify the result with `explain`.
Put `$project` near the end unless an earlier projection changes semantics.
Use `$sort` with a useful index, and add `$limit` when only the top results are needed.
Use `$lookup` only when its join semantics fit the workload and its foreign field is indexed.
Reduce local input before a correlated `$lookup`, and index fields used by its foreign pipeline.
Aggregation stages are limited to 1000 in one pipeline.
Each returned result document must fit within 16 MiB.
Stages that need more than 100 MiB can spill to disk when `allowDiskUse` permits it, or error otherwise.
Spilling trades memory pressure for disk I/O, so measure it rather than enabling it blindly.
Map-reduce is deprecated starting in MongoDB 5.0. Use aggregation alternatives.
See [aggregation](https://www.mongodb.com/docs/manual/core/aggregation-pipeline/), [optimization](https://www.mongodb.com/docs/manual/core/aggregation-pipeline-optimization/), and [limits](https://www.mongodb.com/docs/manual/core/aggregation-pipeline-limits/).
## Pagination
`skip()` is simple for small offsets but scans from the beginning and becomes slower as the offset grows.
Always sort by a deterministic key that includes a unique tie-breaker, commonly `_id`.
For deep or changing result sets, prefer keyset pagination with an indexed range predicate.
Store the last returned sort key and query with `$lt` for descending order or `$gt` for ascending order.
For a compound sort, compare the full tuple, such as `(createdAt, _id)`, not just one field.
ObjectId values are not strictly monotonic because they have one-second resolution and are generated by client clocks.
Use an explicit timestamp plus a unique identifier when ordering semantics require more than approximate creation order.
The [cursor pagination guidance](https://www.mongodb.com/docs/manual/reference/method/cursor.skip/) includes both skip and range examples.
## Consistency and recency
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
## Schema evolution and migrations
MongoDB’s schema-versioning pattern allows old and new document shapes to coexist.
Add an explicit `schemaVersion` field instead of inferring versions from field presence when possible.
Write new documents in the newest version.
Update application code to read and update every supported version before changing stored data.
Choose eager, lazy, incremental, or background conversion based on downtime, volume, and rollback needs.
Keep the number of live versions small because each version increases code and index complexity.
If a field moves to another path, plan indexes for both paths during the transition.
Use validation and `collMod` as a staged contract, and inspect invalid documents before enforcing strict rules.
Batch long backfills, checkpoint them, and monitor query latency, write load, replication lag, and disk space.
Test the conversion on a production-shaped copy and define a rollback or forward-fix plan.
The [schema-versioning manual](https://www.mongodb.com/docs/manual/data-modeling/design-patterns/data-versioning/schema-versioning/) gives a concrete mixed-version example.
The MongoDB team’s [schema-versioning pattern](https://www.mongodb.com/company/blog/building-with-patterns-the-schema-versioning-pattern) documents lazy and background conversion choices.
The [schema-lifecycle video](https://learn.mongodb.com/learn/course/advanced-schema-patterns-and-antipatterns/advanced-schema-design-patterns-and-anti-patterns/apply-advanced-schema-design-patterns?page=2) emphasizes dual-read compatibility before a backfill.
## Operational limits and boundaries
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
## Security
Enable authentication and authorization before exposing a deployment.
Use a unique database user per application or operator and grant only required roles.
Use TLS for application, `mongod`, and `mongos` traffic.
Restrict network access with firewalls, security groups, Atlas IP access lists, private endpoints, or equivalent controls.
Use encryption at rest for storage and field-level encryption or Queryable Encryption for especially sensitive fields.
Protect encryption keys, credentials, configuration files, logs, and backups separately from the database process.
Audit administrative and data access where the deployment edition supports auditing.
Disable server-side scripting with `--noscripting` when `$where`, `$function`, `$accumulator`, and map-reduce are not needed.
Patch supported server and driver versions and review user credentials and network rules periodically.
Treat schema validation as a data-quality control, not an authorization boundary, because privileged operations can bypass it.
Follow the [security checklist](https://www.mongodb.com/docs/manual/administration/security-checklist/) and [encryption overview](https://www.mongodb.com/docs/manual/core/security-data-encryption/).
## Avoid relational imitation and unbounded documents
Do not translate every relational table into a collection and every foreign key into an array by reflex.
Do not add `$lookup` chains where a measured embedded or denormalized read model is simpler.
Do not embed all related data when only a small subset is read together.
Do not grow arrays without a bound, because updates rewrite the document and indexes multiply keys.
Use subset, bucket, outlier, or parent-reference patterns to bound growth.
Split large or independently accessed fields into separate documents or collections.
Prefer a smaller document that matches the hot read path over a bloated “everything” document.
Treat duplicated fields as a consistency contract with an owner, update path, and staleness budget.
The [unbounded-array anti-pattern](https://www.mongodb.com/docs/manual/data-modeling/design-antipatterns/unbounded-arrays/) shows subset and reference remedies.
Rick Houlihan’s [schema design talk](https://d1.awsstatic.com/events/Summits/reinvent2023/DAT347-S_Schema-design-for-fast-applications-sponsored-by-MongoDB.pdf) contrasts over-embedding and normalization and centers the workload.
## Verified examples
The verified [`mongodb-developer/java-quick-start`](https://github.com/mongodb-developer/java-quick-start) repository contains runnable Java examples.
Its [`ChangeStreams.java`](https://github.com/mongodb-developer/java-quick-start/blob/main/src/main/java/com/mongodb/quickstart/transactions/ChangeStreams.java) creates a JSON Schema validator with `ValidationAction.ERROR`.
Its [`Transactions.java`](https://github.com/mongodb-developer/java-quick-start/blob/main/src/main/java/com/mongodb/quickstart/transactions/Transactions.java) passes one session to updates in two collections and commits or aborts.
Its [`AggregationFramework.java`](https://github.com/mongodb-developer/java-quick-start/blob/main/src/main/java/com/mongodb/quickstart/AggregationFramework.java) demonstrates match, group, sort, limit, unwind, and projection stages.
## Sources

### Official MongoDB documentation

Official manuals: [Data Modeling](https://www.mongodb.com/docs/manual/data-modeling/), [Best Practices](https://www.mongodb.com/docs/manual/data-modeling/best-practices/), [Embedding](https://www.mongodb.com/docs/manual/data-modeling/embedding/), and [Referencing](https://www.mongodb.com/docs/manual/data-modeling/referencing/).
Official manuals: [Schema Validation](https://www.mongodb.com/docs/manual/core/schema-validation/), [JSON Schema](https://www.mongodb.com/docs/manual/core/schema-validation/specify-json-schema/), [Validation Level](https://www.mongodb.com/docs/manual/core/schema-validation/specify-validation-level/), [Invalid Documents](https://www.mongodb.com/docs/manual/core/schema-validation/handle-invalid-documents/), and [Query Invalid Documents](https://www.mongodb.com/docs/manual/core/schema-validation/use-json-schema-query-conditions/).
Official manuals: [Bypass Validation](https://www.mongodb.com/docs/manual/core/schema-validation/bypass-document-validation/), [Indexing Strategies](https://www.mongodb.com/docs/manual/applications/indexes/), [ESR](https://www.mongodb.com/docs/manual/tutorial/equality-sort-range-guideline/), and [Compound Indexes](https://www.mongodb.com/docs/manual/core/indexes/index-types/index-compound/create-compound-index/).
Official manuals: [Index Properties](https://www.mongodb.com/docs/manual/core/indexes/index-properties/), [Multikey Indexes](https://www.mongodb.com/docs/manual/core/indexes/index-types/index-multikey/), [Explain Plans](https://www.mongodb.com/docs/manual/tutorial/analyze-query-plan/), and [Limits](https://www.mongodb.com/docs/manual/reference/limits/).
Official manuals: [Aggregation](https://www.mongodb.com/docs/manual/core/aggregation-pipeline/), [Aggregation Optimization](https://www.mongodb.com/docs/manual/core/aggregation-pipeline-optimization/), [Aggregation Limits](https://www.mongodb.com/docs/manual/core/aggregation-pipeline-limits/), and [`$lookup`](https://www.mongodb.com/docs/manual/reference/operator/aggregation/lookup/).
Official manuals: [Cursor Pagination](https://www.mongodb.com/docs/manual/reference/method/cursor.skip/), [Read Concern](https://www.mongodb.com/docs/manual/reference/read-concern/), [Write Concern](https://www.mongodb.com/docs/manual/reference/write-concern/), and [Read Isolation](https://www.mongodb.com/docs/manual/core/read-isolation-consistency-recency/).
Official manuals: [Read Preference](https://www.mongodb.com/docs/manual/core/read-preference/), [Transactions](https://www.mongodb.com/docs/manual/core/transactions/), and [Transaction Production Considerations](https://www.mongodb.com/docs/manual/core/transactions-production-consideration/).
Official manuals: [Schema Versioning](https://www.mongodb.com/docs/manual/data-modeling/design-patterns/data-versioning/schema-versioning/) and [Document and Schema Versioning](https://www.mongodb.com/docs/manual/data-modeling/design-patterns/data-versioning/).
Official manuals: [Unbounded Arrays](https://www.mongodb.com/docs/manual/data-modeling/design-antipatterns/unbounded-arrays/), [Security Checklist](https://www.mongodb.com/docs/manual/administration/security-checklist/), and [Encryption](https://www.mongodb.com/docs/manual/core/security-data-encryption/).

### MongoDB team guidance

MongoDB team guidance: [Six Rules of Thumb](https://www.mongodb.com/company/blog/mongodb/6-rules-of-thumb-for-mongodb-schema-design) and [Schema Versioning Pattern](https://www.mongodb.com/company/blog/building-with-patterns-the-schema-versioning-pattern).

### Talks and videos

Traceable talks and videos: [MongoDB University relationship video](https://learn.mongodb.com/learn/course/relational-to-document-model/relational-to-document-model/design-relationships?client=customer&page=2), [schema-lifecycle video](https://learn.mongodb.com/learn/course/advanced-schema-patterns-and-antipatterns/advanced-schema-design-patterns-and-anti-patterns/apply-advanced-schema-design-patterns?page=2), and [Rick Houlihan’s AWS re:Invent talk](https://d1.awsstatic.com/events/Summits/reinvent2023/DAT347-S_Schema-design-for-fast-applications-sponsored-by-MongoDB.pdf).

### Verified examples

Verified examples: [Java Quick Start repository](https://github.com/mongodb-developer/java-quick-start), [`ChangeStreams.java`](https://github.com/mongodb-developer/java-quick-start/blob/main/src/main/java/com/mongodb/quickstart/transactions/ChangeStreams.java), [`Transactions.java`](https://github.com/mongodb-developer/java-quick-start/blob/main/src/main/java/com/mongodb/quickstart/transactions/Transactions.java), and [`AggregationFramework.java`](https://github.com/mongodb-developer/java-quick-start/blob/main/src/main/java/com/mongodb/quickstart/AggregationFramework.java).
