# Aggregation
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
