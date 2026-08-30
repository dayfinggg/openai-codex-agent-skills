# Modern PHP quality standard

Use this guide as a practical baseline for new PHP code and as a review checklist for existing code.
Treat project constraints, supported PHP versions, framework conventions, and generated code as explicit exceptions.
Set the minimum PHP version in `composer.json`; do not leave the runtime contract implicit.

## File and style rules

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

## Strict, explicit types

- Start every PHP source file with `declare(strict_types=1);` unless an identified interoperability boundary requires otherwise.
- Strict typing is file-scoped and affects calls made from the strict caller, so migrate callers as well as declarations.
- Strict typing applies to scalar declarations; it does not make every PHP operation statically safe.
- Type every parameter, return value, property, promoted constructor parameter, and public constant where the language permits it.
- Prefer the narrowest useful native type: a domain class or interface is clearer than `array` or `object`.
- Use `?T`, unions, intersections, `void`, `never`, and enums when they describe the real contract.
- Use `false` and `true` types only when the API genuinely returns those sentinel values.
- Avoid `mixed`; confine it to an unavoidable boundary and normalize the value immediately.
- Model a stable record as a value object, DTO, or enum instead of an unbounded associative array.
- When an array is the right structure, document its key and value types, list shape, or array shape in PHPDoc.
- Use analyzer-specific generics or type aliases only where they add information that native PHP cannot express.
- Treat a PHPDoc assertion as a proof obligation; never use `@var` to silence an error without checking the value.
- Psalm notes that an explicit `@var` can override inferred types and weaken checking, so prefer a runtime guard or a better signature.
- Keep input validation at the boundary and pass normalized domain values inward.
- Use `===` and `!==` by default; make any intentional coercion visible at the boundary.
- Return one documented result shape; avoid APIs that mix a value, `false`, `null`, and exceptions without a reason.

## Errors and exceptions

- Use exceptions for exceptional failures and return values for ordinary, expected outcomes.
- Throw domain-specific exceptions that preserve the failing operation and relevant safe context.
- Catch the narrowest exception that can be handled at that layer.
- Catch `Throwable` only at an application boundary, a worker loop, or a deliberate logging or recovery boundary.
- Translate infrastructure exceptions into a stable application contract at the boundary.
- Re-throw with the original exception as `previous` when adding context; do not discard the causal chain.
- Never leave an empty `catch` block unless the code documents why the failure is intentionally ignored.
- Use `finally` for cleanup that must run on success and failure; do not return from `finally`.
- Configure `E_ALL` during development and test; log production failures without exposing stack traces or secrets to users.
- Avoid the error-control operator `@`; it hides unrelated failures and makes diagnosis harder.
- Use a PSR-3 logger when a component needs logging; put an exception in the `exception` context key and keep messages stable.

## Dependency injection and design

- Prefer constructor injection with typed parameters and `private readonly` properties for required immutable collaborators.
- Keep an object usable immediately after construction; avoid setter or property injection that creates temporal coupling.
- Depend on an interface when substitution, a port, or an external boundary is part of the design; use a concrete class when no seam is needed.
- Keep the composition root responsible for selecting implementations and wiring object graphs.
- Do not inject a service container into normal domain or application services.
- PSR-11 explicitly discourages using a container inside an object as a service locator.
- If a dependency is selected dynamically, inject a typed factory or a small resolver rather than the whole container.
- Keep domain objects independent of HTTP, database, filesystem, and framework services where practical.
- Keep controllers, commands, and message handlers thin; delegate business rules to application or domain services.
- Separate policy, orchestration, persistence, and presentation responsibilities even when they start in one module.
- Prefer composition over inheritance; make a class `final` when extension is not part of its contract.

## Packages, modules, and Composer

