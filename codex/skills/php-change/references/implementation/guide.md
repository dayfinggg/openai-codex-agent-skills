Apply this workflow to PHP behavior changes. Load an installed framework specialist only for the part of Laravel or Symfony actually being changed.

1. Read repository instructions, target code, callers, composer.json, composer.lock, and nearby tests. Establish the minimum PHP version, required extensions, autoloading, and existing checks. CLI PHP does not establish the FPM runtime.
2. Read version-matched official documentation for the language feature or API being changed. Preserve the supported runtime. A convenient syntax feature does not justify upgrading PHP or adding an extension.
3. Identify the observable contract. Where inputs matter, distinguish a missing key, null, an empty string, zero, and false. Type coercion must not silently replace a business rule.
4. Trace exceptions, returns, and cleanup through HTTP, worker, or command boundaries. Preserve error categories and return shapes that callers depend on.
5. Make the smallest implementation change. Preserve existing strict-types policy, namespaces, and public signatures. Introduce an abstraction only when the requested behavior needs it.
6. Run existing syntax, formatting, PHPStan or Psalm checks and relevant tests. Fix newly introduced findings in the implementation. Do not expand a baseline, lower analysis levels, or add suppressions merely to make checks pass.
7. For a defect, exercise a regression scenario that distinguishes the original failure from the corrected behavior. Use a real database or runtime boundary when it determines the result.

Finish when the requested contract holds and appropriate checks pass. Separate pre-existing failures from regressions. Report only limitations that materially affect confidence.

Consult the [PHP Manual](https://www.php.net/manual/en/) and [PHPStan baseline documentation](https://phpstan.org/user-guide/baseline) for the installed versions.

