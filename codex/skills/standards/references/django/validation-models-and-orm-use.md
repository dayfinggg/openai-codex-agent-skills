# Validation, models, and ORM use

- Validate untrusted form data through `is_valid()` and the documented cleaning pipeline. [D3]
- Use explicit serializers or schemas for JSON APIs instead of passing arbitrary request dictionaries into model constructors.
- Keep request shape validation separate from cross-record business invariants and database constraints.
- Treat a model as the authoritative definition of stored data and its essential behavior. [D4]
- Put row-level behavior on model methods and table-wide query behavior on managers or querysets. [D4] [D5]
- Use the ORM directly for ordinary CRUD and query composition; do not wrap every queryset in a repository. [D5]
- Understand that querysets are lazy and evaluate them deliberately. [D6]
- Measure query counts and use documented eager-loading or projection techniques when an access path is slow. [D7]
- Keep query helpers close to the app or model that owns their meaning.
- Use database constraints for uniqueness, referential integrity, and invariants that must hold across all callers. [D4]
- Do not rely on overridden `save()` or signals to enforce behavior that bulk operations can bypass. [D4]
- Use raw SQL sparingly, keep parameters separate from SQL text, and review every raw query as security-sensitive. [D11]
