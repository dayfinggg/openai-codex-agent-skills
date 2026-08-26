# Design trade-offs

Use these principles as diagnostic questions, not mandatory shapes.

## Simplicity

Prefer the simplest complete design that satisfies the required behavior, constraints, and repository conventions. Simplicity is not the fewest lines or fewest types. A design is simpler when a maintainer can understand its state, control flow, dependencies, failure behavior, and extension points with fewer independent assumptions.

Do not remove structure that protects a real invariant, compatibility boundary, security property, concurrency guarantee, or measured performance requirement.

## Duplication and abstraction

Do not extract code merely because two fragments look similar. Extract when the fragments represent the same stable concept or invariant and should change together.

Prefer local duplication when similar-looking code has different domain meanings, different failure behavior, or credible reasons to evolve independently.

Treat an abstraction that requires many flags, special cases, downcasts, or knowledge of its callers as evidence that the shared concept may not be stable.

## YAGNI

Do not add behavior, configuration, extension points, compatibility layers, dependencies, or generalized frameworks for hypothetical future requirements.

This does not prohibit work required by an existing public contract, documented compatibility policy, security boundary, resource limit, migration plan, or measured workload.

## KISS

Prefer direct control flow, familiar repository patterns, narrow interfaces, and explicit state over indirection that does not protect an invariant or remove a real source of change.

Do not use simplicity as a reason to omit required error handling, validation, synchronization, security, observability, or compatibility behavior.

## SOLID

Treat SOLID terminology as a vocabulary for inspecting design trade-offs, not as a checklist.

Split a responsibility when doing so gives parts different reasons to change, different invariants, different owners, or independently useful tests.

Introduce an interface when callers need a stable behavioral boundary or when the repository already uses that seam. Do not create interfaces solely to mirror every concrete type.

Preserve substitutability where an abstraction promises interchangeable implementations.

Prefer dependency direction that keeps domain policy independent from volatile infrastructure when the repository architecture supports that separation.

Do not reshape working repository conventions merely to make the code resemble a textbook interpretation of SOLID.

## Function and module size

Do not impose a universal line, branch, parameter, or complexity limit unless the repository or an adopted tool already defines one.

Consider splitting a function when it contains independently nameable responsibilities, requires unrelated state, mixes policy with mechanics, has failure paths that obscure the main behavior, or cannot be tested through a coherent seam.

Consider keeping a long function intact when its steps form one linear operation, splitting would require passing large amounts of incidental state, or helpers would hide rather than clarify the algorithm.

Consider splitting a module when its contents have different change reasons, dependency sets, public audiences, or ownership boundaries.

Use repository lint or complexity thresholds as local constraints, not universal design laws.

## Decision check

Before introducing an abstraction, state the concrete duplication, invariant, dependency, or change pressure it removes.

Before introducing additional complexity, state the requirement, safety property, compatibility obligation, or measured resource constraint that requires it.

Before splitting code, verify that the new boundary has a coherent name and reduces knowledge that each side needs about the other.

Before merging code, verify that the merged parts are expected to evolve together.

When evidence is ambiguous, preserve the existing repository shape and make the smallest behaviorally complete change.
