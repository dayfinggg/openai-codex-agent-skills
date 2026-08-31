# Size and cohesion heuristics

- Java has no universal method or class size limit, so use size as a review trigger rather than an automatic failure.
- Use repository-measured thresholds only when they correlate with review or maintenance problems. Do not invent numeric limits for a project that has none.
- Review constructors with more than five collaborators, deep branching, or many mode flags.
- Extract code when the reader must inspect implementation details to discover its intent.
- Name an extracted unit after the behavior it represents, not after a vague utility role.
- A cohesive class keeps related state and the operations that preserve that state together.
- Divergent reasons to change, unrelated fields, long parameter lists, and repeated condition families signal weak cohesion.
- Split along a stable domain or ownership boundary, not merely to hit a line count.
- Do not create pass-through wrappers that add indirection without a contract or cohesive responsibility.
- Allow a longer cohesive algorithm when splitting would obscure control flow, and protect it with focused tests.
- Remove dead code and duplication before using extraction to reduce size.
- During review ask whether the type has one clear reason to change and whether its tests can isolate that responsibility.
