# Rails quality reference

Use this as a default for current Rails applications, then follow the repository's own guide.
This reference targets the Rails 8.1-era Guides and remains subject to the application's supported versions.
Read `config.load_defaults`, the database adapter, and local CI rules before changing behavior.
Prefer the Rails defaults until a measured requirement justifies a deviation.

## Conventions and structure

- Keep conventional names and paths so routing, autoloading, generators, and teammates can find code.
- Use `app/models`, `app/controllers`, `app/views`, `app/jobs`, and the matching `test` directories.
- Prefer resourceful routes and actions such as `index`, `show`, `new`, `create`, `edit`, `update`, and `destroy`.
- Let routes describe resources, not implementation details or arbitrary controller verbs.
- Keep one resource and one responsibility per controller where practical.
- Use generators as a starting point, then review every generated migration, callback, route, and test.
- Keep schema changes reversible where feasible and deploy them in an order that works with old and new code. For inherently destructive changes, raise `ActiveRecord::IrreversibleMigration` or require an explicit backup and forward-fix plan.
- Treat the database schema as a shared contract, not merely a reflection of Ruby classes.
- Use Rails' naming and inflection conventions before adding explicit table, class, or foreign-key configuration.
- Add explicit configuration when the domain genuinely differs from the convention, and document the reason.
- Keep configuration in the normal Rails files so a new contributor can trace behavior without hunting custom boot code.
- Follow the application's formatter, linter, Ruby version, and test commands rather than imposing a new tool.
- Prefer the integrated Rails stack when it solves the problem; add a dependency only for a concrete capability.
- Make deviations easy to remove by isolating them behind normal Rails interfaces.

## Model and controller boundaries

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

## Active Record

- Model tables and relationships with clear `belongs_to`, `has_many`, `has_one`, and `through` associations.
- Choose `dependent` behavior deliberately because `destroy`, `delete`, nullification, and restriction have different effects.
- Add foreign keys, unique indexes, check constraints, and non-null constraints in migrations when the database can enforce them.
- Use scopes for small, chainable relation definitions that do not perform writes or surprise callers.
- Return relations from query methods so callers can compose, paginate, or further constrain them.
- Use `find_by!` or bang persistence methods when failure must be visible at the boundary.
- Use non-bang methods when invalid user input is an expected branch and render the errors deliberately.
- Use `update_all`, `delete_all`, `insert_all`, and `upsert_all` only with an explicit decision about skipped callbacks and validations.
- Remember that bulk SQL can bypass timestamps, callbacks, validations, and application-level invariants.
- Parameterize custom SQL and prefer Arel or documented query methods over string interpolation.
- Keep raw SQL narrowly scoped and explain why the relation API cannot express the query clearly.
- Use `includes`, `preload`, or `eager_load` intentionally, and verify the resulting query plan.
- Use `find_each` or `in_batches` for large sets instead of loading every row into memory.
- Select or pluck only the columns needed by a measured hot path, while retaining records when behavior needs models.
- Keep transactions around one database connection and do not assume they coordinate separate databases.
- Put database invariants in the database and use model validations for useful application-facing error messages.

## Validations

- Validate user-facing and domain input before persistence with the smallest clear validator.
- Remember that `save`, `create`, and `update` return failure information, while bang variants raise `RecordInvalid`.
- Add a unique database index for every uniqueness rule that must hold under concurrent writes.
- Match scoped uniqueness validations with the same composite unique index in the database.
- Treat validation as a friendly preflight, not a substitute for database constraints or authorization.
- Identify every write path that can bypass validations before relying on a model rule.
- Use custom validators for domain rules that need names, reuse, or more precise error messages.
- Keep validators deterministic and local; do not make network calls or mutate unrelated records during validation.
- Use conditional validation only when the condition is part of the domain and is easy to understand.
- Test both valid and invalid states, including boundary values and database constraint failures.

## Callbacks

