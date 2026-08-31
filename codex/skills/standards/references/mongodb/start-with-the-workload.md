# Start with the workload
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