- Use `src/` for production code and `tests/` for tests; add `bin/`, `config/`, `public/`, and `var/` only when their roles are clear.
- Organize namespaces by ownership and capability, not by arbitrary technical layers alone.
- Map each namespace prefix to a base directory with Composer PSR-4 autoloading.
- Match namespace separators, directory names, file names, and class-name case exactly; PSR-4 lookup is case-sensitive.
- Keep test-only classes in `autoload-dev` so production consumers do not load them.
- Keep the root `composer.json` authoritative for runtime PHP and extension requirements.
- Put runtime libraries in `require` and formatters, analyzers, and test frameworks in `require-dev`.
- Use package names, descriptions, licenses, and stable version constraints that describe the published contract.
- Commit `composer.lock` for deployable applications and use `composer install` in CI and production.
- Use `composer update` only when intentionally changing dependency versions, then review the lock-file diff.
- Run `composer validate` before commits and releases; it checks the manifest and, when present, lock-file freshness.
- Run `composer audit` in a dependency-security job and investigate advisories, abandoned packages, and malware findings.
- Regenerate autoload files after changing mappings; use optimized autoloading for production deployments.
- Ignore `vendor/` in application source control unless a packaging policy explicitly requires vendoring.
- Keep Composer scripts small, deterministic, and safe to run in a clean checkout.
- Use the maintained Symfony Demo repository as a concrete reference for `src/`, `tests/`, Composer autoloading, PHPStan, and PHPUnit configuration.

## Static analysis

- Install PHPStan and/or Psalm as development dependencies and run them on code owned by the project.
- Analyze `src/` and relevant tests; do not analyze `vendor/` as if the project could fix third-party code.
- Start at a level the codebase can sustain, remove errors, and raise the level in controlled increments.
- PHPStan levels are cumulative; its current documented scale runs from level 0 to level 10.
- Treat a baseline as migration inventory, not as permission to add new suppressions.
- Make every suppression narrow, named, justified, and reviewed for removal.
- Keep analyzer configuration and stubs in version control.
- Prefer native types first, standard PHPDoc second, and analyzer-specific syntax only when needed for generics, shapes, or templates.
- Use Psalm's `array<K,V>`, `list<T>`, and `array{...}` forms to state collection invariants that `array` alone cannot state.
- Run analysis against the same PHP version and extensions used by the test matrix.
- Make static analysis, syntax linting, formatting checks, and Composer validation required CI jobs.
- PHPStan's own analyzer source is a useful verified example of strict types, typed constructor injection, and precise collection annotations.

## Testing

- Name a test class after the subject with a `Test` suffix and keep it under `tests/`.
- PHPUnit's basic convention is a `TestCase` subclass with public `test*` methods or an explicit `#[Test]` attribute.
- Prefer `assertSame` when identity of type and value matters.
- Call `expectException` immediately before the operation expected to throw.
- Use data providers for a behavior matrix; keep each dataset readable and purposeful.
- Test public behavior, domain invariants, failure contracts, and side effects at their narrowest useful boundary.
- Use unit tests for deterministic domain logic and integration or contract tests for adapters and framework wiring.
- Replace time, randomness, network, and filesystem globals with injected clocks, ports, or fakes.
- Keep tests independent, repeatable, and free of hidden order or shared mutable state.
- Coverage is evidence of exercised paths, not proof of correctness; prioritize meaningful assertions and edge cases.
- Test the supported PHP versions and dependency ranges that the package promises to support.
- Use traceable conference talks such as Dave Liddament's cited material to align a team on type safety and static analysis. Treat talks as practitioner guidance rather than language requirements.

## Naming and documentation

- Name classes after stable concepts and roles, not vague buckets such as `Helper`, `Manager`, or `Util`.
- Use verbs for commands and queries that reveal intent; use `is*`, `has*`, and `can*` for boolean predicates.
- Name interfaces by capability or port, and name adapters by the technology they wrap.
- Keep abbreviations rare and use the domain vocabulary consistently.
- Add PHPDoc when it explains invariants, array shapes, templates, side effects, deprecations, or exceptions.
- Do not duplicate an accurate native declaration with redundant PHPDoc.
- Document why a surprising constraint exists, not what an obvious line of code does.
- Keep public API documentation and examples executable or covered by tests.

## Size and cohesion heuristics

- Treat size numbers as review signals, not universal laws; generated code, protocol adapters, and framework entry points may be exceptions.
- A method that needs many branches, comments, or setup steps is a candidate for extraction around a named concept.
- PHPMD's defaults flag methods over 100 lines, classes over 1,000 lines, ten or more parameters, fifteen or more fields, twenty-five or more methods, and ten or more public methods.
- PHPMD also uses weighted method count 50 as a class-complexity threshold and describes excessive public surface as harder to test.
- Prefer stricter team triggers when the codebase permits them, but change thresholds only with examples and an agreed remediation path.
- A cohesive class keeps methods around the same state, invariant, or use case.
- If methods form separate groups with different collaborators or reasons to change, split the class or introduce a collaborator.
- Measure coupling and lack of cohesion over time; PhpMetrics exposes efferent coupling, complexity, class length, and LCOM metrics.
- A small class with one cohesive responsibility is better than several anemic classes created only to satisfy a line count.
- Refactor when a change routinely touches unrelated methods, requires many mocks, or exposes data that another object should own.

