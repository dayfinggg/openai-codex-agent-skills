---
name: deployment-verification
description: "Prepare or verify an application release with artifact identity, configuration, migrations, readiness, and restoration checks. Use for deployment or post-release verification."
---

Verify the intended application artifact in the intended environment.

1. Establish the authorized target, tested commit or artifact digest, deployment mechanism, configuration source, runtime versions, and acceptance criteria. Reuse existing authentication without exposing values.
2. Trace the artifact from build to runtime. Confirm immutable identity and environment-specific configuration. Do not rebuild an untracked variant after testing and call it the same release.
3. Determine application and schema compatibility during rollout. Use database-migration-rollout when schema changes. Check worker or protocol compatibility with versions that coexist.
4. Identify readiness, live-process state, and a user-visible acceptance path separately. A process that starts or a generic health response does not prove the release works.
5. Establish the supported restoration path and its data consequences. Distinguish reverting application code from reverting schema or losing writes. Preserve the previous artifact and configuration where the existing release mechanism requires them.
6. Perform the authorized release using the existing system. Check graceful shutdown, connection draining, FPM or OPcache refresh, background workers, and cache compatibility only where relevant.
7. Verify artifact identity, the changed user path, relevant error path, logs, metrics, and dependent jobs after rollout. Stop and restore within authorization when acceptance fails.
8. Clean up only task-owned disposable release materials after no running process needs them.

Do not provision a new platform, change infrastructure ownership, or add manual approval stages unless the task requires it. A request to verify a deployment alone does not authorize initiating a new release.

Finish with the actual deployed revision and observed acceptance result, or an explicit unresolved blocker.

