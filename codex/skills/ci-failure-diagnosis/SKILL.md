---
name: ci-failure-diagnosis
description: "Diagnose failed CI jobs from the exact commit, primary error, environment, and reproduction. Use for failed pipelines, flaky checks, or local-versus-CI discrepancies."
---

Repair the first causal CI failure without weakening the pipeline.

1. Establish the provider, repository, commit, workflow or pipeline, failed jobs, and relevant attempt. A green run on a different commit is not verification.
2. Read the failing step's complete useful output and preceding setup. Distinguish the primary failure from downstream cancellations, cleanup errors, and summarized annotations.
3. Compare tool versions, lockfiles, platform, service dependencies, environment variables, permissions, working directory, and caches with local execution. Inspect only relevant configuration and redact secrets.
4. Form a reproduction using the repository's existing commands and a representative environment. If reproduction is unavailable, retain that uncertainty rather than inventing a local success.
5. Classify deterministic code failure, infrastructure failure, missing prerequisite, timing dependence, or flaky test using evidence. A single successful rerun does not explain a flake.
6. Make the smallest cause-directed correction. Do not skip tests, lower analysis, remove supported events, refresh snapshots blindly, or replace a failing assertion with a weaker one.
7. Run targeted verification, then the affected CI path for the corrected commit where authorized. Use the host's event or PR-watching tools when completion waits on remote checks. Do not start polling loops.

Preserve logs needed for an active investigation and remove task-owned disposable fixtures once no longer needed. Finish with the cause, scoped correction, actual verified commit, and any remaining failed check.

When provider configuration changes are required, use an applicable installed workflow skill or the provider's official documentation for the deployed version.

