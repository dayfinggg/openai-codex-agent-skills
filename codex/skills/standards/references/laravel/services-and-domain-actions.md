# Services and domain actions
- Name application services after business actions, such as `PublishPost` or `RefundOrder`.
- Let an action coordinate Eloquent repositories, transactions, authorization policy calls, and integration ports.
- Keep domain rules in plain PHP objects or Eloquent methods only when the rule is owned by that model.
- Do not make a generic `*Service` class a dumping ground for unrelated operations.
- Do not make every model pass through a repository when Eloquent already expresses the required query clearly.
- Reuse the same action from HTTP, Artisan, scheduled tasks, jobs, and event listeners.
- Keep framework facades and `app()` resolution at composition or edge code, not in domain logic.
