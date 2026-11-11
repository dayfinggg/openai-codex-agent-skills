---
name: php
description: Gives current PHP practice for language features, Composer, static analysis, and tests, with Laravel and Symfony references. Use it whenever you write, review, upgrade, or set up PHP code, including Composer packages, PHPStan or Rector configuration, and PHPUnit or Pest tests. Use it for every Laravel or Symfony change, because it routes to framework references for Eloquent, validation, queues, testing, Doctrine, Messenger, forms, and voters.
license: MIT
---

<project_first>
The project's own PHP version and tools come first, as `code_rules` requires. Read `composer.json` for `require.php`, `config.platform.php`, the framework, and the dev tools. Read `composer.lock` or run `composer show <vendor/package>` for the installed versions. Use only language features that the lowest allowed PHP version supports. Run tools the way the project runs them, such as `composer` scripts, `vendor/bin/`, a Makefile, Docker, or Sail. The modern defaults in this skill apply to new projects, or when the user asks for them.
</project_first>

<framework_references>
The framework reference files hold rules that this file does not repeat. Composer's `require` section shows the framework. Read a file whole before you change code on its topic, also when the work reaches that topic later in the task.
- In a project that requires `laravel/framework`, read [laravel.md](references/laravel.md) first. It covers versions, structure, Artisan, and Pint.
- For Eloquent models, queries, eager loading, indexes, and migrations, read [laravel-database.md](references/laravel-database.md).
- For routes, controllers, middleware, form requests, validation, authorization, outbound HTTP calls, and error handling, read [laravel-http.md](references/laravel-http.md).
- For queued jobs, scheduled tasks, events, notifications, mail, and caching, read [laravel-async.md](references/laravel-async.md).
- For actions, dependency injection, config and environment values, locks, collections, and Blade, read [laravel-app.md](references/laravel-app.md).
- For Pest or PHPUnit tests in a Laravel project, read [laravel-testing.md](references/laravel-testing.md), and for factories, fakes, time, and suite speed read [laravel-testing-data.md](references/laravel-testing-data.md).
- In a project that requires `symfony/framework-bundle`, read [symfony.md](references/symfony.md). It targets Symfony 7.4 LTS and 8.x and covers services and autowiring, Messenger, forms and validation, voters, DTOs, and quality checks.
- In a project that uses Doctrine ORM, also read [symfony-doctrine.md](references/symfony-doctrine.md) for relations, fetch modes, batch processing, and transactions with ORM 3.

Every other rule of this file holds for any PHP code. A project on another framework, a CMS, or an engine of its own follows that code's existing patterns and its documentation for the installed version.
</framework_references>

