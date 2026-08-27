# Design decisions

Use these rules to select a design that fits the problem. Do not reshape code merely to demonstrate a principle or pattern.

## Simplicity, duplication, and future needs

1. Apply KISS by minimizing concepts, states, branches, dependencies, and indirection while retaining required correctness and operability. The shortest code is not automatically the simplest system.
2. Apply YAGNI to capabilities and extension points that no current requirement uses. It does not justify skipping refactoring, tests, observability, input validation, security, or error handling needed to change the code safely today.
3. Apply DRY to knowledge and intent, not to matching text. Create one authoritative representation when a single fact would otherwise need coordinated changes in several places.
4. Tolerate small local duplication while the shared concept is uncertain. Extract only after stable common behavior, vocabulary, ownership, and variation are visible.
5. Undo an abstraction when callers need flags, type checks, special cases, or unrelated options to escape it. Duplicated straightforward code is cheaper than a shared abstraction that hides different concepts.
6. Refactor in behavior-preserving steps backed by tests. Do not combine broad cleanup with a behavior change unless the cleanup is required to make the change safe.

## SOLID without dogma

1. Use SOLID mainly to reason about object-oriented boundaries and change. Do not create a class, interface, factory, or dependency-injection layer solely to satisfy an acronym.
2. Treat single responsibility as one coherent purpose or reason to change, not one method per class. A cohesive class may perform several operations over one invariant.
3. Apply open-closed design only where extension is a demonstrated source of variation. Prefer direct modification for a single owned implementation over speculative plugin points.
4. Preserve substitutability through behavioral contracts, not inheritance syntax. Subtypes must retain accepted inputs, promised outputs, invariants, errors, and side-effect expectations.
5. Split interfaces around real client needs. Do not fragment an interface so far that callers must coordinate many pieces to perform one operation.
6. Invert dependencies at volatile, external, or policy boundaries where substitution, isolation, or testing has concrete value. Depending on abstractions everywhere adds coupling of its own.

## Choose the paradigm by the work

1. Use procedural code for clear ordered workflows, orchestration, and small transformations where additional object structure would hide control flow.
2. Use functional techniques for deterministic transformations, validation, calculations, and concurrency-friendly logic. Keep side effects at explicit boundaries, but do not force awkward purity around inherently stateful operations.
3. Use objects when identity, mutable state, invariants, lifecycle, or behavior-based polymorphism form a stable concept. Prefer composition over deep inheritance when capabilities vary independently.
4. Use data-oriented or table-driven design when operations are uniform across many values and data layout, serialization, or throughput matters more than object identity.
5. Mix paradigms within a system when each is local and idiomatic. Do not translate patterns mechanically from another language.

## Cohesion, coupling, and boundaries

1. Group data and behavior that enforce one invariant or change together. Separate parts that change for different reasons, deploy independently, cross trust boundaries, or use different lifecycles.
2. Keep dependencies directed and visible. Pass required collaborators or values explicitly rather than reaching through globals, service locators, ambient context, or distant object graphs.
3. Keep domain policy independent from transport, storage, UI, and framework glue when the separation reduces change coupling. Do not add layers when the application is too small to benefit.
4. Expose the smallest useful public surface. Hide representation details and preserve room to change internals without inventing generic extension mechanisms.
5. Keep related code close enough to understand together. Excessive indirection and premature file splitting can increase coupling even when files become shorter.

## Functions, modules, and names

1. Give a function one coherent job at one level of abstraction. Split it when it combines independent decisions, has deep nesting, requires many locals, cannot be named precisely, or is difficult to test as a unit.
2. Do not enforce a universal line limit. A longer linear table or dispatch can be clearer than many tiny forwarding functions, while a short branch-heavy function can still be too complex.
3. Create a module around a stable domain concept, invariant, ownership boundary, or change axis. Avoid generic dumping grounds such as `utils`, `helpers`, `common`, or `misc` when a precise home exists.
4. Follow repository and language naming conventions first. Make names describe purpose at the point of use, with detail proportional to scope and lifetime.
5. Use nouns for values and types, verbs for operations, and predicates for booleans. Include units, direction, encoding, or state when omission could cause misuse.
6. Avoid unexplained abbreviations, misleading generic words, redundant type encodings, and names that describe an obsolete implementation rather than the contract.
7. Introduce a class only when it owns an invariant, identity, lifecycle, resource, or polymorphic contract. Prefer a data type plus functions for simple stateless transformations.
