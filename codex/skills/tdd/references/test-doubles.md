# Test doubles

Use a real in-process collaborator when it is fast, deterministic, safe, and easy to construct. Introduce a double only for an external system boundary, expensive resource, nondeterministic clock or random source, destructive action, unavailable failure mode, or contract that must be controlled precisely.

Double the boundary contract, not the internals of the unit under test. Do not mock private methods, same-unit call order, or every local layer merely to isolate classes. A test that restates the production call graph obstructs refactoring and may stay green when behavior is wrong.

Choose the least mechanism that preserves the needed fidelity:

- Use a stub for a controlled answer with no meaningful state.
- Use a fake for small stateful behavior whose semantics matter to the test.
- Use a spy or mock only when the interaction itself is the observable contract.
- Use a fault-injecting double only for a failure that cannot be produced safely and deterministically with the real collaborator.

Keep the double's behavior explicit and minimal. Do not add convenience behavior that the real dependency does not guarantee. Back an important third-party, provider, protocol, or infrastructure double with a contract or integration test so drift becomes observable. Verify exact semantics against the project's pinned version or current official documentation when the contract can change.
