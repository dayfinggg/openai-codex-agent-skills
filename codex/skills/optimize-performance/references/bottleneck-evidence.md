# Bottleneck Evidence

Use this reference after reproducing the target workload. Start with broad evidence, then narrow the investigation; select tools already supported by the repository or runtime when they can answer the question.

## Latency and throughput

Break elapsed time into execution, waiting, queuing, and external dependency time. Use traces, span timing, request profiles, queue metrics, and utilization together. For tail latency, inspect slow traces and distributions rather than extrapolating from averages.

When throughput plateaus, look for a saturated resource, serialized path, lock contention, bounded pool, rate limit, backpressure, retry amplification, or downstream ceiling. Increase load gradually and observe where latency, queues, errors, or utilization change. More concurrency is useful only when waiting can overlap and the downstream system can absorb it.

## CPU and synchronization

Use sampled CPU profiles or flame graphs under the representative workload. Attribute time to call paths, not isolated functions. Distinguish application work from runtime, garbage collection, serialization, compression, cryptography, and kernel activity.

For parallel workloads, inspect per-core use, runnable threads or tasks, locks, context switches, scheduler delay, false sharing, and work imbalance. Confirm suspected contention by reducing or isolating the contested operation and observing the target metric.

## Memory and allocation

Choose evidence for the symptom: peak resident or working set for capacity, retained-object snapshots for leaks, allocation profiles for churn, and garbage-collector telemetry for pause or CPU cost. Compare snapshots at equivalent lifecycle points.

Before adding pooling or caches, quantify allocation cost and memory lifetime. A lower allocation count can still increase retained memory, fragmentation, synchronization, or stale data. Include steady state and post-load recovery when evaluating leaks.

## I/O and data access

Separate time spent issuing operations from time waiting for storage, network, databases, or external APIs. Inspect operation counts, transferred bytes, latency distributions, cache hit rates, queue depth, connection-pool behavior, retries, and timeouts.

For databases, use the actual query plan and representative cardinalities. Check rows scanned versus returned, index selectivity, join strategy, sort or spill behavior, lock waits, round trips, and transaction scope. Validate an index or query rewrite against write cost and realistic data, not only a small development database.

## Startup and initialization

Trace the path from process launch to usable service or interface. Attribute import or module loading, dependency injection, class loading, configuration, migrations, bundle parsing, compilation, connection establishment, and eager cache population separately. Re-test both cold and warm starts when deployment or user behavior includes both.

## External-service cost

Measure call count, payload size, tokens or billable units, retry rate, cache behavior, concurrency, and success rate. Normalize consumption per successful request or completed job. Verify that batching or caching preserves freshness, isolation, ordering, and failure semantics.

## Establish causality

Convert the suspected bottleneck into a controlled test. Examples include disabling one transformation, replacing an external dependency with a calibrated local response, changing only a pool size, varying input cardinality, or measuring the same path with and without a candidate cache. The intervention should predict a directional change before it is run.

Reject the hypothesis when the target metric does not respond as predicted. Do not retain a complexity-increasing change merely because a local counter improved. Return to the profile and investigate the next largest contributor.
