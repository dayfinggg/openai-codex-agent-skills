---
name: php-composer-change
description: "Repair Composer or change PHP dependencies with lockfile, platform, and transitive-diff verification. Use for composer.json, composer.lock, dependency resolution, or installation failures."
---

Keep PHP dependency changes reproducible and limited to the requested graph.

1. Read composer.json, composer.lock, platform configuration, repositories, allowed plugins, and scripts. Identify the actual PHP executable, extensions, and project Composer command. Never print authentication files or tokens.
2. Distinguish environment restoration from dependency updates. With a valid lockfile, installation must use its resolved versions. An installation failure does not authorize an update.
3. For an authorized update, choose the smallest package set and compatible constraints. Use a resolution dry run when useful. Read the migration documentation for changed major versions.
4. Inspect what scripts and plugins execute before running them. Reuse the project's authorized tooling. Do not permanently disable required behavior to hide a failure or run an unreviewed network installer.
5. Update the manifest and lockfile through the selected dependency manager. Do not hand-edit lockfile versions or integrity hashes.
6. Review direct and transitive changes, extension requirements, autoloading, and conflicts. Check the deployment platform as well as local PHP and config.platform.
7. Run appropriate validate, check-platform-reqs, advisory checks, and application tests. An unavailable advisory service is an unverified result, not evidence of no vulnerabilities.

Do not use --ignore-platform-reqs as a permanent compatibility fix. Change package stability, download sources, or plugin permissions only when the task requires it.

Finish with a consistent lockfile and verified platform compatibility. Check command semantics in the [Composer CLI](https://getcomposer.org/doc/03-cli.md) and [Composer scripts](https://getcomposer.org/doc/articles/scripts.md).

