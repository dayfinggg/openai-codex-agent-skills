---
name: php-change
description: "Implement, fix, refactor, or test PHP code and diagnose PHP tool or dependency-version mismatches. Preserve project compatibility. Excludes standalone Composer changes and PHP-FPM operations."
---

Select the PHP procedure that owns the requested result. Keep read-only environment inspection distinct from changes to application behavior.

Read [host integration](../.shared/host-integration.md) once when following imported PHP tool procedures.

| Task | Read |
|---|---|
| Implement, fix, or refactor PHP application or package behavior | [Implementation](references/implementation/guide.md) |
| Write, maintain, select, or run PHPUnit or Pest behavior tests | [Testing](references/testing/guide.md) |
| Diagnose PHP runtime or missing-extension problems affecting Mate tools | [Runtime environment](references/environment/guide.md) |
| Establish installed dependency versions or explain an API-version mismatch | [Dependency versions](references/versions/guide.md) |

For implementation changes, load the testing procedure when test design or runner behavior needs its detail. A version-only question does not require an implementation or testing workflow.

Use php-composer-change for dependency installation, resolution, or updates. Use php-fpm-opcache-diagnostics for the serving FPM runtime, worker exhaustion, OPcache, or stale deployed code. Use symfony-diagnostics when the failure belongs to the Symfony profiler, container, environment configuration, or logs.

Preserve the project's PHP baseline, existing analysis configuration, public contracts, and testing tools. The bundled procedures retain their full verification requirements.

