# Naming and style

- Name values, types, functions, and modules for the domain concept they represent.
- Do not encode type information in names such as `userString` or `itemsArray`. [S23]
- Use `lowerCamelCase` for values and functions, `UpperCamelCase` for types and classes, and the repository's constant convention for constants. [S23]
- Avoid unexplained abbreviations, Hungarian prefixes, and meaningless one-letter names outside tiny local scopes. [S23]
- Do not add `I` prefixes to interfaces unless the surrounding ecosystem requires them. [S23]
- Name predicates with forms such as `isReady`, `hasAccess`, or `canRetry` when they return booleans.
- Name conversion, parsing, and validation functions so callers can see whether they can fail or throw.
- Prefer object parameters when several arguments would otherwise be positional and easy to swap.
- Keep function names stable during refactoring; move or rename separately from behavior edits when possible. [S32]
- Use the formatter and lint rules already selected by the repository.
