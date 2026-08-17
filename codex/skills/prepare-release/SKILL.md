---
name: prepare-release
description: Assess and prepare a production software release. Use for release readiness, versioning, artifacts, compatibility, migrations, staged rollout, health checks, rollback, provenance, release notes, and go or no-go decisions.
---

# Prepare Release

## Workflow

1. Identify the exact revision, artifacts, environments, owners, consumers, and release scope.
2. Define release criteria from behavior, tests, security, compatibility, migrations, configuration, documentation, observability, and support needs.
3. Build immutable traceable artifacts and verify their provenance and configuration. Apply the project's versioning policy.
4. Rehearse migrations and operational procedures in a representative environment. Verify backup, restore, rollback, or forward repair.
5. Choose a staged rollout, canary, feature flag, or direct release according to risk. Define health signals, smoke checks, pause points, and abort thresholds.
6. Make a go or no-go decision from current evidence and record accepted residual risks.
7. Observe the release through the defined window, communicate outcomes, and remove temporary safeguards when safe.

Do not publish, deploy, tag, or trigger externally visible release actions without explicit authorization. Read [release practices](references/practices.md) for release engineering and supply-chain guidance.
