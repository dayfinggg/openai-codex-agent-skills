# Null handling

- Choose one project-wide nullness policy and state it at public boundaries.
- Use a consistent nullness system such as JSpecify when the toolchain supports it.
- Mark new packages or classes as null-marked and annotate genuine nullable values explicitly.
- Adopt nullness annotations incrementally from low-dependency code toward its callers.
- Reject invalid non-null inputs at the boundary with Objects.requireNonNull and a useful parameter name.
- Never return null from a method whose contract promises an Optional.
- Use Optional primarily as a return type when absence is a meaningful result.
- Do not use Optional fields or parameters unless the surrounding API convention explicitly requires them.
- Distinguish absent, empty, unknown, and invalid values instead of collapsing them into null.
- Prefer empty collections when empty has the same meaning as no result.
- Annotate or adapt external APIs whose nullness contract is not visible to the checker.
- Keep null checks close to the boundary so the rest of the code can rely on a stable invariant.
