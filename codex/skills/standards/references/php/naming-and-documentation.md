# Naming and documentation

- Name classes after stable concepts and roles, not vague buckets such as `Helper`, `Manager`, or `Util`.
- Use verbs for commands and queries that reveal intent; use `is*`, `has*`, and `can*` for boolean predicates.
- Name interfaces by capability or port, and name adapters by the technology they wrap.
- Keep abbreviations rare and use the domain vocabulary consistently.
- Document a public PHP API with PHPDoc only when its invariants, array shapes, templates, side effects, deprecations, or exceptions are not clear from native declarations, names, and tests.
- Do not duplicate an accurate native declaration with redundant PHPDoc.
- Prefer native declarations, names, and structure for intent. Keep a source note only when a surprising constraint cannot be expressed in code and callers or maintainers must know it.
- Keep public API documentation and examples executable or covered by tests.
