# Choose by required operations

- List the dominant operations, ordering needs, duplicate policy, mutation pattern, lookup keys, traversal, and memory constraints before selecting a structure.
- Use a sequence for ordered iteration, a set for membership and uniqueness, a map for keyed access, a stack for last-in-first-out work, a FIFO queue for arrival order, a deque for efficient work at both ends, a priority queue for repeated minimum or maximum selection, and a graph only when relationships are the domain.
- Prefer the language's maintained standard collection unless a measured requirement needs a specialized structure.
- Do not infer operation costs from an interface name alone. Array-backed and linked representations can implement similar behavior with different indexing, insertion, allocation, and locality costs.
- Prefer linked nodes only when callers already hold node handles or local splicing dominates. Linear search usually erases the apparent insertion advantage.
- Include the cost of construction, updates, serialization, cache locality, allocation, and concurrency, not only lookup notation.
- Do not expose the chosen representation as a public contract when callers need only a smaller behavioral interface.
- Keep stable ordering explicit. Hash iteration order, locale, collation, and equal-key tie behavior must not accidentally define user-visible results.