- Use callbacks for short, local lifecycle behavior whose ordering is obvious from the model.
- Keep normalization and record-local invariant maintenance close to the record when a callback improves correctness.
- Treat callbacks as implicit control flow that every save, destroy, import, and test fixture may trigger.
- Avoid hiding email, network calls, billing, or long workflows in `before_save`, `after_save`, or `after_destroy`.
- Use `after_commit` for work that must observe committed data, such as cache invalidation or external notifications.
- Make `after_commit` work idempotent because it runs after persistence and cannot roll the transaction back.
- Remember that an exception in `after_commit` does not undo the already committed database change.
- Use `after_rollback` only for rollback-specific cleanup and test its behavior in nested transactions.
- Use `throw :abort` or the documented callback result when deliberately cancelling a lifecycle operation.
- Place `before_destroy` before `dependent: :destroy` associations when its ordering matters.
- Document callbacks that are required for correctness and test the public operation that triggers them.
- Review bulk and direct SQL calls because they may bypass the callbacks that protect ordinary writes.

## Transactions

- Wrap multiple writes in a transaction when they must commit or roll back as one unit.
- Prefer `save!` and `update!` inside a transaction so an unexpected failure cannot be silently ignored.
- Keep transaction blocks short and avoid network calls, sleeps, rendering, and user interaction inside them.
- Use `after_commit` or an outbox-like design to publish work after the database state is durable.
- Do not rescue `ActiveRecord::StatementInvalid` inside a transaction and continue issuing queries.
- Restart the whole transaction after a database-level failure, especially on PostgreSQL.
- Know that nested `transaction` blocks join the parent by default.
- Use `requires_new: true` only when a savepoint boundary is actually required and the adapter supports it.
- Test both commit and rollback paths, including object state after rollback.
- Remember that transactions do not restore in-memory Ruby objects automatically.
- Treat cross-database workflows as distributed operations that need explicit consistency and retry decisions.
- Use the current transaction callback APIs only when their commit or rollback timing is part of the design.

## Jobs and asynchronous work

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

## Security

- Authenticate and authorize every sensitive action, including actions reachable through guessed or changed IDs.
- Scope lookups through the current account or user instead of loading a global record and checking later.
- Use strong parameters at the controller boundary with `params.expect` when strict shape and required keys are useful.
- Use `permit` deliberately for accepted attributes and never pass the entire parameter hash to a model.
- Keep CSRF protection enabled for cookie-backed browser sessions and do not disable it globally to fix one client.
- Give API clients an explicit authentication and CSRF strategy that matches their credential transport.
- Rely on Rails output escaping and treat `html_safe`, `raw`, and user-supplied HTML as security-sensitive.
- Never interpolate request data into SQL, shell commands, file paths, redirects, or template code.
- Prefer parameterized queries, allowlists, safe URL generation, and vetted upload handling.
- Hash passwords with the supported password facility and never store plaintext credentials.
- Encrypt or sign sensitive cookie values and keep secrets in credentials or the deployment secret manager.
- Filter passwords, tokens, authorization headers, and other secrets from logs and exception reports.
- Use a Content Security Policy and prefer nonces over `unsafe-inline` when inline scripts remain necessary.
- Validate upload type, size, name, and storage location, and do not serve untrusted files as executable content.
- Add regression tests for authorization, parameter overposting, unsafe redirects, and injection-shaped input.

## Performance and operations

- Measure before optimizing with request logs, Active Support instrumentation, database statistics, and representative load.
- Inspect slow relations with `EXPLAIN` and fix the query, index, cardinality, or pagination strategy that the plan exposes.
- Prevent N+1 queries with deliberate eager loading and use `strict_loading` in paths where lazy loading is forbidden.
- Avoid unbounded lists; paginate or batch both database work and response rendering.
- Add indexes for real filters, joins, and ordering, then verify that the database uses them.
- Use fragment or low-level caching for measured hot paths and choose keys that change when the data changes.
- Keep cache invalidation close to the write and avoid caching personalized or secret data in shared stores.
- Treat asynchronous query loading and concurrency settings as measured options, not automatic improvements.
- Watch database connection pool size, job worker concurrency, and external service limits together.
- Instrument important jobs and requests with stable names and useful tags, without putting secrets in query comments.
- Prefer a simple query and clear index over speculative denormalization or a cache that no one can invalidate.
- Recheck memory use when replacing a batch relation with arrays, hashes, or eager-loaded object graphs.

## Testing

