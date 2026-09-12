# Version compatibility

## Establish the contract

- Record the minimum and maximum promised PHP versions, framework and package ranges, required extensions, and runtime mode. Check web/FPM, CLI, scheduled jobs, and workers separately when they differ.
- Keep modern syntax out of files parsed by older supported interpreters. A `PHP_VERSION_ID` condition cannot hide unsupported syntax in the same file. Prefer common syntax over version-specific implementations unless a real requirement needs separate loading.
- Do not raise `require.php`, extension requirements, framework versions, or the lock file's runtime floor as incidental cleanup. A support-range change needs explicit scope and consumer verification.
- Compatibility is not upstream security support. As checked on 2026-09-12, PHP 8.2 and 8.3 receive security fixes, while 8.4 and 8.5 receive active support. PHP 8.1 and older are end of life. Recheck the [official support table](https://www.php.net/supported-versions.php) rather than freezing this snapshot into project policy.

## Feature gates and alternatives

These are introduction versions, not a requirement to adopt a feature. Verify finer restrictions in the relevant migration guide before use.

| Minimum PHP | Available features | When supporting earlier PHP |
| --- | --- | --- |
| 7.0 | Scalar parameter and return declarations, `strict_types`, `Throwable`, `??` | Preserve PHP 5-compatible declarations and established guards. `Exception` cannot substitute for the PHP 7 engine-error hierarchy. |
| 7.1 | Nullable types, `void`, `iterable` | Keep compatible signatures and validate values without adding unsupported declarations. |
| 7.2 | `object` type | Use a specific supported class/interface or the existing untyped contract. |
| 7.4 | Typed properties, arrow functions | Use declared untyped properties and ordinary closures. |
| 8.0 | Unions, `mixed`, attributes, constructor promotion, named arguments, `match`, nullsafe access | Use ordinary constructors, compatible signatures, existing metadata, and explicit branches. Preserve strict comparison when replacing `match`. |
| 8.1 | Enums, readonly properties, intersections, `never`, first-class callable syntax | Use validated values/constants, encapsulation, and supported callables. Preserve existing serialized values. |
| 8.2 | Readonly classes, DNF types, standalone `null`/`false`/`true` types | Use supported classes and simpler signatures without changing the accepted values. |
| 8.3 | Typed class constants | Keep constants untyped on earlier runtimes. |
| 8.4 | Property hooks, asymmetric property visibility, native lazy objects | Keep ordinary properties and methods or the framework's compatible proxy mechanism. |
| 8.5 | Pipe operator and `clone` with property updates | Use direct calls and existing copy methods. Do not rewrite for syntax alone. |

- PHP 5 maintenance requires the exact minor version, including support for closures, namespaces, traits, short arrays, and `finally`. Do not assume that a PHP 7 fallback is PHP 5-compatible. Preserve the existing implementation if a replacement cannot be exercised on the promised runtime.
- Polyfills can supply selected functions/classes, not new parser syntax or engine semantics. Use one only for an actual supported environment, with compatible dependencies and tests.
- Native additions to public APIs can break inheritance, mocks, reflection, ORM hydration, serialization, and named-argument callers. Preserve parameter names where consumers use named arguments. Check consumers before adding `final`, `readonly`, or stricter types.
- Treat PHP 8 comparison/error changes, PHP 8.2 dynamic-property deprecations, and PHP 8.4 implicit-nullability deprecations as behavior-sensitive work. Use the migration guides for each crossed minor version. Do not globally suppress deprecations or mass-convert signatures.

## Dependencies and verification

- `config.platform.php` guides Composer's resolver but does not emulate PHP. Declare the support range in `require.php`, set platform emulation only for a real deployment target, and run `composer check-platform-reqs` against the actual installation and runtime.
- Match Composer, PHPUnit, analyzers, formatters, PSR interface package majors, and framework plugins to their own PHP requirements. If modern tooling runs separately, configure the source target explicitly and still execute tests on the minimum runtime.
- Lint changed files on the oldest supported interpreter. Exercise supported runtime branches and dependency combinations in CI. For libraries, test a resolvable lowest supported dependency set separately from normal resolution. Do not overwrite the application's production lock file for this experiment.
- Composer platform checks and static analysis do not prove runtime compatibility. If an old interpreter or dependency set is unavailable, report the untested versions explicitly rather than claiming full support.

Sources: [PHP type declarations](https://www.php.net/manual/en/language.types.declarations.php), [PHP migration guides](https://www.php.net/manual/en/appendices.php), [Composer configuration](https://getcomposer.org/doc/06-config.md), and [PHPUnit support matrix](https://phpunit.de/supported-versions.html).
