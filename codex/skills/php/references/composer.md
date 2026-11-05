Read for Composer restoration, resolution failures, or dependency changes. Commands use Composer 2. Retain project wrappers and bin directories.

1. Inspect repositories, platform overrides, allowed plugins, and root scripts before installation. Never run an unreviewed network installer. Do not permanently disable required scripts or plugins to hide failures.

2. For restoration with a valid lock, run `composer install --no-interaction`. An install failure does not authorize `composer update`. If the lock is missing, installation resolves new versions, so establish that resolution is within the requested work first.

3. For authorized updates, choose the smallest package set and compatible constraints. Use `composer update vendor/package --dry-run --no-interaction` when useful, then remove `--dry-run` to apply. Read major-version migration guidance. Review transitive versions, extensions, autoloading, conflicts, and lock consistency. Change stability, sources, or plugin permissions only when required.

4. Before reporting a dependency change, run `composer validate --strict`, `composer check-platform-reqs`, `composer audit`, and relevant application tests. `check-platform-reqs` checks real PHP and extensions rather than `config.platform`. Check the deployment platform too when it differs and is in scope. Do not use `--ignore-platform-reqs` as a permanent compatibility fix. Report an unavailable advisory service as an unverified check.

Command semantics follow the [Composer CLI](https://getcomposer.org/doc/03-cli.md) and [root scripts](https://getcomposer.org/doc/articles/scripts.md).
