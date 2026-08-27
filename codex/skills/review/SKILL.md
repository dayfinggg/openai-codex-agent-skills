---
name: review
description: Review code changes for concrete defects in correctness, security, concurrency, data, APIs, compatibility, tests, and performance. Use when the user asks for a code review, pull-request review, diff audit, or risk assessment; do not modify or rewrite code unless the user separately requests implementation.
---

# Review

Find defects that could change observable behavior, safety, security, reliability, compatibility, or operability. Prefer a short report of verified problems over a comprehensive-looking list of preferences.

## Define the review target

1. Identify the intended base, head, merge base, commit range, working-tree state, and user-requested scope. Do not assume the comparison when repository state can establish it.
2. Read the change description, linked issue or requirement, applicable instructions, relevant design decisions, and validation claims. State any material scope that is unavailable.
3. Inspect the complete diff, diff statistics, renamed or generated files, dependency and lockfile changes, schema or migration changes, and changed tests. Review every human-written changed line in scope.
4. Read enough surrounding implementation, callers, interfaces, tests, configuration, and version-matched documentation to understand the contract. A diff without context is insufficient evidence.
5. Use history only to recover intent and constraints. Inspect `git log`, `git blame`, and related commits when a line's reason is unclear. Compare review iterations with `git range-diff` when relevant. Never use history to assign blame.

## Review correctness first

1. Trace changed behavior from inputs through state transitions and outputs. Check happy paths, boundaries, empty and invalid input, partial failure, retries, cleanup, and recovery.
2. Verify invariants and ownership across every changed boundary. Look for stale state, lost updates, double application, incorrect ordering, missing validation, swallowed errors, leaked resources, and unreachable or accidentally reachable branches.
3. Review persisted data, serialization, migrations, cache keys, defaults, nullability, units, precision, encoding, identifiers, and transaction boundaries. Existing data may violate assumptions introduced by new validation or schemas.
4. Review public and cross-component contracts, including source and binary APIs, CLI behavior, configuration, environment variables, events, protocols, errors, timing, ordering, and supported runtimes. Treat observable behavior as potentially depended upon even when undocumented.
5. For concurrency and asynchronous work, establish ownership and happens-before relationships. Check races, deadlocks, lock ordering, cancellation, task lifetime, backpressure, duplicate work, and callbacks executed under locks.
6. For security, identify attacker-controlled inputs and trust boundaries. Confirm authorization, validation, output encoding, secret handling, query construction, deserialization, path handling, workflow permissions, and dependency provenance before assigning impact.
7. For performance, report only a plausible regression on a relevant path and scale. Require algorithmic reasoning, profile data, benchmark evidence, or a clear unbounded-resource path; do not infer speed from syntax.

## Review validation

1. Check that tests exercise the changed observable behavior and the failure modes most likely to regress. Do not request tests solely to raise a coverage percentage.
2. Verify that assertions would fail for the suspected defect and are not coupled only to implementation details. Check determinism, isolation, fixtures, cleanup, time, concurrency, and supported environments.
3. Treat passing CI, linters, scanners, and static analysis as evidence, not proof. Treat warnings from automated tools as leads until the code and reachable scenario confirm them.
4. Run focused non-destructive checks when they can confirm or reject a finding. Use the `debug` skill for reproduction and causal isolation, and the `tests` skill for substantial test-specific analysis.

## Prevent false positives

1. Before reporting a finding, search for validation, synchronization, cleanup, compatibility handling, or error conversion elsewhere in the call path.
2. Confirm that the affected input or state is reachable under the actual version, platform, feature flags, permissions, and deployment model.
3. Distinguish a changed defect from unrelated pre-existing behavior. Report pre-existing issues only when the user requested a broader audit or the change materially exposes or worsens them.
4. Verify each finding through a second independent path when practical, such as a focused test, caller analysis, history, specification, runtime documentation, or another tool.
5. Drop a finding when its impact depends on an unsupported assumption, hypothetical future use, personal style, or a pattern preference without a failure scenario.

## Assign priority by impact

1. Use `P0` for a release-blocking defect with immediate catastrophic impact, such as broadly exploitable compromise, irreversible data loss, or a system-wide outage.
2. Use `P1` for a reachable high-impact defect, such as serious security exposure, data corruption, widespread failure, or a broken public contract without a safe fallback.
3. Use `P2` for a concrete moderate defect with limited scope, lower likelihood, recoverable impact, or a missing failure path that matters in normal operation.
4. Use `P3` for a narrow but real defect whose impact is small and actionable. Do not use `P3` for formatting, naming taste, optional refactoring, praise, or educational advice.
5. Priority reflects impact and reachability, not confidence alone. Omit low-confidence speculation instead of lowering its priority until it looks reportable.

## Write actionable findings

1. Attach each finding to the smallest changed line range that introduces the problem. Use the environment's inline-review mechanism when available; otherwise provide an exact clickable path and line.
2. Begin with a concise title in the form `[P1] Prevent duplicate settlement on retry`. Describe one defect per finding.
3. Explain the reachable scenario, the incorrect behavior, why the cited code causes it, and the resulting impact. Include the decisive evidence or command result.
4. Give a fix direction or required invariant, not a full rewrite. The author owns the implementation unless the user asks you to change the code.
5. Keep the body understandable without relying on unstated context. Avoid vague labels such as “potential issue,” “best practice,” or “consider improving.”

## Deliver the review

1. Lead with findings ordered by `P0` through `P3`. Do not bury defects beneath a summary, compliments, or process narration.
2. After the findings, give one concise statement of checks performed and review limits when useful.
3. If no qualifying defects remain, say that no concrete defects were found and state any important unreviewed or unvalidated area. Do not invent findings to make the review look thorough.
4. Do not edit files, apply patches, refactor code, or expand scope during a review unless the user explicitly requests implementation.
