# PHP language changes

Use the language floor from `composer.json` and `config.platform.php`. This reference records notable PHP 8.4 and 8.5 changes, plus PHP 8.6 preview notes captured on 2026-11-17. Check the version-specific [PHP migration guide](https://www.php.net/manual/en/appendices.php) before relying on a feature.

## PHP 8.4

- Property hooks and asymmetric visibility can replace trivial getter and setter pairs when they fit the existing design.
- `#[\Deprecated]` marks functions, methods, and class constants.
- `array_find()`, `array_find_key()`, `array_any()`, and `array_all()` cover common array searches.
- `Dom\HTMLDocument` parses HTML5, `BcMath\Number` represents immutable arbitrary-precision numbers, and `PDO::connect()` returns a driver-specific PDO subclass.
- Implicitly nullable declarations such as `Type $value = null` are deprecated. Write `?Type $value = null`.

See [PHP 8.4 new features](https://www.php.net/manual/en/migration84.new-features.php) and its migration notes.

## PHP 8.5

- The pipe operator `|>` passes a value through callables from left to right. Use it only when the project's PHP floor allows it.
- `clone($object, ['property' => $value])` clones an object with selected property changes. `array_first()` and `array_last()` return `null` for an empty array.
- Static closures and first-class callables are allowed in constant expressions. `#[\Override]` applies to properties, and promoted constructor properties may be `final`.
- The built-in `Uri\Rfc3986\Uri` and `Uri\WhatWg\Url` APIs are available for URL parsing and comparison.
- Long casts such as `(integer)` and `(boolean)`, the backtick shell operator, `null` array offsets, and `__sleep()` and `__wakeup()` are deprecated.
- PHP 8.5 deprecates several no-op resource close calls and the legacy `$http_response_header` variable. Check the migration notes before changing compatibility code.

See [PHP 8.5 new features](https://www.php.net/manual/en/migration85.new-features.php) and its migration notes.

## PHP 8.6 preview

On 2026-11-17, PHP's official archive marked 8.6.0 RC7 as a test release and said not to use it in production. Treat every 8.6 item below as preview information, not a target for production code. Check the [official release status and NEWS](https://www.php.net/archive/2026.php) and the [UPGRADING notes](https://github.com/php/php-src/blob/PHP-8.6/UPGRADING) again before migration.

The preview introduces partial function application, `clamp()`, readonly property defaults, `Time\Duration`, additional URI builders, and session default changes. It also deprecates `return` inside `finally`, `spl_object_hash()`, several legacy type aliases, and additional APIs. Review the project's real session, database, and library behavior before changing code for a preview deprecation.
