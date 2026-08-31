# Type annotations

- Remember that Python does not enforce annotations at runtime; a checker and tests provide enforcement.
- Annotate public functions, methods, class attributes, and module boundaries first.
- Annotate inputs with the widest type the implementation accepts, such as `Iterable[str]` or `Mapping[str, object]`.
- Return a concrete type when the implementation promises a concrete result, such as `list[int]`.
- Prefer built-in generic syntax such as `list[str]`, `dict[str, int]`, and `tuple[int, ...]` where supported.
- Prefer `collections.abc` interfaces for protocols such as `Iterable`, `Sequence`, and `Mapping`.
- Use project-supported nullable syntax, preferring `X | None` on Python 3.10+ targets.
- Parameterize generic types; an unparameterized generic usually leaks `Any` into the program.
- Use `object` when a value of any type is accepted but no operations beyond `object` are assumed.
- Use `Any` only when the type is genuinely unknown or cannot be expressed economically.
- Narrow `Any` at external boundaries and avoid spreading it through core logic.
- Use `Protocol` for a small structural interface when callers need behavior rather than inheritance.
- Use `NewType` for domain identifiers that must not be confused with their underlying type.
- Use an explicit `TypeAlias` or the `type` statement when a complex alias could be mistaken for a value.
- Mark constants with `Final` when reassignment would violate the design.
- Use `TYPE_CHECKING` imports only for types that must not be imported at runtime.
- Prefer refactoring over suppressing a checker; every ignore should name a reason and narrow a scope.
- Libraries that promise typed APIs should ship `py.typed` or a separately maintained stub package.
- Keep decorators from changing call signatures unless their typing contract is explicit and tested.
- Run the selected type checker in CI with a documented configuration and supported-version matrix.

Load the focused follow-up only when it applies:

- [Type-driven data design](type-driven-data-design.md)
- [Inference and boundary annotations](inference-and-boundary-annotations.md)
- [Generics and callables](generics-and-callables.md)
