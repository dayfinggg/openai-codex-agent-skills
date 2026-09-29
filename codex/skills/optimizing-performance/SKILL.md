---
name: optimizing-performance
description: Diagnose or improve measured latency, memory use, throughput or large-input bottlenecks. Skip speculative optimization of ordinary code.
---

# Optimizing performance

Measure the relevant path with representative data and identify its bottleneck through a profiler, trace or query plan. A diagnosis-only request ends with the cause. When optimization is requested, change the bottleneck with the simplest approach and measure again by the same method.

Typical candidates are queries in loops, unbounded reads, repeated computation, sequential independent I/O, excessive client JavaScript and missing image dimensions. Choose a remedy only after evidence connects it to the problem. Caches need an invalidation rule and indexes need a relevant query plan.

Use available project tools, such as browser performance tooling, SQL EXPLAIN, Python cProfile or py-spy, Node profiling, or PHP profiling. EXPLAIN ANALYZE executes the query, so use it only against authorized data and avoid unsafe writes.

Preserve correctness and report comparable before-and-after results, including measurement limits. Stop when the requested target is met rather than adding unmeasured complexity.
