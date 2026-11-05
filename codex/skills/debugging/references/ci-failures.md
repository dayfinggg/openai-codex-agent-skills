Read when diagnosing failed jobs, flaky checks, or local-versus-CI discrepancies.

1. Resolve the provider, repository, exact head commit, workflow, event, failed job, runner, and run attempt. Fetch the failed step and preceding setup output. Find the first causal error rather than downstream cancellations, cleanup failures, or annotations. Retain useful logs during the investigation.

2. Compare installed tools and dependencies, lockfile, platform, service readiness, environment variable presence, permissions, working directory, and cache keys with local execution. Inspect relevant configuration only. Classify deterministic code failure, missing prerequisite, runner or infrastructure failure, timing dependence, and suspected flake using the actual evidence.

3. Reproduce with the repository command and representative environment. Report which environmental differences remain. A local pass cannot verify the remote path, and a green run for another commit cannot verify this change. One successful rerun neither explains nor resolves a flake.

4. For GitHub Actions, inspect logs of the identified attempt, not just the newest run. Downloaded logs from a partial rerun include only rerun jobs, so retrieve earlier attempts for omitted jobs. Searchable UI logs cover expanded steps only. Use job logs when the aggregate run log is unavailable. Check the selected connector or CLI's supported parameters before invocation.

5. Enable additional logging only when necessary and authorized. GitHub Actions supports `ACTIONS_RUNNER_DEBUG=true` for runner diagnostics and `ACTIONS_STEP_DEBUG=true` for step diagnostics, as repository variables or secrets. A secret takes precedence over the corresponding variable. A workflow rerun can also request debug logging. Limit collection to the failing attempt and redact sensitive output before sharing.

6. Correct the cause without weakening tests, analysis, event support, or permissions. When workflow configuration changes, read the provider's current documentation and preserve its event and trust boundaries. Run targeted checks and the affected CI path on the corrected commit when authorized. Use available event-driven check watching rather than polling loops. Report remaining failures or unavailable logs explicitly.

GitHub Actions documentation establishes [run log behavior](https://docs.github.com/en/actions/how-tos/monitor-workflows/use-workflow-run-logs) and [debug logging controls](https://docs.github.com/en/actions/how-tos/monitor-workflows/enable-debug-logging).
