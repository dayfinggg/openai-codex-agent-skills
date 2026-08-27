# Bottleneck Playbook

Read this reference only after measurement classifies a material bottleneck.

## Algorithm And CPU

Check input-size growth before instruction-level tuning. Replacing an unsuitable algorithm or data structure usually has more value than reducing constants. Benchmark the production size range because asymptotic improvement can lose on small inputs and constant-factor wins can collapse at scale.

For CPU-bound work, use sampled stacks and hardware counters where available. Separate useful instructions from serialization, hashing, parsing, copying, virtual dispatch, branch misses, cache misses, and runtime overhead. Improve the hottest cumulative path first. Apply vectorization, layout changes, intrinsics, or architecture-specific tuning only when supported by profiles and target hardware.

Parallelism is limited by sequential work and coordination. More workers can reduce throughput through contention, context switching, cache traffic, and queueing. Measure scaling across worker counts and choose the smallest concurrency that meets the target.

## Allocation And Memory

Measure allocation rate, live heap, retained heap, resident memory, garbage-collection frequency and pause, fragmentation, copies, and peak working set. Distinguish churn from retention. Reduce unnecessary object creation and copying before adding pools. Pool only expensive, reusable objects with bounded lifetime; pooling cheap objects can increase retention, synchronization, and complexity.

## I/O, Network, And Batching

Measure bytes, operations, round trips, queue time, service time, bandwidth, connection setup, retries, and downstream saturation. Reduce unnecessary calls and payloads before increasing parallelism. Batch when per-operation overhead dominates, but measure added waiting latency, memory, failure amplification, partial-result handling, and maximum batch size. Stream when it reduces buffering or enables useful overlap, not merely because streaming sounds faster.

Bound concurrency and propagate backpressure. Async execution hides waits but does not remove them. Compression trades CPU for bandwidth and must be measured with representative payloads and network conditions.

## Database

Rank queries by total time, call count, tail latency, rows, buffer reads, temporary I/O, and lock time. Optimize the query that consumes material workload time, not the most visually complex SQL.

Use an actual execution plan with representative data and current statistics. Compare estimated and actual rows, loops, scans, joins, sorts, spills, filters, serialization, and client transfer. Detect N+1 calls and excessive round trips from traces or query counts.

Add an index only when it improves the measured access path enough to justify write, storage, cache, and maintenance cost. Retrieve only required rows and columns. Batch writes within correctness and lock-duration limits. Treat connection-pool size as bounded concurrency, not as a cure for a slow query or saturated database.

## Cache

Add or change a cache only after measuring repeated expensive reads and estimating hit rate and miss penalty. Track hits, misses, evictions, fill latency, origin load, stale reads, memory, and stampedes. Define source of truth, key, TTL, invalidation, size limit, eviction, warm-up, and failure fallback. A cache required for baseline capacity is a critical dependency.

## Web And User Experience

Start with real-user data segmented by page type, device, network, geography, and relevant user cohort. Evaluate Core Web Vitals at the 75th percentile: LCP for main-content loading, INP for interaction responsiveness, and CLS for visual stability. Lab tools diagnose causes but do not replace field measurements.

For LCP, inspect server response, resource discovery, download, and render delay. For INP, inspect input delay, callback duration, main-thread contention, and presentation delay. For CLS, identify the shifting element and missing size or late content. Use a throttled low-end device and clean browser profile for lab comparisons. Do not optimize a composite Lighthouse score while the user-facing metric remains unchanged.

## Capacity And Saturation

Measure service demand per unit of work and the resource that fills first. Plot throughput, latency percentiles, errors, queue depth or age, CPU, memory, I/O, connections, and downstream limits across increasing load. Locate the nonlinear saturation knee and recovery point.

Increase capacity or improve efficiency only at the limiting resource. Keep explicit headroom for failures, deploys, bursts, and forecast error. Verify overload behavior, load shedding, queue bounds, autoscaling delay, and backlog drain. Re-test after optimization because the bottleneck usually moves.
