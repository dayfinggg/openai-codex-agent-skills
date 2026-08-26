---
name: write-quality-code
description: Create, modify, refactor, or migrate code with repository-consistent correctness, simplicity, tests, and focused validation.
---

Use this skill for code creation or modification. Let narrower skills add process when their trigger applies; do not duplicate their workflows here.

Start from the repository's guidance, nearby implementation, tests, formatter, linter, type checker, build system, and public contract. Translate the request into observable behavior and relevant failure or boundary cases before editing. Preserve behavior outside scope and keep the diff as small as the complete solution allows. For multi-part work, implement the smallest behaviorally complete slice that can be verified independently before widening the change.

Prefer the simplest complete design that fits existing conventions. Use cohesive responsibilities, descriptive names, direct control flow, narrow interfaces, explicit state transitions, predictable side effects, and the strongest useful types supported by the project. Reuse stable local abstractions. Add an abstraction, dependency, layer, compatibility mechanism, or optimization only when a present requirement, repeated invariant, measured bottleneck, or repository convention justifies its cost. Do not impose universal limits for function size, complexity, DRY, KISS, YAGNI, or SOLID; use them as decision aids against the actual code and change pressure.

At boundaries, validate the inputs and states that can violate the contract before irreversible mutation when practical. Preserve useful error context and do not suppress a failure that can change the promised result, integrity, security, or required observability. For concurrent, transactional, retrying, caching, security-sensitive, or resource-intensive paths, identify the concrete invariant or threat first and use only the mechanism needed to protect it. Verify external APIs, dependencies, versions, and generated interfaces against authoritative sources before relying on them.

Add or update focused behavior tests when a stable test seam exists and the change warrants them. Cover the main behavior plus meaningful negative, boundary, state, or concurrency cases that are relevant to the contract; avoid testing implementation details or recreating the production algorithm in expected values. Do not delete tests or weaken assertions merely to make a change pass. When the requested contract changes, update obsolete tests while preserving or strengthening coverage of the new behavior.

Use comments or API documentation only when repository conventions require them or a non-obvious contract, invariant, trade-off, protocol, or safety condition cannot be made clear through code alone. Do not add comments that merely restate obvious code.

Run the smallest relevant formatter, type, compile, lint, and test checks supported by the repository, then broaden validation when risk or project practice warrants it. Inspect the final diff and relevant generated or untracked files. Treat security, performance, concurrency, and completeness claims as unverified until supported by a targeted check appropriate to that claim.

Read [references/design-tradeoffs.md](references/design-tradeoffs.md) when deciding whether to remove duplication, introduce an abstraction or interface, apply DRY, KISS, YAGNI, or SOLID, or split a function or module.

Read [references/examples.md](references/examples.md) when a boundary, state transition, retry, cache, redaction, test, or performance decision needs a concrete language-neutral pattern.

Read [references/official-sources.md](references/official-sources.md) only when language-specific style, API design, security, or performance guidance is needed. Treat those sources as starting points and verify changing details against the current official documentation.
