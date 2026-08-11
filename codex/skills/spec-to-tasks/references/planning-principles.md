# Planning principles

Use this reference when a plan has multiple dependencies, ownership boundaries, migration or release states, or enough criteria that traceability would otherwise be lost.

## Match plan depth to the work

- For one bounded outcome with no material dependency, use a short ordered plan without milestones.
- Add a milestone only when it groups a meaningful intermediate outcome, coordination boundary, compatibility window, or release state.
- Add a discovery task only when a named unknown blocks a later decision. State its question, evidence to collect, decision owner, output, and stop condition.
- Split a task when its parts can complete independently, have different owners, or require different evidence. Do not split merely to create uniform task sizes.

## Define vertical tasks

A vertical task produces an integrated outcome that can be built, tested, demonstrated, migrated, or safely isolated. Keep the behavior with the minimum tests and contract work needed to prove it. A database, backend, frontend, or testing layer is not a useful task by itself unless it is a verified prerequisite with a named consumer.

Prefer intermediate states that preserve existing consumers, compile or render, and permit safe continuation or rollback. If no buildable intermediate state is possible, state the isolation mechanism and the gate that prevents premature use.

## Record each task

| Field | Required content |
|---|---|
| Outcome | Observable state created by the task |
| Requirement and risk | Approved criterion or necessary failure mode covered |
| Scope and owner | Confirmed capability, contract, package, or files, plus one owner for any overlap |
| Prerequisites | Only blockers that must complete first |
| Change | Minimal implementation intent without speculative design |
| Evidence | Exact category of test, build, contract check, render, rehearsal, measurement, or review that proves completion |
| Completion | Postcondition that distinguishes done from activity |

Use exact file and symbol names only when repository evidence confirms them. When placement is unresolved, name the owning capability and add a bounded discovery action rather than inventing a path.

## Preserve ownership and parallelism

- Put overlapping files, schemas, public contracts, or migration history under one task owner.
- Parallelize only surfaces that can change independently or have an explicit integration contract.
- Express the actual dependency direction. Do not serialize work because tasks appear in a document.
- Place uncertainty-reducing work before the task whose design it can change.
- Keep one integration owner for a cross-package or cross-language contract.

## Reject ceremony and speculative work

Remove a task if it exists only to create a document, abstraction, flag, generic framework, future extension point, status meeting, or cleanup that no current criterion consumes. Replace generic tasks such as “add tests,” “improve security,” or “finish backend” with the behavior, failure mode, and evidence they must establish.

Do not add estimates, dates, staffing, approval checkpoints, tracker writes, branches, commits, releases, or deployments unless the request or established workflow requires them. A plan is complete because its outcomes and evidence cover the approved scope, not because it contains a conventional number of phases.
