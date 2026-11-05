1. Establish the baseline invariant and trust model for each sensitive change. Name the actor, obtainable privileges, entry point, controlled input, protected asset, and expected restriction. Trace reads, writes, internal calls, external calls, and transitive callers until the relevant enforcement points and side effects are known. Inspect removed protections and reintroduced code in history to recover prior fixes. A commit message supplies context, not proof of exploitability.

2. Trace an attack through an interface the actor can actually reach. Check whether a removed guard moved to another layer and whether every affected entry point still crosses it. Record exact preconditions, operation order, attacker-controlled values, the first violated invariant, and concrete impact. Test both allowed and rejected access where the changed policy matters. Separate source authentication from authorization to act on a particular object or tenant.

3. Select applicable checks from the changed data and control flow.

- Follow untrusted input to execution, query, template, deserialization, filesystem, and outbound-request sinks. Include redirects and canonicalization when they affect the claimed path.
- Check identity, object ownership, tenant isolation, privilege changes, replay protection, and secret exposure through responses or logs.
- Follow repeated delivery, concurrent updates, external callbacks, and partial commits for double accounting, races, and reentrancy.
- Check bounds, arithmetic, units, memory lifetime, and external-call return values against the actual language, compiler, dependency, and platform version. Do not infer a flaw from a keyword such as unsafe or unchecked alone.
- Check attacker-growable work, blocking external failures, timing assumptions, and resource exhaustion. For contracts, establish chain-specific transaction ordering, gas, and timestamp semantics before claiming front-running or time manipulation. Do not substitute block height for time without proving the required semantics.

4. Apply the entrypoint's evidence gate to the complete attack mechanism. A vulnerability name or a suspicious line is insufficient. Confirm that the mechanism remains live in the reviewed head after all guards and repairs. Use local, isolated reproductions within the review's authority. If exploit execution is unavailable, distinguish a static proof from an executed exploit.

5. Describe affected entry points and downstream assets, distinguishing resolved callers from unresolved dynamic dispatch or external consumers. Counts of textual matches are not caller counts. Set severity from demonstrated impact and attainable preconditions, not diff size, file count, missing tests, or the age of removed code. Preserve coverage gaps and test limitations in the report rather than manufacturing a confidence percentage.
