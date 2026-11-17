# Evidence for a test result

Use this reference when a task needs a demonstrated before-and-after result, when a green test result needs interpretation, or when a running application must be checked end to end. Use the project's own test commands and environment.

## Compare before and after

- For a bug fix, run one reproducible failing case before the fix and the same command after it. Confirm that the original failure occurred for the expected reason.
- Keep the user's working tree intact. When a base-branch run is necessary, prefer an isolated worktree or checkout over stashing or reverting uncommitted changes.
- For a new feature, record its starting behavior and a nearby control behavior, then verify both after the change.
- For a refactor, compare old and new behavior on identical inputs. Every difference needs an explanation.
- For a performance claim, measure before and after on the same machine and data, discard warm-up runs, and report the method and variation.

## Check the shipped behavior

- Name the level actually checked, such as unit, integration, local application, or deployed. A test that mocks the boundary containing the change does not prove that boundary works.
- Test the built package, container, or binary when packaging can omit required files.
- Use the configuration and feature flags relevant to the changed behavior. For asynchronous work, verify completion by observing its result, not only that it was queued.
- For a UI, use the active browser tool to follow the user path. Confirm the page, request and response, persisted result, and relevant failure path. A DOM inspection by itself does not prove that a user action works.
- Read test counts, skips, expected failures, and flaky results. A green exit code with zero tests or newly skipped coverage is not a passing check.
- Confirm that CI results belong to the current commit. Report the exact check that was run and avoid claiming evidence a result did not provide.

## Preserve the gate

Keep test assertions, coverage thresholds, retry policy, CI triggers, and required job names intact while fixing a failure. Do not accept `continue-on-error`, ignored exit codes, new skip markers, relaxed thresholds, or altered expected results as evidence of a fix. Review regenerated snapshots against the actual behavior change.