- Keep tests focused on observable behavior and use the Rails test type that matches the boundary under test.
- Test models for validations, associations, scopes, constraints, and domain behavior.
- Test requests or integration flows for routing, authorization, parameters, status codes, and rendered outcomes.
- Test jobs with the Active Job test helpers and assert both enqueueing and meaningful work.
- Use system tests for a small set of critical browser workflows, not for every branch or form field.
- Prefer fast unit, model, request, and job tests for most cases, then cover high-value end-to-end paths.
- Keep fixtures or factories consistent with the repository and make records valid by default.
- Test failure paths explicitly, including rollback, retry, authorization denial, malformed input, and missing records.
- Assert query counts or instrumentation in hot paths when query behavior is an intentional contract.
- Run tests against the supported database adapter because constraint and transaction behavior can differ.
- Parallelize only when tests isolate data, time, filesystem state, and global configuration.
- Do not make tests depend on callback order or private implementation details unless that order is the contract.
- Keep tests deterministic, independent, and safe to rerun after a failed job or rollback.

## Hotwire and browser behavior

- Start with server-rendered HTML and progressive enhancement before adding client-side state machinery.
- Use Turbo Drive for fast navigation, Turbo Frames for independently replaceable regions, and Turbo Streams for targeted updates.
- Reuse the same server-rendered partials for the initial page and subsequent Turbo updates.
- Provide an ordinary HTML redirect or render path when a Turbo-specific response is not required.
- Use `respond_to` to make HTML and Turbo Stream behavior explicit at the action boundary.
- Keep Turbo Stream actions small and predictable; use Stimulus controllers for behavior that is not a stream operation.
- Give replaceable elements stable DOM IDs and preserve focus, labels, errors, and keyboard behavior.
- Test the resulting HTML and important Turbo responses, not just that a controller branch executed.
- Prefer accessible semantics and progressive enhancement over JavaScript-only controls.
- Use a larger JavaScript framework only when the interaction model or team needs exceeds Hotwire's strengths.

## Service objects and extraction discipline

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

## Sources

### Official Rails and Hotwire documentation

- [S1: The Rails Doctrine, David Heinemeier Hansson](https://rubyonrails.org/doctrine)
- [S2: Getting Started with Rails](https://guides.rubyonrails.org/getting_started.html)
- [S3: Active Record Basics](https://guides.rubyonrails.org/active_record_basics.html)
- [S4: Active Record Validations](https://guides.rubyonrails.org/active_record_validations.html)
- [S5: Active Record Callbacks](https://guides.rubyonrails.org/active_record_callbacks.html)
- [S6: Active Record Transactions API](https://api.rubyonrails.org/classes/ActiveRecord/Transactions/ClassMethods.html)
- [S7: Active Record Query Interface](https://guides.rubyonrails.org/active_record_querying.html)
- [S8: Active Record Associations](https://guides.rubyonrails.org/association_basics.html)
- [S9: Action Controller Overview](https://guides.rubyonrails.org/action_controller_overview.html)
- [S10: Securing Rails Applications](https://guides.rubyonrails.org/security.html)
- [S11: Active Job Basics](https://guides.rubyonrails.org/active_job_basics.html)
- [S12: Testing Rails Applications](https://guides.rubyonrails.org/testing.html)
- [S13: Caching with Rails](https://guides.rubyonrails.org/caching_with_rails.html)
- [S14: Working with JavaScript in Rails](https://guides.rubyonrails.org/working_with_javascript_in_rails.html)
- [S15: Turbo Handbook, Introduction](https://turbo.hotwired.dev/handbook/introduction)
- [S16: Turbo Handbook, Streams](https://turbo.hotwired.dev/handbook/streams)
- [S17: Stimulus Handbook, Introduction](https://stimulus.hotwired.dev/handbook/introduction)
- [S18: Ruby on Rails 8.0 Release Notes](https://guides.rubyonrails.org/8_0_release_notes.html)
- [S25: Ruby on Rails 8.1 Release Notes](https://guides.rubyonrails.org/8_1_release_notes.html)

### Maintainer repositories and examples

- [S19: Rails source repository](https://github.com/rails/rails)
- [S20: Rails Active Record transaction tests](https://github.com/rails/rails/blob/main/activerecord/test/cases/transactions_test.rb)
- [S21: Rails Active Job test example](https://github.com/rails/rails/blob/main/activejob/test/jobs/hello_job.rb)
- [S22: turbo-rails source repository](https://github.com/hotwired/turbo-rails)
- [S23: Solid Queue source repository](https://github.com/rails/solid_queue)

### Practitioner and community talk

- [S24: Rails World talk, Making accessible web apps with Rails and Hotwire](https://rubyonrails.org/world/2024/day-2/bruno-prieto)
