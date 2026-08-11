# Production release strategies

**Reviewed:** 2026-08-11
**Scope:** Provider-neutral staged release practices. Use target-platform documentation for exact commands and health semantics.

## Strategy selection

- Use rolling replacement when old and new versions are compatible during overlap, capacity can absorb unavailable instances, and health detection is reliable.
- Use canary when a bounded representative cohort and trustworthy comparative signals can reveal risk before broad exposure.
- Use blue-green when duplicate capacity, state compatibility, routing control, and rollback of traffic justify the cost.
- Use a feature gate only when it is an existing supported release control with clear ownership, default, cleanup, observability, and data compatibility. Do not create a permanent flag as a substitute for safe code.
- Use maintenance or one-shot rollout only when availability impact, lock time, recovery, and stakeholder communication are explicitly accepted.

## Required gates

1. Identify the immutable artifact and current baseline.
2. Define cohort, instance or traffic count, order, concurrency, and capacity reserve.
3. Define user, service, dependency, data, and infrastructure health signals.
4. Set evaluation windows, pause, abort, rollback, and promotion conditions before starting.
5. Keep old and new versions compatible for the planned overlap.
6. Exercise representative read and write flows after each stage.
7. Verify rollback on the same platform and state model before relying on it.

## Official sources

- [Google SRE release engineering](https://sre.google/sre-book/release-engineering/)
- [Google SRE canarying releases](https://sre.google/workbook/canarying-releases/)
- [GitHub deployment environments](https://docs.github.com/en/actions/reference/deployments-and-environments)
- [GitLab deployment safety](https://docs.gitlab.com/ci/environments/deployment_safety/)
