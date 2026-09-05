---
name: impact
description: Determine what a proposed or completed change could break outside its immediate diff. Use for blast-radius analysis, shared contracts, migrations, risky refactors, and changes to public interfaces or persistent data. Do not use for a general code review with no cross-boundary risk.
---

# Impact

Follow the governing instructions and the user's requirements for communication, code style, authorization, and delegation. This skill supplies task-specific guidance, not permission to expand the task. Its workflow and output fields describe internal checks and relevant content, not a mandatory response layout or a progress report. When used within broader authorized work, continue that work through completion rather than stopping to deliver this skill's intermediate result.

Trace changed assumptions to every meaningful consumer and identify the evidence needed to call the change safe.

## Establish the changed contract

Identify the type, interface, schema, behavior, configuration, timing, or state assumption that changes. State both the old and new contract.

Include system qualities that may change without appearing in the signature, such as latency, throughput, consistency, durability, availability, authorization, resource use, ordering, idempotency, and recovery time.

## Trace consumers

Search direct callers, re-exports, generated clients, tests, jobs, integrations, stored data, deployment configuration, and operational tooling as applicable. Follow semantic consumers, not only textual matches. Trace synchronous and asynchronous dependencies, event subscribers, retrying clients, caches, indexes, backups, restore tooling, dashboards, alerts, and emergency procedures when relevant.

Consider rollback and mixed-version operation when releases can overlap. For a data, schema, or event change, identify the oldest reader and writer that can coexist, the order of rollout, the point of no return, and whether rollback would restore code while leaving incompatible state behind.

Check whether rollback, restore, or migration can revive a known-vulnerable artifact, stale policy, deleted data, revoked credential, compromised source, or snapshot below the accepted security floor. Give every temporary mitigation an owner, expiry or removal condition, and evidence that it cannot persist silently.

Trace failure propagation as well as normal data flow. Check whether a slow or failed dependency consumes threads, connections, queue capacity, retry budgets, or load-balancer capacity and can turn a local fault into overload elsewhere.

For persistent or distributed writes, trace ambiguous timeout outcomes, partial writes, acknowledgement semantics, replay, and crash recovery. Verify end-to-end durability at the highest boundary that promises it instead of assuming a lower-layer acknowledgement proves the final state.

Inspect the dependency graph for new cycles and for transport, ORM, framework, or deployment types leaking into a previously independent contract. If a module split changes artifacts, processes, services, or independent deployment, trace packaging, startup, configuration, ownership, and rollback as part of the changed contract.

Treat a change to a domain term as a possible model and contract change. Trace bounded-context owners, upstream and downstream consumers, shared code or schemas, translation and anticorruption layers, aggregate invariants, transaction boundaries, and published event meanings before assuming a rename is local.

## Rank risk

For each plausible break, describe the consumer, failure mode, likelihood, impact, and current protection. Separate verified consumers from uncertain external dependencies. Identify the failure domain and blast radius, and distinguish corruption or security compromise from a clean availability failure.

Treat redundancy as protection only when replicas do not share the same failure cause, control plane, credentials, configuration source, capacity bottleneck, or rollout. A duplicated component inside one failure domain may add cost without reducing risk.

## Prove the critical fact

Run or identify the smallest check for the critical compatibility claim. Use isolated test state for restore, downgrade, mixed-version, or failure-injection experiments. Do not change live systems or destroy data merely to prove a risk. If authorization or an appropriate environment is unavailable, report the verification limit.

## Output

Return the changed contract, affected surfaces, ranked risks, evidence, unresolved consumers, and a focused verification plan. Include rollout order, rollback limits, failure propagation, and recovery evidence when they materially affect safety. Do not implement the change unless separately requested.

## Sources

- [Google: Building Secure and Reliable Systems, Design Tradeoffs](https://google.github.io/building-secure-and-reliable-systems/raw/ch04.html)
- [Google: Building Secure and Reliable Systems, Design for Resilience](https://google.github.io/building-secure-and-reliable-systems/raw/ch08.html)
- [Google: Building Secure and Reliable Systems, Design for Recovery](https://google.github.io/building-secure-and-reliable-systems/raw/ch09.html)
