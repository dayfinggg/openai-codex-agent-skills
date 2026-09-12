# File and style rules

- Use UTF-8 without a byte-order mark and use only `<?php` or `<?=` tags.
- Keep declaration files free of include-time work such as output, I/O, configuration mutation, or service connections.
- Put executable bootstrapping in an explicit entry point, not beside class declarations.
- Keep one externally consumable class, interface, enum, or trait per file.
- Use namespaces and an autoloading PSR, normally PSR-4.
- Use PascalCase class names, camelCase methods, and UPPER_SNAKE_CASE class constants.
- Choose one property naming convention per package and apply it consistently.
- Preserve the checked-in formatter and style contract. For a new project, consider PHP-FIG PER Coding Style for modern syntax using a compatible formatter. Keep PSR-12 where already adopted; do not restyle a legacy project as part of unrelated work.
- Run the installed formatter or fixer in non-mutating check mode in CI. Select its documented command and ruleset for that version and target PHP, rather than assuming current CLI syntax exists in an older release.
- Let the formatter settle whitespace; spend review time on behavior, contracts, and boundaries.
