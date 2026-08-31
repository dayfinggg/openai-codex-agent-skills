# Services and domain logic
- Name an application service after a business action, such as `PublishPost` or `ChargeInvoice`.
- Let the action coordinate repositories, transactions, and integration ports while domain objects enforce invariants.
- Keep services private by default and rely on autowiring and autoconfiguration for ordinary application classes.
- Use a repository only for a meaningful query or a persistence boundary that hides volatility.
- Do not create a bundle to organize one application's internal business logic.
- Keep required business work in the visible use case instead of an unordered event listener.
- Use forms, voters, listeners, and message handlers as adapters that call the application service.
- Configure manual services only when autowiring cannot express the intended implementation or scalar value.
