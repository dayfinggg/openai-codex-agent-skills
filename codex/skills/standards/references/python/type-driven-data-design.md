# Type-driven data design

- Define the typed contracts at module and layer boundaries before filling in implementation details when data flow is still unclear.
- Model the application's needs rather than copying an external API, database row, or JSON payload into the domain model.
- Convert untrusted transport data at the boundary into validated domain values; annotations and `TypedDict` do not perform runtime validation.
- Prefer a named record over a positional tuple when field order is not itself part of the contract.
- Use `NamedTuple` only when tuple behavior, positional compatibility, or unpacking is intentional.
- Use a dataclass for a named record or value object that benefits from generated methods, invariants, immutability, or cohesive behavior.
- Use `TypedDict` for genuinely dictionary-shaped data, especially JSON-like payloads and compatibility with existing mapping-based APIs. Do not use it as a default domain model.
- Use `Literal` for a small closed set of values local to a signature. Use `Enum` when the values need stable names, runtime identity, iteration, conversion, or shared domain behavior.
- Treat a type alias as a readability aid, not a new type. Use `NewType` or a validated value object when confusing two values with the same representation would be unsafe.
- Make optionality explicit only when absence is a valid state. Prefer a separate constructor, result type, or exception when `None` would make the contract ambiguous.
