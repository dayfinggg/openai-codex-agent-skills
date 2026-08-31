# Jobs and asynchronous work

- Use Active Job for work that should not block the request, such as mail, imports, cleanup, and external API calls.
- Keep `perform` small, explicit, and safe to run more than once.
- Pass stable identifiers or supported Global ID arguments rather than large mutable object graphs.
- Reload records in the job and handle records that were deleted or changed before execution.
- Enqueue after commit when a job depends on data that the surrounding transaction creates or updates.
- Do not assume transactional enqueue behavior across adapters or across separate Solid Queue databases.
- Choose queue names and priorities from operational needs, then document worker capacity and ordering assumptions.
- Use `retry_on` for transient, understood failures and `discard_on` for failures that cannot succeed later.
- Bound retries and make external calls idempotent before enabling automatic retries.
- Report exhausted failures and preserve enough identifiers to diagnose them without logging secrets.
- Use concurrency controls when duplicate jobs could overload a resource and the backend supports them.
- Keep request-specific state out of jobs and make timeouts, rate limits, and authentication explicit.
- Test enqueueing, arguments, retry or discard policy, and the meaningful effect of `perform`.
