# File and function size heuristics

- Do not enforce a universal line count or function-length limit; no number is a quality target.
- Split a unit when it has multiple reasons to change, hides sequencing, needs explanatory scaffolding, or is hard to test in isolation.
- Keep a cohesive algorithm together when splitting would obscure its invariants or create needless indirection.
- Treat nesting, branching, parameter count, fan-out, churn, review friction, and test setup as signals rather than verdicts.
- Let measured repository data and repeated maintenance pain set any local thresholds.
- Keep generated code, schemas, fixtures, and large lookup tables together when their size reflects their purpose.
- Refactor in small behavior-preserving steps, compiling and running tests after each meaningful step. [S32]
- Prefer a boundary that reduces cognitive load and coupling over a boundary that merely shortens a file.
