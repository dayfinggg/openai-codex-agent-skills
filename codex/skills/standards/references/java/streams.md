# Streams

- Use streams for clear transformations, filtering, and reductions over data.
- Use a loop when control flow, checked exceptions, mutation, or early exits would be clearer.
- A stream pipeline is lazy, consumable once, and separate from the source collection.
- Keep stream behavior non-interfering and stateless.
- Do not modify a non-concurrent source while its stream pipeline runs.
- Avoid side effects in map, filter, peek, and other behavioral parameters.
- Prefer collect or reduce over mutating an external accumulator from forEach.
- Use one terminal operation and do not retain a stream for later traversal.
- Treat encounter order as a contract; choose ordered or unordered processing deliberately.
- Keep streams sequential by default.
- Use parallel streams only after measuring a meaningful workload with associative, stateless operations.
- Verify that parallel reduction, ordering, allocation, and merge costs improve the real workload.
- Close streams backed by files, sockets, or other resources with try-with-resources.
- Choose a mutable or unmodifiable collector according to the API contract.
- Use primitive streams for measured numeric hot paths where boxing is material.
