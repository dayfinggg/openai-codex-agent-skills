# Schema evolution and migrations
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
