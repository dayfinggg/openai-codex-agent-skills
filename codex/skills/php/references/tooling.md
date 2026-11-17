# PHP quality tools

This reference records notes for PHPUnit 12 and 13, Rector 2, and PHP-CS-Fixer 3. Read `composer.lock` and the project's scripts first, then check the installed tool's documentation before using version-specific APIs or flags.

## PHPUnit

- PHPUnit 12 requires PHP 8.3 or later, and PHPUnit 13 requires PHP 8.4 or later. Check the [official support table](https://phpunit.de/supported-versions.html) before choosing a major.
- Use attributes for test metadata, data providers, and coverage declarations. PHPUnit 12 removed doc-comment metadata, so an old `@test` or `@dataProvider` annotation may stop a test from running.
- Prefer `createStub()` when the test needs no expectations. Use `withParameterSetsInOrder()` or `withParameterSetsInAnyOrder()` instead of removed `withConsecutive()` behavior.
- Run the repository's configured test command. For a focused run, use its documented file or filter syntax, such as `vendor/bin/phpunit tests/FooTest.php --filter testName`.

## Rector

- Start a rewrite with a dry run and restrict changes to the files in scope.
- `withPhpSets()` can apply PHP migrations up to the version declared by the project. Adopt larger change sets in small, reviewed increments.
- `withComposerBased()` can select rules from installed package versions. Confirm the behavior against the Rector version in `composer.lock`.
- Keep existing baseline entries unchanged and fix new diagnostics rather than suppressing them.

## PHP-CS-Fixer

- Run the configured formatter in check or diff mode before applying a formatter across a legacy project.
- PHP-CS-Fixer 3.88 uses versioned set names such as `@PHP8x4Migration`, `@PHP8x5Migration`, and `@PER-CS3x0`. Confirm names against the installed release.
- Format only files in the task. Do not apply risky fixes without reviewing their behavioral effect.
