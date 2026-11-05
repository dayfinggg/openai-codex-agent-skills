---
name: design
description: Designs module interfaces, dependency seams, and test boundaries when asked how to structure a module or make code testable. Does not perform a diff review or prescribe speculative abstractions.
---

1. Start from a concrete caller's task and the current dependency path. Identify what callers must know today, which knowledge is duplicated, and which change or test is obstructed. Treat the interface as signatures plus invariants, ordering, errors, ownership, configuration, and relevant performance obligations. Keep the repository's domain vocabulary.

2. Choose the smallest interface that owns the required behavior and hides decisions callers should not repeat. Judge depth by useful behavior behind the interface, not implementation length or method counts. Apply the deletion test. If removing a wrapper removes only forwarding, prefer the existing dependency. If it pushes policy back into callers, locate that policy in one owner.

3. Place a dependency seam where behavior must actually vary or an effect must be controlled in a real test. Keep implementation-only seams private. A production dependency and a justified test substitute can warrant injection without multiple production implementations. Prefer an existing function or constructor parameter over a new port hierarchy. Separate deterministic decisions from effects where that preserves the required semantics.

4. Match verification to the dependency. Exercise pure computation directly. For local storage or processes, prefer the existing real test facility when its behavior matters. For owned remote services, identify the transport contract and check both ends. For third-party systems, substitute only the interaction needed by the module and verify the production adapter against the real contract. An in-memory fake does not prove transactions, locking, serialization, or network failure behavior.

5. Compare materially different interfaces only when a real design uncertainty remains. Walk the current caller and the hardest required failure path through each. Compare caller knowledge, ownership, dependency direction, test setup, compatibility, and where a future change of the kind already requested would land. Reject options that require unrelated callers or extension points. Recommend one design with its material tradeoff.

6. For an authorized refactor, retain behavioral checks until equivalent coverage exists at the chosen interface. Replace an old test only after identifying what the replacement proves, including failures and integration semantics. Verify affected callers through the same observable contract. Return the selected interface, seam location, hidden responsibility, and unresolved compatibility decision. Do not create design documents or implement a proposal unless requested.
