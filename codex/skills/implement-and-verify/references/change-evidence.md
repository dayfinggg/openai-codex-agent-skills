# Change and evidence

Use this reference for multi-criterion, cross-package, compatibility, migration, or consequential-risk work. Keep the record in working notes unless the user or repository requires a retained artifact.

## Traceability record

For each criterion, record only the fields needed to prevent a coverage gap:

| Field | Required content |
|---|---|
| Criterion | Stable identifier or concise approved requirement |
| Outcome | Observable success and relevant failure behavior |
| Preserved contract | Behavior, consumer, format, path, or state that must not change |
| Surface | Confirmed files, symbols, artifacts, consumers, or runtime paths |
| Change | Smallest complete implementation unit |
| Gate | Check that can distinguish success from failure |
| Result | Passed, failed, skipped, unavailable, or inconclusive, with the observed output needed to support that status |

Trace in both directions. Every criterion needs a change and gate. Every changed hunk needs a criterion, necessary test, preserved contract, migration, or required update to existing documentation.

## Affected-quality selection

Activate a row only when the changed path can produce that failure. Use the project's configured tools and exact versions.

| Quality | Activation signal | Evidence must observe |
|---|---|---|
| Correctness | Any behavior change | Normal, boundary, and material failure behavior required by the criterion |
| Compatibility | Public API, CLI, configuration, schema, wire format, persisted data, ABI, or supported runtime changes | Existing and intended consumers or old and new representations |
| Security | A trust boundary, authorization, secret, parser, privileged effect, or dependency changes | The relevant abuse or negative path and permission boundary |
| Accessibility or presentation | A user-visible interactive or rendered artifact changes | The real rendered state and relevant interaction or layout condition |
| Performance or resources | A budget, regression, or measured hot path is in scope | Comparable baseline and candidate behavior under representative conditions |
| Concurrency or cancellation | Shared state, asynchronous work, a queue, retry, or lifecycle changes | Ordering, termination, cancellation, boundedness, and relevant failure propagation |
| Data migration or recovery | Authoritative state or a persisted representation changes | Transition, reconciliation, old and new access, and rollback or roll-forward where material |
| Operations | Deployment, runtime configuration, background behavior, or failure visibility changes | Rollout or runtime behavior and the failure action required by the approved scope |

Do not add machinery for an inactive row. A syntax check does not prove behavior. A unit test does not prove rendered accessibility. A successful migration command does not prove recovery.

## Bounded-diff review

Treat smallest as conceptual scope, not line count. A larger compatibility test or reversible migration can be required for completeness. A one-line bypass can still be incomplete.

Start with zero budget for speculative dependencies, public symbols, extension points, flags, modes, fallbacks, shared state, concurrency, cross-owner edits, broad renames, and formatting. Exceed a coordinate only for a current consumer, approved criterion, preserved contract, or unavoidable verification seam. Remove anything justified only by hypothetical future use.
