# Size and cohesion heuristics

- Keep a module centered on one domain concept, host binding, or change reason with a narrow public API.
- Split a file or function when it mixes independent lifecycles, unrelated dependencies, host concerns, or failure policies.
- Keep a larger cohesive algorithm together when extraction would create pass-through wrappers or scatter one invariant.
- Treat line count as a review signal, not a hard limit. Investigate nesting, branching, state, import count, and test setup before splitting.
- Keep package entry points shallow and implementation modules private behind `exports`.
- Prefer a small concrete abstraction over a generic utility with flags, unused options, or speculative extension points.
- Remove duplicated business rules while leaving harmless repeated test setup visible when it clarifies a scenario.
- Measure bundle size, startup, event-loop delay, and memory before adding complexity for performance.
