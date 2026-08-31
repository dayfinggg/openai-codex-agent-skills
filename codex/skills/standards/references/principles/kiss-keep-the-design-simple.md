# KISS: keep the design simple

- Choose the simplest complete design that satisfies current behavior and nonfunctional constraints.
- Simple means easy to explain, test, modify, and operate; it does not mean fewest characters or files.
- Prefer direct control flow and explicit data over clever indirection.
- Prefer a meaningful boundary over a chain of wrappers that only forwards calls.
- A substantial implementation can still be simple when it hides complexity from callers.
- Do not simplify by deleting required validation, error handling, observability, or compatibility behavior.
- Fowler's summary of Beck's simple-design rules puts passing tests, revealed intent, no duplicated logic, and few unnecessary elements ahead of cosmetic brevity.
- Refactor toward clarity when a simpler design becomes visible; do not preserve a poor design because it took effort to write.
