# Transactions and persistence
- Place `@Transactional` around an application use case that changes one consistency boundary.
- Keep remote calls, message publication, and long waits outside the database transaction when possible.
- Remember that proxy-based transactions apply to external calls through the proxy, not same-class self-invocation.
- Runtime exceptions and errors roll back by default, while checked exceptions need an explicit rollback rule.
- Prefer concrete-class transaction annotations and test rollback behavior instead of assuming the annotation is active.
- Select the transaction manager that matches imperative, reactive, or multiple-database work.
- Use reactive transaction operators for coroutine or reactive data paths rather than mixing thread-bound and reactive contexts.
- Do not mistake `readOnly` for an authorization or consistency guarantee.
- Let repositories own query shape and persistence mapping while the service owns the unit of work.
