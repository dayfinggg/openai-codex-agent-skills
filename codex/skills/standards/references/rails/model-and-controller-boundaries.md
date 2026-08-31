# Model and controller boundaries

- A controller owns the HTTP boundary: authentication, authorization, parameter shape, response format, and status.
- A controller should fetch or save models, select a view or redirect, and stay thin enough to read as a request story.
- Keep SQL, persistence rules, and domain behavior out of controller actions.
- Put persisted state, associations, invariants, and behavior that naturally belongs to a record in the model.
- Use a plain Active Model object for input or domain data that does not need database persistence.
- Keep views focused on presentation and user interaction, not data writes or hidden business workflows.
- Extract a presenter or view model only when a view's derived data has a cohesive, reusable vocabulary.
- Keep authorization explicit and close to the resource lookup so an action cannot accidentally use an unscoped record.
- Use private controller methods for shared loading and parameter helpers so they cannot become actions.
- Share model behavior with a cohesive concern only when the concern has a clear domain boundary.
- Treat concerns as modules, not as a second directory for unrelated methods.
- Let a job or command object own a workflow when it is not naturally a property of one record.
