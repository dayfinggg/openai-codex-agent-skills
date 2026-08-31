# Cohesion and coupling

- Cohesion is the degree to which a module's data, behavior, and decisions belong to one concept or change together.
- Put an invariant beside the data and operations that own it.
- Choose an object when behavior must protect hidden invariants and policy, and choose a transparent record or DTO when the data shape itself is the contract. Avoid exposing a mutable structure while also attaching business behavior that assumes its invariants remain hidden.
- Keep calculations near the owner of the data they govern, except where a formatter, mapper, or adapter deliberately owns an external representation.
- One responsibility means one coherent reason to change, not one method or one arbitrary file.
- High cohesion reduces the places a reader must inspect for one behavior.
- Coupling is the knowledge and coordination one module requires from another.
- Minimize coupling by hiding representation, policy, lifecycle, and failure details behind a small contract.
- Do not pursue zero coupling; collaboration is normal, but callers should depend on stable meaning rather than implementation detail.
- A dependency is healthy when its contract is clear, its direction is intentional, and its change impact is predictable.
- At a policy boundary, let the volatile adapter depend on a stable contract owned by the consuming policy. Do not make core rules import transport, ORM, UI, or framework representations merely to reuse their data shape.
- When the application has interchangeable adapters or injected lifecycle, keep the composition root visible as the place where concrete implementations and configuration are selected. Hidden service lookup makes dependency direction and ownership harder to verify.
- Ousterhout's [modular-design notes](https://web.stanford.edu/~ouster/cgi-bin/cs190-winter18/lecture.php?topic=modularDesign) favor independent modules, information hiding, and interfaces simpler than implementations.
- Splitting a cohesive module can increase coupling through pass-through calls, shared state, and duplicated knowledge.
