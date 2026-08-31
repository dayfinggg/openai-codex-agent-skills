# Object boundaries

- Give each object one cohesive reason to change, expressed in terms of a domain responsibility.
- Expose a small set of messages and keep representation details behind private methods.
- Inject collaborators through an explicit constructor or factory instead of creating global clients inside methods.
- Make boundary inputs and outputs stable, and isolate I/O, persistence, clocks, and randomness at those boundaries.
- Prefer value objects for concepts with validation, comparison, formatting, or domain-specific invariants.
- Pass collaborators that support the needed messages rather than branching on their concrete classes.
- Avoid long chains such as `order.customer.account.plan`; delegate the question to the object that owns the knowledge.
- Use composition when behavior varies independently, and use inheritance only when the subtype contract is stable.
- Keep adapters at integration edges so vendor-specific names and errors do not leak through the domain.
- Do not create a wrapper class only to rename one call unless the wrapper establishes a meaningful boundary.
- A public method should tell a coherent story without requiring callers to know internal sequencing.
- Treat difficult setup, excessive stubbing, and tests that inspect internals as design warnings.
- Keep state ownership unambiguous; do not let several objects mutate the same collection without a contract.
- Let the caller that can recover from a failure own recovery; other layers should preserve useful context and propagate it.
