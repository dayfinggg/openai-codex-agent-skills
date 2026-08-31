# Complexity and scale

- State time and auxiliary-space complexity for the dominant path when input can grow enough for it to matter. Include output size and recursive call-stack space.
- Name the size parameters that drive the bound, such as vertices and edges for a graph or records and block size for external-memory work.
- Distinguish worst case, expected, and amortized behavior. State whether randomness comes from the algorithm or structure rather than the input, and do not present an expected bound as a worst-case or tail-latency guarantee.
- State assumptions behind a bound, including hash load and collision behavior, geometric resize policy, representation overhead, and reusable indexes. Big-O notation alone does not predict latency.
- Estimate realistic input sizes, skew, cardinality, and concurrency before rejecting a simple algorithm or accepting a theoretically faster one.
- Avoid hidden quadratic work from repeated scans, string concatenation, nested lookups, N+1 queries, or copying growing collections.
- Bound algorithms that process untrusted or adversarial input, especially regular expressions, parsing, sorting, graph traversal, decompression, and recursion.
- Consider external-memory and streaming approaches when the data need not or cannot fit in memory. Account for block transfers rather than treating storage access like RAM.
