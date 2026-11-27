# PHP

Read the version from the `require` section of `composer.json` or `php --version`. Enums and `readonly` properties need PHP 8.1, and `readonly` classes need 8.2.

## Pitfalls

- Start every file with `declare(strict_types=1);` right after the opening tag. Without it PHP converts scalar arguments silently, so `"5"` becomes `5` and `true` becomes `1`.
- Type every parameter, return value and property. Write a nullable type as `?T` and put `null` last in a union.
- Declare the visibility of every property, method and constant, in place of `var` or an underscore prefix for private members.
- Compare with `===` and `!==`, and pass `true` as the third argument of `in_array` and `array_search`, because loose comparison converts types.
- Build SQL with PDO prepared statements and bound parameters, and set `PDO::ATTR_ERRMODE` to `PDO::ERRMODE_EXCEPTION`.
- Hash passwords with `password_hash`, check them with `password_verify`, and escape output with `htmlspecialchars` at the point of output.
- Use the `mb_*` functions for text that may hold non-ASCII characters, and `utf8mb4` in MySQL.
- Handle errors explicitly in place of `@`, and use arrays or objects in place of `extract`, `eval` and variable variables.
- Pass dependencies through the constructor in place of the container, so the class shows what it needs.

## Composer

Commit `composer.lock` and run `composer install` in CI and on deploy. `composer update` changes versions, so keep it for a deliberate upgrade.

## Tools

When the project defines none, format to PER Coding Style with `php-cs-fixer` or `phpcs`, analyse with `phpstan` or `psalm`, check syntax with `php -l`, and test with `phpunit` or `pest`.
