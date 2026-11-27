# MongoDB

## Modelling

Keep in one document what is read together, and reference what grows without limit or is shared. An ever-growing array slows every write and ends at the 16 MB document limit. Needing `$lookup` across collections on every request means the model follows a relational shape instead of the queries.

## Indexes

Order compound index fields by ESR, equality first, then sort, then range, where `$ne`, `$nin` and `$regex` count as range. A query is covered when every filter and projection field is in one index and the projection excludes `_id` unless the index holds it.

## Plans and slow operations

`find(...).explain("executionStats")` shows what ran. A query whose `totalKeysExamined` or `totalDocsExamined` far exceeds `nReturned` needs a better index, `COLLSCAN` scans the whole collection and `SORT` sorts in memory. `db.setProfilingLevel(1, { slowms: 50 })` records slow operations in `system.profile` and costs performance, so on a live server it needs the go-ahead and is switched off afterwards.

## Consistency and input

Write data that must not be lost with `w: "majority"`, and expect a secondary to lag the primary. Use multi-document transactions for the rare case a document model cannot cover. Cast every request value to its expected type before it enters a filter, because a body can carry operators such as `$ne` and `$gt`.
