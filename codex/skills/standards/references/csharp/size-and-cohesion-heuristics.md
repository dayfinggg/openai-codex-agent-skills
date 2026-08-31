# Size and cohesion heuristics

- Treat line count as a review signal, never as a correctness threshold.
- Split a method when it has multiple conceptual jobs, deep branching, repeated setup, or a name that needs “and”.
- Split a type when it has multiple reasons to change, unrelated dependencies, or state that different methods do not share.
- Keep one main abstraction per file when that improves navigation; group tightly related small declarations only when their relationship is obvious.
- Prefer cohesive modules whose fields, invariants, vocabulary, and tests point to one purpose.
- Extract code only when the extracted name improves the reader's model or isolates a meaningful boundary.
- Replace growing parameter lists with a cohesive options type, not with an anonymous bag of unrelated settings.
- Review large diffs and large classes for ownership, testability, and dependency direction before applying mechanical decomposition.
