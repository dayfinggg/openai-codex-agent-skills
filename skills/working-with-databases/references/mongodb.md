# MongoDB

## Modelling

Model for the queries the application runs. Keep together in one document what is read together, and reference what grows without limit or is shared by many documents. An array that grows forever makes the document slower with every write and ends at the 16 MB document limit. A read that needs `$lookup` across several collections on every request is a sign that the model follows a relational shape and not the queries.

## Indexes

Order the fields of a compound index by the ESR rule, with equality fields first, then the sort fields, then the range fields. `$ne`, `$nin` and `$regex` count as range conditions. A query is covered when every field in the filter and in the projection is in one index, and the projection excludes `_id` unless the index holds it. Remove indexes that nothing uses, because each one adds work to every write.

## Plans and slow operations

`db.collection.find(...).explain("executionStats")` shows what ran. Compare `nReturned` with `totalKeysExamined` and `totalDocsExamined`, since a query that examines far more than it returns needs a better index. A `COLLSCAN` stage is a scan of the whole collection, and a `SORT` stage is a sort in memory. `db.setProfilingLevel(1, { slowms: 50 })` records operations above the threshold in `system.profile`, and the profiler itself costs performance, so switch it off after the investigation.

## Consistency

Multi-document transactions exist and are not a replacement for a model that keeps related data in one document. For data that must not be lost, write with `w: "majority"`. A read from a secondary can be behind the primary.

## Operators as input

A filter built from a request body accepts operators such as `$ne` and `$gt` as values. Cast each value to the expected type before it enters a filter.
