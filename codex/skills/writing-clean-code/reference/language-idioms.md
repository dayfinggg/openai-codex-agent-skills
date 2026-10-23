# Language idioms

Project configuration, formatters, linters, and style guides win over this file.

- Python. PEP 8, with Ruff or Black as the project uses. `dataclass` or `NamedTuple` for plain data, `Enum` for fixed sets, `pathlib` for paths, f-strings for formatting. Use `None` as the default instead of a mutable default argument. Catch specific exceptions, never bare `except:`, and re-raise with `raise ... from err`. Type hints on new public functions when the project uses them.
- JavaScript and TypeScript. `const` by default, `let` when reassignment is needed, never `var`, and `===`. TypeScript in `strict` mode, `unknown` plus narrowing instead of `any`, and discriminated unions for variants. `async` and `await`, with every rejected promise handled. Prefer named exports. Use the project's ESLint and Prettier configuration.
- Java. `Optional` only for return values, not for fields or parameters. Records for immutable data, `final` fields where possible, try-with-resources, and constructor injection.
- Kotlin. `val`, data classes, null-safety operators, and expression bodies for short functions.
- C#. `PascalCase` for types, methods, and properties, `camelCase` for locals and parameters, `_camelCase` for private fields. `Async` suffix on asynchronous methods, which return `Task`, and no `async void` outside event handlers. Nullable reference types on, and `using` declarations for disposables.
- Go. `gofmt` and Effective Go naming. Errors wrapped with context, as in `fmt.Errorf("load config: %w", err)`. Accept interfaces and return concrete types, with small interfaces defined where they are used. `context.Context` is the first parameter of functions that do I/O.
- Rust. `rustfmt` and `clippy`. `Result` with `?`, and no `unwrap` or `expect` in library code. Enums with exhaustive `match` for states.
- PHP. PSR-12 and `declare(strict_types=1)`. Types on every parameter, property, and return value. Constructor property promotion and readonly properties for value objects. Prepared statements for every query.
- Shell. Bash scripts start with `set -euo pipefail`. Quote every expansion, as in `"$file"`, prefer `$(...)` to backticks, and run `shellcheck` when available.
