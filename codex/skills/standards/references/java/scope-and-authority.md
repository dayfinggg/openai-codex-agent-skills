# Scope and authority

- The Java release declared by the project is the language and API baseline.
- The repository build, CI checks, formatter, and local style guide outrank this reference.
- Resolve remaining choices in this order: language and API contracts, repository policy, this reference, then personal preference.
- Record deliberate exceptions beside the code or in the issue that owns the constraint.
- Use permanent language features by default and treat preview features as explicit project decisions.
- Keep source files in UTF-8 with an explicit package declaration.
- Use one top-level class, interface, enum, or record per file.
- Mark every legal override with @Override.
- Do not use finalizers.
- Enable compiler warnings and static analysis, but make a check an error only when it is actionable.
- Prefer standard-library types and behavior that the target Java release documents.
