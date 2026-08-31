# Practical CI order

Run `composer validate` and `php -l` first, then the formatter check, static analysis, unit tests, integration tests, and `composer audit`.
Review new public API, dependency changes, suppressions, and threshold exceptions as part of the same change.
