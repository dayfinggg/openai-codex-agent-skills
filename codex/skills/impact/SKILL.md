---
name: impact
description: Trace what a change can break beyond its diff in public contracts, persistent data, or shared state. Use when a planned or finished change touches one of them. Skip routine local edits.
---

# Impact

Establish what a change can break beyond its own diff.

Impact analysis lists risks of the requested change. It does not add work. Report a risk that existed before the change in one sentence and do not fix it. Do not add idempotency keys, locks, retries, deduplication, or recovery code unless the user requested them.

## Establish the changed contract

State the old and new type, interface, schema, behavior, configuration, timing, or state contract, including any affected latency, consistency, durability, availability, authorization, ordering, idempotency, or recovery guarantee.

## Trace consumers

Follow semantic consumers, not just text matches: callers, re-exports, generated clients, tests, jobs, integrations, stored data, deployment, and operational tooling such as caches, indexes, backups, dashboards, and alerts where they are affected.

For overlapping releases, identify compatible reader and writer versions, rollout order, irreversible steps, and state that a code rollback cannot undo. Check that recovery does not restore vulnerable artifacts, stale policies, deleted data, or revoked credentials. A temporary mitigation needs an owner and a removal condition.

For persistent or distributed writes, check ambiguous timeouts, partial outcomes, replay, and crash recovery, and verify durability at the boundary that promises it. For structural changes, inspect dependency cycles, leaked framework or persistence types, packaging, startup, and rollback. For domain renames, trace context owners, shared schemas, translation layers, transaction boundaries, and published event meanings.

## Rank risk

For each plausible failure, identify consumers, likelihood, impact, protections, and uncertainty. Distinguish data corruption or security compromise from availability loss. Redundancy protects only against failure causes it does not share, such as control planes, credentials, configuration, and rollout.

## Prove the critical fact

Run or identify the smallest check for each critical compatibility claim. Use isolated state for restore, downgrade, mixed-version, and fault-injection experiments. Do not mutate live systems or destroy data to prove risk. Report evidence or authorization that is unavailable.

## Output

Return the changed contract, affected surfaces, ranked risks, evidence, unresolved consumers, and a focused verification plan. Include rollout order, rollback limits, and recovery evidence when they affect safety. Do not implement the change unless separately requested.

## Sources

- [Google: Building Secure and Reliable Systems, Design Tradeoffs](https://google.github.io/building-secure-and-reliable-systems/raw/ch04.html)
- [Google: Building Secure and Reliable Systems, Design for Resilience](https://google.github.io/building-secure-and-reliable-systems/raw/ch08.html)
- [Google: Building Secure and Reliable Systems, Design for Recovery](https://google.github.io/building-secure-and-reliable-systems/raw/ch09.html)
