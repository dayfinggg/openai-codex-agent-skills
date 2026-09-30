# Principles for every language

## Names

- A name says what the thing is or does in the domain's words: `unpaidInvoices`, not `data`, `list2` or `tmp`.
- Functions are verbs (`calculateTotal`), booleans read as questions (`isPaid`, `hasAccess`), collections are plural.
- One word per concept across the codebase. Do not mix `fetch`, `get` and `load` for the same operation.
- Units in the name when the type does not carry them: `timeoutMs`, `priceCents`.
- Follow the language's naming convention and spell words out, except abbreviations the domain itself uses.

## Functions

- One function does one thing at one level of abstraction.
- Guard clauses and early returns instead of nested conditionals.
- Avoid flags that hide unrelated operations. Preserve ordinary boolean options and existing public signatures.
- Group parameters when they form one meaningful concept, not solely because of their count.
- Separate calculations from side effects when useful, without splitting a cohesive operation just because it also returns a result.
- Pure functions for calculations. Keep side effects such as I/O, time and randomness at the edges and pass their results in.

## Data and state

- Immutable by default: `const`, `readonly`, frozen dataclasses, value objects. Mutate only where it is the clear intent.
- No global mutable state and no singletons holding request data.
- Named constants instead of magic numbers and strings.
- Make invalid states unrepresentable with types, enums and constructors that validate.
- Money as integer minor units or decimals, never floats. Store instants consistently in UTC. Preserve calendar dates and named zones for local schedules.
- Distinguish missing values from valid zero, false and empty values according to the contract. Do not use truthiness as a substitute for validation.
- Leave no dead code, unused parameters or commented-out code in what you write or change. Version control keeps history.

## Errors

- Fail fast on invalid input and broken invariants with a specific error type and a message that says what was expected and what arrived.
- Never swallow an error. Catch only what you can handle, and rethrow or wrap with context otherwise.
- Do not use exceptions for normal control flow.
- Handle errors once, at the boundary that can decide what to do, and log them there with context.
- Never log secrets, passwords, tokens or full personal data.

## Resources and I/O

- Every network call has a timeout. Retry only idempotent operations, a limited number of times, with randomized exponential backoff, and at one layer only. Pass the remaining deadline down instead of starting a new one.
- Close files, connections and handles with the language's scoped construct (`with`, `try`/`finally`, `using`).
- Stream large files and result sets instead of loading them whole into memory.
- Batch database and network calls instead of making them one per item.

## Concurrency

- Run independent I/O concurrently when useful, with bounded active and queued work for growing inputs. Respect stream backpressure and propagate cancellation to release abandoned resources.
- Never block an event loop with synchronous file, network or CPU-heavy work. Offload according to the runtime and workload, not by adding threads indiscriminately.
- Protect shared state with transactions, locks or atomic operations, and prefer designs without shared state.
- Make handlers for queues, webhooks and retries idempotent, because they will run more than once.

## Performance

- Choose the data structure for the access pattern: a map or set for lookups, not a linear search inside a loop.
- Know the complexity of loops over user-controlled data. Nested loops over two large inputs need a better algorithm.
- Do expensive work once: move invariant work out of loops, cache with an explicit invalidation rule, precompute where reads dominate.
- Measure before optimizing anything that makes the code harder to read.

## Scalability

- For multi-instance services, keep state that must survive restarts or be shared in appropriate durable storage. Process memory and local disk remain valid for explicitly local or transient workloads.
- Start fast and shut down gracefully on `SIGTERM`: stop taking work, finish or return in-flight jobs, close connections.
- Every list endpoint and query over growing data is paginated or bounded.
- Use a queue when work must outlive a request, be replayed safely or be distributed. Do not add queue infrastructure to a task that does not need it.

## Dependencies

- Prefer the standard library and the platform. Add a dependency only when it saves real work, is actively maintained and has a compatible license.
- Install through the package manager so the lockfile records it, and never vendor copied library code.

## Changing existing code

- Read the affected code and tests. Search for callers and inspect those relevant to the changed contract, rather than requiring a full project scan for every edit.
- Add a focused regression or behavior test when it provides a practical check through existing facilities. Untested code does not automatically require a new harness before every edit.
- Keep refactoring and behavior changes apart. A refactoring leaves every existing test passing without editing it. Change behavior in a separate step with its own tests.
- Check meaningful increments and the final changed behavior with relevant tests, expanding to the full suite when shared impact or project rules require it.
- Keep public contracts such as function signatures, API responses, database schemas and file formats compatible, or update every caller in the same change.
- Leave code the task does not touch as it is, even when it could be better. Mention real problems in the report.

## Self-review before reporting

Read your full diff once as a reviewer and fix what fails:

1. Does it do exactly what was asked, including edge and error cases?
2. Is anything more complex than the task needs, or built for a future that was not requested?
3. Does every name say what it means, and does the style match the surrounding code?
4. Would each piece of the design still make sense to someone reading only this diff?
5. Do the relevant checks support the changed behavior after the final edit?
6. Does the change keep the rest of the system as healthy as before?
