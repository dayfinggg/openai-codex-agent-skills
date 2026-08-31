# Generics and callables

- Introduce a type parameter when the API preserves a relationship between types, such as returning the same element type it accepts. Do not use a type variable merely as a verbose replacement for `object`.
- Constrain or bound a type parameter only when the implementation requires those operations or the domain requires that closed set.
- Use `Callable[[A, B], R]` for a simple callback contract. Use a callback `Protocol` with `__call__` when parameter names, overloads, attributes, or a richer callable contract matter.
- Keep generic APIs as small as their real substitution rules permit; do not force unrelated arguments to share one type parameter.
