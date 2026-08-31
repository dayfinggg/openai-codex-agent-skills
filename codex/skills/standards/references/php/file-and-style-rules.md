# File and style rules

- Use UTF-8 without a byte-order mark and use only `<?php` or `<?=` tags.
- Keep declaration files free of include-time work such as output, I/O, configuration mutation, or service connections.
- Put executable bootstrapping in an explicit entry point, not beside class declarations.
- Keep one externally consumable class, interface, enum, or trait per file.
- Use namespaces and an autoloading PSR, normally PSR-4.
- Use PascalCase class names, camelCase methods, and UPPER_SNAKE_CASE class constants.
- Choose one property naming convention per package and apply it consistently.
- Follow PSR-12 for four-space indentation, no tabs, LF endings, no closing PHP tag, and a 120-character soft line limit.
- Run a formatter or fixer in check mode in CI; PHP CS Fixer supports a PSR-12 ruleset and a non-mutating `check` command.
- Let the formatter settle whitespace; spend review time on behavior, contracts, and boundaries.
