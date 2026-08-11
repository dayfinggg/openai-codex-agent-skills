# Simplicity and SCC-Guard

Use this reference when a candidate change adds an abstraction, dependency, public surface, configuration, shared state, concurrency, background work, extension point, fallback, or a broader diff than the observable requirement appears to need.

Smallest complete change means the smallest conceptually coherent diff that implements every current criterion and material failure path, preserves unrequested contracts, includes required tests or migration work, and passes relevant gates. It does not mean minimum line count.

## SCC-Guard

1. Establish the requested behavior, unchanged contracts, edit authority, and completion evidence before choosing a mechanism.
2. Ground the change in applicable instructions, definitions, callers, tests, manifests, versions, and existing local mechanisms. Do not invent an API, package, signature, option, error, or future consumer.
3. Start with a zero budget for each new production dependency, public symbol, schema or config key, abstraction layer, shared state owner, concurrency model, background worker, feature flag, speculative fallback, independent rename, and broad formatting change.
4. Exceed one coordinate only when a current criterion, current consumer, established boundary, compatibility requirement, or reliable verification need traces directly to it. One hypothetical future consumer does not qualify.
5. Choose the least sufficient mechanism in order: reuse an existing local path, use a language feature, use the standard library, use an already installed core dependency, add a small local helper, then consider a new abstraction or dependency. Stop at the first option that completely satisfies the contract.
6. Compare two or three alternatives only when viable choices differ materially in contract, risk, reversibility, dependency cost, or measured performance. Evaluate them against the same criteria. Do not generate alternatives as ceremony.
7. Build tests from the specification, reproducer, prior contract, or independent consumer rather than copying the implementation. A test must distinguish the bad behavior. Do not weaken assertions, skip checks, replace prior regression tests, hard-code fixtures, or special-case visible tests.
8. Preserve signatures, errors, defaults, ordering, CLI streams and exit codes, configuration, schemas, serialization, lifecycle, and performance guarantees unless the request changes them. Add compatibility or migration work only where that changed contract requires it.
9. Inspect the complete diff after checks pass. Assign every hunk to requested behavior, a required failure path, a necessary test, compatibility or migration, or an existing document that would otherwise become false. Remove every unsupported hunk and re-run affected gates.

## Evidence required for extra mechanism

- A new dependency requires proof that the language, standard library, and installed dependencies cannot meet the requirement, plus verified package identity, version, maintenance, license, security, and target compatibility.
- A new abstraction requires a current variation, stable boundary, test seam, migration need, or failure-isolation responsibility. Do not introduce an interface around one implementation only to anticipate substitution.
- New state or concurrency requires an owner, lifecycle, synchronization or ordering model, bounds, cancellation, failure propagation, cleanup, and a risk-specific test.
- A broader owner or package change requires a definition, consumer, or contract that cannot be changed coherently inside the original locus.
- A performance-driven complication requires a correct comparable baseline, profiling evidence, repeated measurements with variation, an independent workload, and preserved correctness.

Stop expanding the candidate when a simpler option fully satisfies the current contract, a new concept has no present consumer, or the next change is independent cleanup. Separate an independently valuable refactor instead of hiding it inside the behavioral change.

Primary basis: [Google Engineering Practices on over-engineering](https://google.github.io/eng-practices/review/reviewer/looking-for.html), [Google small changes](https://google.github.io/eng-practices/review/developer/small-cls.html), [Google Go least mechanism](https://google.github.io/styleguide/go/guide.html), [Google SRE simplicity](https://sre.google/sre-book/simplicity/), and the research signals in [SlopCodeBench](https://arxiv.org/abs/2603.24755), [SpecBench](https://arxiv.org/abs/2605.21384), [De-Hallucinator](https://arxiv.org/abs/2401.01701), and [SWE-Refactor](https://arxiv.org/abs/2602.03712). The 2026 papers are preprints and support guarded evaluation, not universal numeric laws.
