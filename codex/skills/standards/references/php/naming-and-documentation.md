# Naming and documentation

- Name classes after stable concepts and roles, not vague buckets such as `Helper`, `Manager`, or `Util`.
- Use verbs for commands and queries that reveal intent; use `is*`, `has*`, and `can*` for boolean predicates.
- Name interfaces by capability or port, and name adapters by the technology they wrap.
- Keep abbreviations rare and use the domain vocabulary consistently.
- Add prose PHPDoc only when documentation is explicitly requested. Preserve or update machine-read type annotations required by an existing analyzer when native declarations cannot express them.
- Do not duplicate an accurate native declaration with redundant PHPDoc.
- Prefer native declarations, names, and structure for intent. Do not add source notes or implementation commentary.
- When documentation is requested, verify its examples against the actual public API.
