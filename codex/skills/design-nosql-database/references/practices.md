# NoSQL Database Practices

NoSQL behavior is product-specific. Begin with access patterns and operational limits, then choose documents, items, partitioning, indexes, and consistency. Flexible schema still needs a versioned application contract and a mixed-version migration path.

Embedding optimizes atomic reads and writes but increases item size and update coupling. References reduce duplication but add queries and consistency work. Denormalization must name its source of truth and repair mechanism. Distributed transactions are a costed exception, not a default.

Primary sources:

- [MongoDB data modeling](https://www.mongodb.com/docs/manual/data-modeling/)
- [MongoDB schema validation](https://www.mongodb.com/docs/manual/core/schema-validation/)
- [MongoDB indexes](https://www.mongodb.com/docs/manual/indexes/)
- [MongoDB transactions](https://www.mongodb.com/docs/manual/core/transactions/)
- [MongoDB read isolation and consistency](https://www.mongodb.com/docs/manual/core/read-isolation-consistency-recency/)
- [DynamoDB data modeling foundations](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/data-modeling-foundations.html)
- [DynamoDB partition-key guidance](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/bp-partition-key-uniform-load.html)
- [DynamoDB transactions](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/transactions.html)
- [DynamoDB read consistency](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.ReadConsistency.html)
