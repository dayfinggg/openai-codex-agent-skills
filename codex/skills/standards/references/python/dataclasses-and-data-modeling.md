# Dataclasses and data modeling

- Use `@dataclass` for records or value objects whose fields and equality semantics are part of the design.
- Distinguish an entity, whose stable identity continues across attribute changes, from a value object, whose value is defined by its attributes. Do not add identity to every dataclass or DTO.
- The decorator inspects annotated fields and can generate methods such as `__init__`, `__repr__`, and `__eq__`.
- Field order affects generated methods, so put required fields before defaulted fields and keep the order meaningful.
- Use `field(default_factory=...)` for a fresh mutable default per instance.
- Use `frozen=True` when immutability expresses the value object's contract, not merely to silence mutation.
- Consider `slots=True` for a deliberate memory or attribute-layout decision, and test inheritance behavior.
- Consider `kw_only=True` when positional arguments would be fragile or ambiguous.
- Validate cross-field invariants in `__post_init__` or a named constructor that raises a specific exception.
- Do not mistake a dataclass for runtime schema validation or a substitute for domain behavior.
- Keep methods on a dataclass cohesive with its invariants; move unrelated orchestration to a service function.