<php_versions>
On November 11, 2026, PHP 8.5 was the newest stable branch and PHP 8.6 was at RC5, with general availability planned for November 19, 2026. Each branch gets 2 years of active support and 2 more years of security fixes, as [php.net](https://www.php.net/supported-versions.php) lists.

| Branch | Released | Active support until | Security fixes until |
| --- | --- | --- | --- |
| 8.2 | December 8, 2022 | December 31, 2024 | December 31, 2026 |
| 8.3 | November 23, 2023 | December 31, 2025 | December 31, 2027 |
| 8.4 | November 21, 2024 | December 31, 2026 | December 31, 2028 |
| 8.5 | November 20, 2025 | December 31, 2027 | December 31, 2029 |

A new project targets PHP 8.4 or 8.5. Laravel 13 needs PHP 8.3 or later, and Symfony 8 needs PHP 8.4 or later.
</php_versions>

<php_8_4>
PHP 8.4 adds these features, which apply when the project allows PHP 8.4 or later. The [8.4 release page](https://www.php.net/releases/8.4/en.php) has the full list.
- Property hooks give a property `get` and `set` logic, as in `public string $name { set => trim($value); }`. Interfaces can declare hooked properties.
- Asymmetric visibility separates read and write access, as in `public private(set) string $version`.
- `#[\Deprecated]` marks user functions, methods, and class constants as deprecated.
- `array_find`, `array_find_key`, `array_any`, and `array_all` replace manual search loops when the code does not use collections.
- A method call on `new Foo()` needs no wrapping parentheses, as in `new Foo()->run()`.
- Lazy objects come from `ReflectionClass::newLazyGhost()` and `newLazyProxy()`.
- `Dom\HTMLDocument` parses HTML5, and `BcMath\Number` is an immutable number object with operators.
- `mb_trim`, `mb_ucfirst`, `mb_lcfirst`, the `RoundingMode` enum, and `PDO::connect()` with driver subclasses such as `Pdo\Sqlite` are new.

PHP 8.4 deprecates implicitly nullable parameters. Write `?Type $x = null` instead of `Type $x = null`. It also deprecates `E_STRICT` and `trigger_error()` with `E_USER_ERROR`.
</php_8_4>

<php_8_5>
PHP 8.5 adds these features, which apply when the project allows PHP 8.5 or later. The [8.5 release page](https://www.php.net/releases/8.5/en.php) has the full list.
- The pipe operator `|>` passes a value through callables from left to right. It replaces nested calls, as in `$slug = $title |> trim(...) |> strtolower(...);`.
- `clone($object, ['prop' => $value])` changes properties while it clones, which suits `readonly` classes.
- `array_first()` and `array_last()` return the first or last value, or `null` for an empty array.
- `#[\NoDiscard]` warns when a caller ignores the return value, and a `(void)` cast marks an intentional discard.
- The built-in URI extension parses URLs with `Uri\Rfc3986\Uri` and `Uri\WhatWg\Url`. Prefer it over `parse_url()` in new code.
- Static closures and first-class callables work in constant expressions, such as attribute arguments and default values.
- Constructor promotion accepts `final` properties, and `#[\Override]` works on properties.

PHP 8.5 deprecates the backtick operator, the casts `(boolean)`, `(integer)`, `(double)`, and `(binary)`, and `null` as an array offset. It soft-deprecates `__sleep()` and `__wakeup()` in favor of `__serialize()` and `__unserialize()`.
</php_8_5>

<php_8_6>
Use PHP 8.6 features only in a project that already requires 8.6. Its [UPGRADING](https://github.com/php/php-src/blob/PHP-8.6/UPGRADING) file lists these changes.
- Partial function application creates a closure with `?` for one missing argument and `...` for the rest.
- `clamp()` limits a value to a range.
- Readonly properties can declare default values.
- `Time\Duration` is a new class in the date extension.
- A `return` inside `finally` is deprecated, and so are `spl_object_hash()`, `is_long()`, `is_integer()`, `is_double()`, and `doubleval()`.
</php_8_6>

<code_style>
Modern PHP code follows these defaults where the project has no other convention.
- Start each new file with `declare(strict_types=1);` if the project's other files do, and in every new project. Strict types apply to calls made from that file, so a caller without it still gets type coercion.
- Use curly braces for every control structure, even a single-line body.
- Use constructor property promotion, and remove an empty constructor without parameters unless it is private.
- Declare parameter, return, and property types everywhere. Prefer `readonly` properties or `readonly` classes for value objects.
- Use backed enums instead of class constants for a fixed set of values. Name enum cases in PascalCase, such as `Monthly`, unless the project's enums use another style.
- Add a PHPDoc type tag only for types that native types cannot express, such as `list<User>`, `array{id: int, name: string}`, generics, and `@throws`. PHPStan and the Symfony serializer read these tags as types, so the rule on comments in `code_rules` does not cover them. Write no descriptive PHPDoc text.
- Use `match` instead of `switch` when each branch returns a value, and use first-class callables such as `strlen(...)`.

The shared format is [PER Coding Style 3.1](https://www.php-fig.org/per/coding-style/), which extends PSR-12. It also covers enums, property hooks, asymmetric visibility, and the pipe operator. Run the formatter that the project has configured. Laravel projects use Pint, many others use PHP-CS-Fixer with the `@PER-CS` rule set, and some use PHP_CodeSniffer. Format only the files you change.
</code_style>

<composer>
Composer manages dependencies and autoloading. The current release in November 2026 is 2.11.
- Add a package with `composer require vendor/package`, and a dev tool with `composer require --dev vendor/package`. Never edit `composer.lock` by hand.
- Install from the lockfile with `composer install`, and in CI or production add `--no-dev --optimize-autoloader` where the project deploys that way.
- Update one package with `composer update vendor/package --with-dependencies`. Add `--minimal-changes` to keep the other locked versions.
- Run `composer audit` to check installed packages against security advisories. Composer 2.10 and later can also block versions flagged for malware through the `policy` config.
- Run `composer validate --strict` after you edit `composer.json`, and `composer dump-autoload` after you change the `autoload` section.
- Map namespaces with PSR-4 in `autoload` and `autoload-dev`, so that each class lives in a file that matches its name.
</composer>

<static_analysis>
PHPStan is the common static analyzer, and its current major is 2.x. Its [rule levels](https://phpstan.org/user-guide/rule-levels) run from 0 to 10, and `max` is level 10. Level 9 rejects most operations on explicit `mixed`, and level 10 also rejects implicit `mixed` from missing types. Read the level and paths from `phpstan.neon` or `phpstan.neon.dist`, and run `vendor/bin/phpstan analyse`. A legacy project often keeps a baseline file that `vendor/bin/phpstan analyse --generate-baseline` created. Leave existing baseline entries alone, and keep new code free of new errors. Framework extensions improve the results, such as `larastan/larastan` for Laravel and `phpstan/phpstan-symfony` with `phpstan/phpstan-doctrine` for Symfony. A project that uses Psalm instead keeps its `psalm.xml` and runs `vendor/bin/psalm`.

Fix type errors in the code. Do not hide them, as the `verification` block of the coding instructions requires.
</static_analysis>

<rector>
Rector rewrites code automatically, for example to adopt newer PHP syntax or remove dead code. Its current major is 2.x. Run `vendor/bin/rector process --dry-run` first to see the diff. Then run `vendor/bin/rector process` on the paths of the task only. This `rector.php` reads the PHP version from `composer.json` and enables two prepared sets.

```php
<?php

use Rector\Config\RectorConfig;

return RectorConfig::configure()
    ->withPaths([
        __DIR__ . '/src',
        __DIR__ . '/tests',
    ])
    ->withPhpSets()
    ->withPreparedSets(deadCode: true, codeQuality: true);
```

An existing project adopts Rector gradually with `withTypeCoverageLevel(0)`, `withDeadCodeLevel(0)`, or `withPhpLevel(0)`, and raises the level step by step. `withComposerBased()` adds sets that match the installed framework packages, such as Laravel, Symfony, Doctrine, and PHPUnit.
</rector>

<testing>
Use the test runner that the project already has. PHPUnit 13 needs PHP 8.4 and PHPUnit 12 needs PHP 8.3, and both [read metadata only from attributes](https://phpunit.de/announcements/phpunit-12.html). Write `#[Test]`, `#[DataProvider('cases')]`, and `#[CoversClass(Foo::class)]` instead of docblock annotations such as `@test`. Data provider methods are `public static`. Pest 5 runs on PHPUnit 13 and needs PHP 8.4, and Pest 4 runs on PHPUnit 12. Run one file or test with `vendor/bin/phpunit tests/FooTest.php --filter testName` or `vendor/bin/pest tests/FooTest.php --filter "name"`. The `tdd` and `testing` skills cover test design.
</testing>
