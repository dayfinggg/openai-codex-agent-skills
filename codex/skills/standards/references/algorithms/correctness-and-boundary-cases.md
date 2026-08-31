# Correctness and boundary cases

- Define the preconditions, postconditions, invariants, and tie-breaking rules before optimizing an algorithm.
- Require a consistent ordering relation for comparison-based structures and equality/hash consistency for hash-based structures.
- Test empty, singleton, duplicate, already sorted, reverse ordered, extreme numeric, malformed, cyclic, disconnected, and maximum-size inputs as applicable.
- Use exact arithmetic or a domain-defined tolerance where floating-point rounding affects comparison or termination.
- Ensure loops and recursive calls make measurable progress toward termination, and bound recursion where stack depth can follow input size.
- Preserve input ownership unless mutation is an explicit contract. Make result stability, equal-key ordering, and deterministic, lazy, or single-use evaluation visible in the API contract, types, or tests; use public API documentation only when those forms cannot express it.
- Turn every discovered counterexample into a minimized regression case.
