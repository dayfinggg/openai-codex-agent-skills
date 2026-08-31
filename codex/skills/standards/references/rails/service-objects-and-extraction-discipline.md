# Service objects and extraction discipline

- Rails does not require a service-object wrapper for every model call or controller action.
- Start with the conventional model, controller, job, query, or form object that owns the behavior most clearly.
- Extract a plain Ruby object when a workflow has a real domain name, multiple collaborators, or more than one caller.
- Give an extracted object one clear public operation, explicit inputs, and a result or exception contract.
- Decide and document which layer owns the transaction, authorization, retries, and external side effects.
- Keep the object usable from both a controller and a job without depending on request state.
- Delete wrappers that only delegate to `Model.create!`, rename parameters, or hide one line of CRUD.
- Prefer a cohesive object over a namespace full of tiny `*Service` classes with inconsistent contracts.
- Revisit an extraction when its only benefit is moving code away from a model or controller without reducing coupling.
- Let complexity, reuse, and a tested boundary justify the abstraction rather than folder fashion.
