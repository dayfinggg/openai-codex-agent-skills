# Refactoring discipline

- Refactor to improve internal structure while preserving observable behavior; treat a contract change as a separate decision.
- Establish focused characterization or regression tests before changing unfamiliar, fragile, or weakly specified code.
- Make one comprehensible structural move at a time, run the narrowest useful checks, and keep the code working between moves.
- Separate mechanical renames, moves, extraction, and formatting from semantic behavior changes when doing so makes review and rollback safer.
- Improve names at the declaration and call sites together so they reveal domain meaning, units, side effects, and failure behavior.
- Treat a change to ubiquitous domain language as a model change. Update the code, tests, documentation, messages, and integrations within the affected bounded context, then verify translators and consumers in neighboring contexts.
- Delete dead code, stale comments, unused parameters, and abandoned branches rather than commenting them out or preserving them for hypothetical reuse.
- Prefer names, types, tests, and structure over source comments. Retain a concise source note only when a constraint, tradeoff, source, or surprising reason cannot be expressed in code and is necessary for a maintainer or caller; remove narration that repeats the implementation.
- Do not chase small functions, classes, or files as goals in themselves. Judge whether the result reduces the reader's required context and keeps an invariant together.
- Stop when the requested behavior is clear, verified, and maintainable. Do not turn a focused change into a repository-wide cleanup.
