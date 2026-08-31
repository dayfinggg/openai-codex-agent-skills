# Packages, modules, and Composer

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
