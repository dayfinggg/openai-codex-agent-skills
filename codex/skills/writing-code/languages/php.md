# PHP

## Defaults for every file

- `declare(strict_types=1);` as the first statement.
- Native types on every parameter, return, property and class constant. Docblocks only for what types cannot say, such as generics (`@param list<User>`) or array shapes.
- Coding style is PER Coding Style, which replaced PSR-12: `[]` arrays, trailing commas in multi-line lists, `new Foo()` with parentheses, visibility on everything, `fn($x) => ...`.
- PSR-4 autoloading in `composer.json`, tests under `autoload-dev`.
- `readonly` classes and properties for value objects, enums instead of class constants for fixed sets, `match` instead of `switch`.

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

## Size and complexity limits

PER Coding Style sets a soft line limit of 120 characters. PHPMD's code size rules default to cyclomatic complexity 10, NPath complexity 200, 100 lines per method, 10 parameters, 25 methods and 10 public methods per class. Treat these as upper bounds. Aim for methods under 50 lines, at most 4 parameters and classes under about 300 lines, and split by responsibility when a class grows past that.

## Outdated patterns

Do not write `array()`, `(new Foo())->bar()` on 8.4+, untyped properties or constants, docblocks that repeat native types, `switch` for value mapping, references to PSR-2 or PSR-12, or PHP-CS-Fixer sets with dotted names such as `@PER-CS2.0` or `@PHP80Migration`.

## Fallback commands

- Style: `vendor/bin/php-cs-fixer fix` with `@PER-CS` plus the matching `@PHP8x4Migration` or `@PHP8x5Migration` set. In Laravel projects: `vendor/bin/pint`.
- Static analysis: `vendor/bin/phpstan analyse`, level `max` for new code.
- Automated upgrades: `vendor/bin/rector process --dry-run`, then without `--dry-run`.
- Tests: `vendor/bin/phpunit` or `vendor/bin/pest`, whichever the project uses.
