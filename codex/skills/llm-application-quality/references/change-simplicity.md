# SCC-Guard change simplicity

Use this reference only when an LLM application change can add or alter implementation, orchestration, configuration, dependencies, permissions, state, public contracts, or claimed performance. Do not turn a review-only task, a saved-eval update, or an obvious local correction into an architecture exercise.

## Smallest complete change

Select the least conceptual change that satisfies every current observable requirement, covers required error paths, preserves contracts outside the request, and includes the tests or migration needed to make the result safe. A smaller line count is not sufficient if it omits a failure path or compatibility check. Do not combine the change with unrelated cleanup, formatting, renaming, or framework migration.

Before editing, inspect the smallest evidence packet that can disprove assumptions:

- effective instructions, model and tool configuration, schemas, permissions, and runtime versions
- definitions, callers, consumers, error paths, traces, and representative failures
- manifests, lockfiles, installed APIs, local precedents, tests, and current measurements
- public API, structured output, events, persisted data, CLI, configuration, and lifecycle contracts touched by the path

Mark an unresolved material assumption instead of filling it from memory. Ask only when the unresolved choice changes behavior, safety, compatibility, cost, or an irreversible effect.

## Options and complexity budget

Compare two or three options only when they are genuinely viable and differ materially in contract, risk, dependency, reversibility, or performance. Evaluate the same evidence for each: current requirement, local precedent, diff surface, new concepts, compatibility, independent verification, operations, and measured performance. Choose the simpler fully sufficient option. Skip the matrix when one local path is already established.

Track the vector separately rather than hiding it in one score:

`C = {production LOC, touched owners, public surface, abstractions, dependencies, configuration, state or concurrency, branch complexity, duplication}`

The default budget is zero for:

- a new production dependency, framework, service, agent, queue, worker, or concurrency model
- a new public API, schema field, tool, permission, CLI flag, configuration key, or output mode
- a new interface, generic helper, abstraction layer, registry, extension point, feature flag, fallback, or future hook
- an unrelated owner, package, rename, move, refactor, formatting pass, or weakened test

Exceed a coordinate only when a current consumer or required contract proves that the simpler existing path, language feature, standard library, installed dependency, and small local mechanism are insufficient. Record that evidence and the check that covers the added concept. A hypothetical future consumer is not evidence.

## Contract and rollback

Preserve every affected contract unless the request explicitly changes it. Compare applicable signatures, types, errors, defaults, ordering, idempotency, retries, tool schemas, permissions, output formats, CLI behavior, configuration precedence, persisted or wire data, resource ownership, cancellation, timeouts, and performance guarantees.

For an intentional incompatible change, require explicit authority, version or migration handling, consumer-level tests, and a usable rollback or reconciliation path. Preserve the baseline artifact, configuration, dataset, index, and revision needed to restore the prior condition. Do not call rollback usable merely because a source diff can be reverted when external data or side effects cannot.

## Independent verification and deletion pass

Derive checks from the contract or reproducer rather than from the candidate implementation. Use the narrowest failing or distinguishing case, then relevant boundary, error, composition, adversarial, permission, and recovery cases. Where consequence warrants it, add an independent check such as mutation, differential comparison, old-to-new compatibility, a hidden composed case, or human review. Do not weaken assertions, skip tests, hard-code fixtures, or redefine acceptance to make the candidate pass.

After checks pass, inspect status, diff statistics, whitespace, and every changed line in context. Assign each hunk to a current requirement, necessary test, preserved contract, migration, or required update to retained documentation. Delete untraceable hunks and unused wrappers, types, permissions, dependencies, modes, fallbacks, comments, and generated churn. Search again for existing implementations and missed consumers, then repeat the affected checks.

## Performance evidence

Add complexity for performance only when performance is a requirement or a profile identifies a material bottleneck. Establish a correct baseline and keep hardware, runtime, build, dataset, load, and background conditions comparable. Warm up as needed, run repeated baseline and candidate measurements, report the relevant distribution and variation, and check correctness plus traded resources such as memory, CPU, I/O, or tail latency. If the result is indistinguishable from noise, report it as inconclusive rather than a speedup.
