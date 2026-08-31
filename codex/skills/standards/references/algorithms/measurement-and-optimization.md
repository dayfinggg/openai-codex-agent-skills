# Measurement and optimization

- Profile the real path with representative data before changing an algorithm for performance.
- Benchmark the complete operation, including input preparation and allocation when those costs occur in production, while isolating setup that production reuses.
- Warm up runtimes and caches where applicable, use multiple samples, report variance, and compare against a preserved baseline.
- Inspect memory, allocation, cache locality, I/O, query count, contention, and tail latency as well as CPU time.
- Keep an obvious implementation as an oracle for differential or property-based tests when introducing a complex optimized version.
- Record the workload and constraint that justify a less readable optimization, then remeasure after the change.
