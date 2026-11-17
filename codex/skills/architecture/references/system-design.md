# System design

Read this before deciding how a service handles failure, load, data ownership, its interfaces and its operation. Apply a rule where its condition holds: a script or an internal tool with a handful of users needs few of them, and the table near the end names the cases where a rule is overkill.

## Decide in this order

1. Write down what the system has to do and for whom, then the qualities it has to keep. Kleppmann names three: reliability, scalability and maintainability. Give each a number where you can, such as requests per second, the response time that 99% of requests stay under, and the downtime the business accepts.
2. Pick the simplest structure that meets those numbers. The Google SRE book gives the reason: "software simplicity is a prerequisite to reliability".
3. Name what you gave up, and record the decision as an ADR when it is costly to reverse.

## Reliability

- Set a timeout on every remote call, and on calls across processes on the same host too. Without one, a slow dependency holds threads and connections until the caller fails as well.
- Retry only idempotent operations, with capped exponential backoff and jitter, and at one layer of the stack only. Retries at every layer multiply the load on a dependency that is already failing.
- An operation with side effects becomes safe to retry when it takes an idempotency key. The mechanics are in backend-api.
- Design each component to detect a failure, degrade and recover without a person: health checks, restarts by the supervisor, and redundancy for anything whose loss stops the system.
- Test recovery on purpose: kill the process, cut the dependency, restore the backup. A recovery path that never ran is an assumption.
- Start fast and shut down gracefully: on SIGTERM stop taking new work and finish or hand back the work in flight (Twelve-Factor IX).

## Scalability

- Keep processes stateless and share nothing between them. Session data, uploads and locks live in a backing service, not in process memory or on local disk (Twelve-Factor VI). Then the system scales out by adding instances, with no sticky sessions.
- Minimize coordination between services. Where the caller does not need the result at once, hand the work to a queue.
- Find the bottleneck by measurement before you change the design. The four golden signals are latency, traffic, errors and saturation.
- Measure before you add a cache, a replica or a partition. Each one adds a consistency problem and an operating cost that stay after the load is gone.

## Data

- Each module or service is the only reader and writer of its tables. A bounded context covers its code and its schema (Evans). Another module gets the data through the owner's interface or its events, not through a join.
- Choose the consistency each operation needs. Money and stock need a transaction in one database, while a search index or a report can lag.
- A change that spans two stores cannot be atomic. Write to one store and publish from it with a transactional outbox, and make every consumer idempotent. The mechanics are in backend-api.
- Keep each schema change compatible with the release that runs before it, so that old and new code work side by side during a deploy. Migrations and locks are in database.

## Interfaces

- Hyrum's law: with enough consumers, every observable behavior of an interface is depended on by somebody. Keep the surface small and treat a change in observable behavior as a breaking change.
- Version a public contract and deprecate it with notice. HTTP contracts are in backend-api. An internal entry point changes in one pass together with all its callers.
- Use a synchronous call when the caller needs the answer now. Use an event when the producer must not know its consumers or the work has to survive a consumer being down.

## Operations

- Give each user-facing path a service level objective: a target for a measured indicator, such as "99.9% of checkout requests succeed within 1 s over 30 days". Alert on the objective, which is what users feel, not on every possible cause.
- Write logs as an event stream to stdout and let the platform route them (Twelve-Factor XI). Build logs, metrics and traces into the first version. Setup is in containers-iac.
- Keep configuration that varies between deploys in the environment, not in the code (Twelve-Factor III).
- Make every deploy reversible: one command returns to the previous release, and the database stays compatible with it.

## Changing an existing system

- Replace a legacy system one use case at a time, behind a facade that routes each request to the old or the new code (strangler fig). Fowler writes that the plan to build a new system that does exactly the same goes "down in flames most of the time".
- Draw and prove the module boundaries inside the monolith before you extract a service. Services work only with good, stable boundaries, and those are learned by building the monolith first.
- Team boundaries shape system boundaries (Conway's law). Split a service along a line where one team can own, deploy and run each side.

## When a rule is overkill

| Rule | Skip it when |
| --- | --- |
| Bounded contexts and context maps | One team works on one small model |
| Ports and adapters | The code behind the port is your own database with one implementation |
| Service level objectives | A batch job or an internal tool has no user waiting on it |
| Stateless scale-out | Load is fixed, and one instance with a restart policy meets the availability the business accepts |
| Strangler fig | The system is new |

## Sources

[Timeouts, retries, and backoff with jitter](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/) from the Amazon Builders' Library, [The Twelve-Factor App](https://12factor.net/), [Azure design principles](https://learn.microsoft.com/en-us/azure/architecture/guide/design-principles/), the [reliability pillar](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/design-principles.html) of the AWS Well-Architected Framework, the Google SRE book on [simplicity](https://sre.google/sre-book/simplicity/), [monitoring](https://sre.google/sre-book/monitoring-distributed-systems/) and [service level objectives](https://sre.google/sre-book/service-level-objectives/), [Designing Data-Intensive Applications](https://dataintensive.net/), the [DDD Reference](https://www.domainlanguage.com/wp-content/uploads/2016/05/DDD_Reference_2015-03.pdf), [Hyrum's law](https://www.hyrumslaw.com/), [StranglerFigApplication](https://martinfowler.com/bliki/StranglerFigApplication.html), [MonolithFirst](https://martinfowler.com/bliki/MonolithFirst.html) and [How Do Committees Invent?](https://www.melconway.com/Home/Committees_Paper.html).
