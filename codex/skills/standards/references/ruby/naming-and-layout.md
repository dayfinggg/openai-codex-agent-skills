# Naming and layout

- Use English names unless the domain requires a local term that the team has documented.
- Use `snake_case` for methods, local variables, instance variables, symbols, files, and directories.
- Use `CapitalCase` for classes and modules, while keeping established acronyms uppercase.
- Use `SCREAMING_SNAKE_CASE` for constants that are not classes or modules.
- End predicate methods with `?`, and make their truthy or falsey contract obvious from the name and tests.
- Use `=` methods for assignment-like writers, and preserve normal Ruby assignment semantics.
- Treat `!` as a warning that a method is dangerous or mutating; do not add it just to make a name sound stronger.
- Prefer names at the level of the domain rather than names that expose the current storage or algorithm.
- Name parameters for their meaning and units, such as `timeout_seconds` rather than `timeout`.
- Avoid vague names such as `data`, `thing`, `manager`, `helper`, and `util` when a domain name is available.
- Avoid unexplained abbreviations, except for established project or domain vocabulary.
- Keep a method name focused on one role; a name containing `and` often signals two responsibilities.
- Choose collection names that are plural and element names that are singular.
- Make negative predicates read naturally, and avoid double negatives at call sites.
- Express intent and constraints through names, types, and structure. Do not add prose comments or source notes. Preserve mandatory notices and tool-required directives.