## Practical CI order

Run `composer validate` and `php -l` first, then the formatter check, static analysis, unit tests, integration tests, and `composer audit`.
Review new public API, dependency changes, suppressions, and threshold exceptions as part of the same change.

## Sources

### Official specifications and documentation

- [PHP Manual: Type system](https://www.php.net/manual/en/language.types.type-system.php)
- [PHP Manual: Type declarations and strict typing](https://www.php.net/manual/en/language.types.declarations.php)
- [PHP Manual: Exceptions](https://www.php.net/manual/en/language.exceptions.php)
- [PHP Manual: Error basics](https://www.php.net/manual/en/language.errors.basics.php)
- [PHP-FIG PSR-1: Basic Coding Standard](https://www.php-fig.org/psr/psr-1/)
- [PHP-FIG PSR-12: Extended Coding Style](https://www.php-fig.org/psr/psr-12/)
- [PHP-FIG PSR-4: Autoloader](https://www.php-fig.org/psr/psr-4/)
- [PHP-FIG PSR-11: Container interface](https://www.php-fig.org/psr/psr-11/)
- [PHP-FIG PSR-3: Logger interface](https://www.php-fig.org/psr/psr-3/)
- [Composer: Basic usage](https://getcomposer.org/doc/01-basic-usage.md)
- [Composer: `composer.json` schema](https://getcomposer.org/doc/04-schema.md)
- [Composer: CLI commands](https://getcomposer.org/doc/03-cli.md)
- [PHPStan: Getting started](https://phpstan.org/user-guide/getting-started)
- [PHPStan: Rule levels](https://phpstan.org/user-guide/rule-levels)
- [PHPStan: Configuration reference](https://phpstan.org/config-reference)
- [Psalm: Installation](https://psalm.dev/docs/running_psalm/installation/)
- [Psalm: Typing in Psalm](https://psalm.dev/docs/annotating_code/typing_in_psalm/)
- [Psalm: Array types](https://psalm.dev/docs/annotating_code/type_syntax/array_types/)
- [PHPUnit 12: Writing tests](https://docs.phpunit.de/en/12.2/writing-tests-for-phpunit.html)
- [Symfony: Best practices](https://symfony.com/doc/current/best_practices.html)
- [Symfony: Coding standards](https://symfony.com/doc/current/contributing/code/standards.html)

### Maintainer examples

- [Symfony Demo Application](https://github.com/symfony/demo)
- [Symfony Demo `composer.json`](https://github.com/symfony/demo/blob/main/composer.json)
- [Symfony Demo PHPStan configuration](https://github.com/symfony/demo/blob/main/phpstan.dist.neon)
- [Symfony Demo PHPUnit configuration](https://github.com/symfony/demo/blob/main/phpunit.dist.xml)
- [PHPStan source example with strict types and constructor injection](https://github.com/phpstan/phpstan-src/blob/2.1.x/src/Analyser/Analyser.php)

### Practitioner articles

- [Matthias Noback: Road to dependency injection](https://matthiasnoback.nl/2018/06/road-to-dependency-injection/)
- [Matthias Noback: The dependency injection paradigm](https://matthiasnoback.nl/2021/11/the-dependency-injection-paradigm/)

### Maintainer tooling

- [PHP Coding Standards Fixer: Usage](https://cs.symfony.com/doc/usage)
- [PHPMD: Code size rules](https://phpmd.org/rules/codesize.html)
- [PHPMD: Rule index](https://phpmd.org/rules/index.html)
- [PhpMetrics: Metrics](https://www.phpmetrics.org/documentation/index.html)

### Practitioner talks

- [Dave Liddament: Type Safe PHP talk](https://www.daveliddament.co.uk/talks/type-safe-php)
- [PHPSW: Strict typing and static analysis talk](https://phpsw.uk/talks/strict-typing-and-static-analysis)
- [Neos Conference: Writing strongly typed PHP talk](https://www.neoscon.io/talks/writing-strongly-typed-php-let-types-do-the-testing.html)
