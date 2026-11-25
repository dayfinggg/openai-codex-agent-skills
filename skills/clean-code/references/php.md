# PHP

Check the PHP version first, in the `require` section of `composer.json` or with `php --version`. Enums and `readonly` properties need PHP 8.1, and `readonly` classes need 8.2.

## Pitfalls

Start every file with `declare(strict_types=1);` right after the opening tag. Without it PHP converts scalar arguments silently, so `"5"` becomes `5` and `true` becomes `1`.

Declare a type for every parameter, return value and property. Write a nullable type as `?T` and put `null` last in a union.

Declare the visibility of every property, method and constant. Do not use `var`, and do not mark private members with an underscore.

Compare with `===` and `!==`. Loose comparison converts types, and `in_array` and `array_search` need their third argument set to `true` for the same reason.

Never build SQL by concatenation. Use PDO prepared statements with bound parameters, and set `PDO::ATTR_ERRMODE` to `PDO::ERRMODE_EXCEPTION`.

Hash passwords with `password_hash` and check them with `password_verify`. Escape output with `htmlspecialchars` at the point of output.

Use the `mb_*` functions for text that can hold non-ASCII characters, and `utf8mb4` in MySQL.

Do not silence errors with `@`. Do not use `extract`, `eval` or variable variables.

Pass dependencies through the constructor. Passing the container around hides what a class needs.

## Composer

Commit `composer.lock`. Install with `composer install` in CI and on deploy. `composer update` changes versions and belongs to a deliberate upgrade.

## Tools

When the project defines none, format to PER Coding Style with `php-cs-fixer` or `phpcs`, analyse with `phpstan` or `psalm`, and check syntax with `php -l`. Run the tests with `phpunit` or `pest` when the project has them.
