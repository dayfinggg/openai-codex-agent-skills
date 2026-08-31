# Embedding versus references
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
