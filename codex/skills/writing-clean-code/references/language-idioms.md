# Language idioms

Project configuration always wins over this file. When a project has a formatter, linter, or style guide, follow it.

## Contents

- Python
- JavaScript and TypeScript
- Java and Kotlin
- C#
- Go
- Rust
- PHP
- SQL
- Shell

## Python

- Follow PEP 8. Use `snake_case` for functions and variables, `PascalCase` for classes, `UPPER_SNAKE_CASE` for constants.
- Use the project's formatter and linter, such as Ruff or Black.
- Add type hints to new public functions when the project uses them.
- Use `dataclass` or `NamedTuple` for plain data, `Enum` for fixed sets of values.
- Use context managers (`with`) for files, locks, and connections.
- Use comprehensions for simple transforms. Switch to a loop when a comprehension needs nested conditions.
- Never use a mutable default argument. Use `None` and create the value inside.
- Catch specific exceptions, never bare `except:`. Re-raise with `raise ... from err` to keep the cause.
- Use `pathlib` for paths and f-strings for formatting.

## JavaScript and TypeScript

- Use `const` by default, `let` when reassignment is needed, never `var`.
- Use `===` and `!==`.
- In TypeScript enable `strict`. Avoid `any`, prefer `unknown` plus narrowing. Model variants with discriminated unions.
- Use `async`/`await` instead of nested callbacks or long `.then` chains, and always handle rejected promises.
- Use optional chaining `?.` and nullish coalescing `??` instead of manual checks.
- Prefer named exports, keep modules small and focused.
- Use the project's ESLint and Prettier configuration.

## Java and Kotlin

- Java naming uses `camelCase` methods and fields, `PascalCase` types, `UPPER_SNAKE_CASE` constants.
- Use `Optional` for return values that may be absent, not for fields or parameters.
- Use records for immutable data carriers and `final` fields where possible.
- Use try-with-resources for anything `AutoCloseable`.
- Use streams for clear pipelines and plain loops when a stream gets hard to read.
- Prefer constructor injection, keep classes small, depend on interfaces at boundaries.
- In Kotlin prefer `val`, data classes, null-safety operators, and expression bodies for short functions.

## C#

- `PascalCase` for types, methods, and properties, `camelCase` for locals and parameters, `_camelCase` for private fields.
- Suffix asynchronous methods with `Async`, return `Task`, and avoid `async void` except event handlers.
- Enable nullable reference types.
- Use `using` declarations for disposables.
- Use records for immutable data and LINQ for readable queries over collections.

## Go

- Run `gofmt`. Follow Effective Go naming, with short names for small scopes and `MixedCaps` instead of underscores.
- Return errors as values and wrap them with context, as in `fmt.Errorf("load config: %w", err)`.
- Handle errors first and return early, so the happy path stays unindented.
- Accept interfaces, return concrete types. Keep interfaces small and define them where they are used.
- Use `defer` for cleanup.
- Pass `context.Context` as the first parameter of functions that do I/O.

## Rust

- Run `rustfmt` and `clippy`.
- Return `Result` and propagate with `?`. Avoid `unwrap` and `expect` in library code.
- Model states with enums and exhaustive `match`.
- Prefer borrowing over cloning and iterators over index loops.

## PHP

- Follow PSR-12 and declare `strict_types=1`.
- Type every parameter, property, and return value.
- Use constructor property promotion and readonly properties for value objects.
- Use prepared statements for every query.

## SQL

- List columns explicitly instead of `SELECT *`.
- Always use parameterized queries, never string concatenation with user input.
- Use meaningful table aliases and consistent keyword casing.
- Break long queries into common table expressions with descriptive names.

## Shell

- Start Bash scripts with `set -euo pipefail`.
- Quote every variable expansion, as in `"$file"`.
- Use functions with clear names for repeated steps.
- Prefer `$(...)` over backticks.
- Run `shellcheck` when available.
