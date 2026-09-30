# PHP

## Runtime and conventions

- Follow the installed PHP version and project style. Prefer `declare(strict_types=1);` in new typed files without changing coercion contracts of unrelated legacy code.
- Use supported native types. Docblocks cover what native types cannot express, such as generics or array shapes. Typed class constants require PHP 8.3 or later.
- Prefer PER Coding Style for a new project when appropriate. Keep existing formatter rules rather than converting working code to a newer style.
- PSR-4 autoloading in `composer.json`, tests under `autoload-dev`.
- Use `readonly`, enums and `match` only where the runtime supports them and their semantics fit the contract. A `switch` to `match` conversion changes comparison behavior.
- Use `===` and `!==` when coercion is not part of the contract. Check APIs returning `false` explicitly so valid zero values are not treated as failure.

## Features by version

Use what the project's `require.php` constraint allows.

| Version | Use |
|---|---|
| 8.3+ | Typed class constants, `#[\Override]`, `json_validate()` |
| 8.4+ | Property hooks, asymmetric visibility (`public private(set)`), `new Foo()->bar()` without wrapping parentheses, `array_find`, `array_any`, `array_all`, `#[\Deprecated]` |
| 8.5+ | Pipe operator `\|>`, `clone($obj, ['prop' => $value])` for readonly updates, `array_first`, `array_last`, `#[\NoDiscard]` |

## Errors and resources

- Throw specific exception classes for domain errors, extending the closest SPL exception such as `InvalidArgumentException` or `RuntimeException`. Wrap lower-level errors with the `previous` argument.
- Release resources in `finally`. Keep PDO in exception error mode, which is the default since PHP 8.0.
- Set a timeout on every HTTP client request.

## Checks and tooling

Use existing Composer scripts and installed tools, such as PHPUnit or Pest, PHPStan, Pint or PHP-CS-Fixer. Run checks scoped to the change and keep project limits. Rector and migration fixer sets can change behavior across many files. Use them only for a requested upgrade, inspect their proposed changes first and do not apply unrelated transformations.
