# Size and cohesion heuristics

- There is no universal Python limit for function, class, module, or package size.
- Treat a long or deeply nested unit as a review trigger, not an automatic refactoring target.
- Split a function when it has multiple responsibilities, repeated phases, unrelated branches, or awkward tests.
- Split a module when it mixes layers, exposes an unclear public surface, or creates dependency cycles.
- Prefer one reason to change per module and one invariant-owning responsibility per class.
- Extract a helper when the extracted concept has a name, a contract, and independent tests.
- Do not extract trivial wrappers that obscure control flow or force readers across many files.
- Use parameter count, nesting depth, duplication, and change frequency as local review signals.
- Revisit a function that needs multiple screens, remains unclear after its names and structure are inspected, or requires several mock layers to test.
- Keep public APIs small and stable; let private helpers absorb implementation detail.
- Prefer composition and plain functions until shared state or invariants justify a class.
