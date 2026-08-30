# Rust engineering standards

Use this reference as a design and review checklist for production Rust.
Prefer designs whose ownership, validity, failure, and concurrency rules are visible in types.
Encode invariants in types where practical. Keep runtime validation for external input, environmental state, and conditions that cannot be known at compile time.
Prefer the simplest correct standard-library abstraction before adding a dependency or a custom layer.
Keep behavior unsurprising, names conventional, and public APIs smaller than their implementations.

## Idiomatic Rust

Use exhaustive `match` and deliberate enums when a value has a closed set of states.
Use `Option<T>` for absence and `Result<T, E>` for an operation that can fail.
Use `?` to propagate errors and add context at a boundary where the operation is understood.
Prefer iterator adapters when they make the transformation clearer, but use a loop when control flow is clearer.
Avoid needless allocation, cloning, conversion, and collection of intermediate values.
Treat every `clone` as an explicit cost and explain it when ownership cannot be made clearer.
Accept slices such as `&str` and `&[T]` when a function does not need ownership or vector-specific behavior.
Return an owned value when the result must outlive an input borrow or cross an ownership boundary.
Derive common traits when their semantics are correct, rather than implementing boilerplate manually.
Use `Default` only when a meaningful default exists and document non-obvious defaults.
Use `#[must_use]` for values whose omission would usually be a bug, such as a builder or a fallible result.
Keep unsafe-looking behavior out of safe APIs unless the safe wrapper enforces its complete invariant.

## Ownership-driven design

Give each resource a clear owner and make that owner responsible for cleanup and lifecycle.
Pass `&T` for read-only borrowing, `&mut T` for exclusive temporary access, and `T` to transfer ownership.
Keep borrows as short as practical so later mutation and independent operations remain possible.
Do not add lifetime parameters until the relationship between references cannot be expressed by inference.
Use lifetime annotations to state relationships between borrowed inputs and outputs, not to extend validity.
Use `move` closures or owned values when work may outlive the current stack frame.
Prefer ownership transfer over shared mutable state when a pipeline or channel can express the relationship.
Use `Rc` or `Arc` only when shared ownership is part of the design, not to silence a borrow-checker error.
Use `RefCell`, locks, and atomics only when their runtime coordination semantics are intentional and tested.
Use RAII and `Drop` to release files, locks, sockets, temporary resources, and other capabilities deterministically.
Use a newtype to encode units, validated identifiers, permissions, or other distinctions that a primitive cannot express.
Use indices, arenas, or owned handles instead of forcing a self-referential structure.
When a borrow-checker error appears, first revisit ownership and scope before adding `clone`, `Arc`, or interior mutability.
Avoid storing references in long-lived structs unless the lifetime is genuinely part of the type's contract.
Document whether a method borrows, mutates, consumes, caches, or invalidates its receiver.

## Error types and failure policy

Separate expected operational failures from violated programmer invariants.
Return `Result<T, E>` by default from public operations that can fail, so callers choose whether to recover or stop.
Reserve `panic!`, `unwrap`, and `expect` for proven invariants, impossible states, tests, examples, or deliberate process aborts.
Use `expect` instead of `unwrap` when a panic is justified and the invariant deserves a diagnostic message.
Define a typed error enum when callers need to distinguish stable failure cases.
Give error variants names that describe the failed operation and preserve the relevant input or cause.
Implement `Display` for a useful user-facing message and `Error` for composability when the type is public.
Preserve lower-level causes through `source` or `From` conversions rather than flattening them into strings.
Use `?` and `From` conversions for routine propagation, and map errors only when the abstraction boundary changes.
Do not use `bool`, `Option`, or a sentinel value to hide a meaningful error condition.
Do not expose unstable implementation errors as public API unless callers can act on them.
Document `Errors`, `Panics`, and `Safety` sections for public functions whenever those conditions are relevant.
Write error names in a consistent order such as `ParseFooError`, matching standard-library vocabulary.
At an application boundary, aggregate or render errors for humans only after the typed cause has done its work.

## Traits and generics

Define a trait for behavior that has several meaningful implementations, not merely to group fields.
Keep a trait cohesive, small enough to implement correctly, and explicit about required invariants.
Put bounds where they are needed and use a `where` clause when a signature becomes hard to scan.
Use generic parameters when a function may accept many concrete types and the caller benefits from static dispatch.
Use `impl Trait` for an opaque concrete return chosen by the implementation.
Use `dyn Trait` when callers need heterogeneous values or runtime-selected implementations.
Use associated types when each implementation has one natural related type; use generic parameters for multiple choices.
Implement `From`, `Into`, `AsRef`, and `AsMut` when a conversion or view follows standard semantics.
Implement `Debug`, `Display`, `Default`, `Clone`, equality, ordering, and hashing only when their meanings are sound.
Do not implement `Copy` for a type that represents ownership of a resource or has meaningful destruction.
Respect coherence and orphan rules; use a newtype when an external type needs a local trait implementation.
Prefer a method on the type with the clearest receiver and avoid blanket implementations that create surprising inference.
Keep trait objects and generic bounds off the public surface unless their dispatch, object-safety, and lifetime costs are intended.
Test each default method and each required invariant through at least one representative implementation.

## Modules and crate boundaries

Treat a package as a build unit, a crate as a module tree producing a library or executable, and a module as a privacy boundary.
Organize modules around domain concepts, invariants, and ownership, not around arbitrary line counts.
Keep items private by default and expose only the smallest stable interface required by callers.
Remember that `pub mod` exposes the module path but does not make its contents public.
Use a root-level facade and targeted `pub use` re-exports when a stable path is more valuable than internal layout.
Keep implementation modules private so refactoring does not become a public API change.
Place unit tests beside the module they explain, and let those tests exercise private behavior when that improves diagnosis.
Use separate crates when an independent dependency boundary, compile unit, or ownership boundary is valuable.
Avoid deep module paths, wildcard re-exports, and names that force callers to understand implementation details.
Keep feature names additive, meaningful, and free of placeholder words such as `use-` or `with-`.
Make `main` small when possible, and put reusable behavior in a library crate that integration tests can call.

## Public API guidelines

Follow Rust casing: types and traits use `UpperCamelCase`, while functions, methods, and modules use `snake_case`.
Use `new` for the primary constructor and `with_*` for meaningful construction alternatives.
Name getters after the value, such as `path`, and reserve `get` for an unambiguous getter or a checked lookup convention.
Use `as_` for a cheap borrowed view, `to_` for a potentially costly same-level conversion, and `into_` for ownership transfer.
Name collection iterators `iter`, `iter_mut`, and `into_iter`, with matching iterator type names.
Prefer meaningful enums, structs, and newtypes over several positional booleans or overloaded primitive arguments.
Use a builder when a value has optional configuration, compound inputs, or side-effecting construction.
Validate arguments at the narrowest boundary that can report a useful error.
Document side effects, allocation behavior, blocking, ordering, panic conditions, and thread-safety when they matter to callers.
Within reason, give public items a focused rustdoc example or a direct link to a related example that demonstrates why the item exists, and make fallible examples use `?`.
Make examples compile as documentation tests and keep them free of accidental `unwrap` calls.
Avoid inherent methods on smart pointers when the method belongs semantically to the pointee.
Treat every public signature, re-export, trait implementation, and error variant as a compatibility commitment.

## Async and concurrency

An `async fn` creates a future; a runtime must poll that future for progress.
Choose async for many I/O-bound operations that benefit from cooperative waiting, and choose threads for blocking or parallel work when appropriate.
Treat threads and async tasks as complementary rather than mutually exclusive execution models.
Never perform unbounded blocking I/O or long CPU work on an async executor thread.
Use the runtime's blocking bridge or a dedicated worker for unavoidable blocking or CPU-bound operations.
Keep `.await` points visible and consider what state, locks, borrows, and cancellation can cross each one.
Do not hold a blocking mutex guard across `.await`; shorten the critical section or use an async-aware design deliberately.
Bound task counts, queue sizes, retries, and buffering so backpressure is explicit.
Propagate task errors and join or cancel spawned work according to the owning operation's lifecycle.
Require `Send` and `'static` only when the executor or spawned task actually requires them.
Use channels for ownership transfer and message passing when shared mutable state would add unnecessary coordination.
Use `Arc`, `Mutex`, `RwLock`, or atomics only with a clear contention and ordering model.
Make cancellation and drop behavior part of the API contract for operations that own external work.
Test async logic without a live server where possible by constructing an app or service value and calling it directly.

## Formatting, linting, and tests

Run `cargo fmt --all -- --check` in CI and use the repository's toolchain and formatting configuration consistently.
Prefer rustfmt defaults, and treat a formatting-version change as an intentional repository-wide change.
Run `cargo clippy --all-targets --all-features -- -D warnings` in CI when the project can support that policy.
Use the same Clippy toolchain as the compiler and allow a lint narrowly with a reason when the code is intentionally exceptional.
Fix correctness, suspicious, complexity, and performance lints before debating style or pedantic lints.
Do not enable all restriction lints blindly because they can conflict with one another and with valid designs.
Run `cargo test` because it builds unit, integration, and documentation tests by default.
Keep unit tests close to the implementation and integration tests under `tests/` to exercise only the public contract.
Test public examples, boundary values, error variants, panic contracts, feature combinations, and concurrency shutdown paths.
Prefer deterministic clocks, injected transports, temporary resources, and controlled schedulers over sleeps and live services.
Name tests after observable behavior and make failures identify the violated rule.
Use property, fuzz, benchmark, or model tests when examples cannot cover the state space or performance contract.

## Unsafe boundaries

Use unsafe only for a demonstrated need such as FFI, hardware access, layout control, or a measured optimization.
Keep each unsafe block as small as possible and surround it with ordinary safe code that establishes its preconditions.
`unsafe` enables a small set of operations; it does not disable all borrow checking or make an invalid operation sound.
Write a `Safety` section for every unsafe public function, unsafe trait implementation, and safe wrapper around unsafe code.
State every caller obligation, including pointer validity, alignment, initialization, aliasing, lifetime, thread-safety, and ownership.
Validate inputs before unchecked operations and keep the validation adjacent to the unsafe use.
Prefer a safe abstraction that owns the invariant instead of exporting raw pointers or repeating unsafe reasoning at call sites.
Audit unsafe code as a boundary, not as an isolated expression, because safe code can establish or invalidate its assumptions.
Keep FFI translation types explicit and convert external ownership and error conventions immediately at the boundary.
Use safe tests for the wrapper's behavior and targeted tools or reviews for the unsafe invariant itself.
Never implement `Send` or `Sync` manually without a written proof that the type upholds the required concurrency guarantees.

## Size and cohesion heuristics

There is no universal function or module line limit; cohesion, coupling, and reviewability are better signals.
Split a function when it mixes validation, I/O, policy, transformation, and formatting that can change independently.
Split a module when its items serve different domain concepts, invariants, owners, or reasons to change.
Keep a small wrapper intact when splitting it would hide the control flow or create a pass-through abstraction.
Treat repeated fixtures, unrelated imports, long parameter lists, and difficult lifetimes as cohesion warnings.
Treat many public re-exports, feature conditions, or dependency edges as boundary warnings.
Prefer one clear ownership story per function and one clear invariant per type.
Use compile time, test time, and navigation cost as practical signals when deciding whether a boundary helps.
Revisit a boundary when callers need private details, when tests duplicate internals, or when changes require edits across many modules.

## Verified examples and maintainer guidance

Tokio's maintained example returns `Result` from `main`, uses `?`, and awaits an async TCP write without hiding failure.
Axum's maintained testing example exposes an app factory and tests the router directly without starting a server.
The standard library's maintained channel module documents ownership transfer, bounded versus unbounded channels, and disconnect errors.
Niko Matsakis's ownership talk illustrates ownership, borrowing, channels, locks, and safe abstractions as one design model.

## Sources

### Official Rust documentation and specifications

- [The Rust Programming Language: Ownership](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html)
- [The Rust Programming Language: What Is Ownership?](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html)
- [The Rust Programming Language: References and Borrowing](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html)
- [The Rust Programming Language: Packages, Crates, and Modules](https://doc.rust-lang.org/book/ch07-00-managing-growing-projects-with-packages-crates-and-modules.html)
- [The Rust Programming Language: Module Paths and Privacy](https://doc.rust-lang.org/book/ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html)
- [The Rust Programming Language: Error Handling](https://doc.rust-lang.org/book/ch09-00-error-handling.html)
- [The Rust Programming Language: Recoverable Errors with Result](https://doc.rust-lang.org/book/ch09-02-recoverable-errors-with-result.html)
- [The Rust Programming Language: To panic! or Not to panic!](https://doc.rust-lang.org/book/ch09-03-to-panic-or-not-to-panic.html)
- [The Rust Programming Language: Generic Types, Traits, and Lifetimes](https://doc.rust-lang.org/book/ch10-00-generics.html)
- [The Rust Programming Language: Traits](https://doc.rust-lang.org/book/ch10-02-traits.html)
- [The Rust Programming Language: Lifetimes](https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html)
- [The Rust Programming Language: Writing Automated Tests](https://doc.rust-lang.org/stable/book/ch11-00-testing.html)
- [The Rust Programming Language: Test Organization](https://doc.rust-lang.org/book/ch11-03-test-organization.html?highlight=integration)
- [The Rust Programming Language: Fearless Concurrency](https://doc.rust-lang.org/book/ch16-00-concurrency.html)
- [The Rust Programming Language: Message Passing](https://doc.rust-lang.org/book/ch16-02-message-passing.html)
- [The Rust Programming Language: Shared-State Concurrency](https://doc.rust-lang.org/book/ch16-03-shared-state.html)
- [The Rust Programming Language: Send and Sync](https://doc.rust-lang.org/book/ch16-04-extensible-concurrency-sync-and-send.html)
- [The Rust Programming Language: Async Fundamentals](https://doc.rust-lang.org/book/ch17-00-async-await.html)
- [The Rust Programming Language: Futures and Async Syntax](https://doc.rust-lang.org/book/ch17-01-futures-and-syntax.html)
- [The Rust Programming Language: Futures, Tasks, and Threads](https://doc.rust-lang.org/book/ch17-06-futures-tasks-threads.html)
- [The Rust Programming Language: Unsafe Rust](https://doc.rust-lang.org/stable/book/ch20-01-unsafe-rust.html)
- [The Rustonomicon: Working with Unsafe](https://doc.rust-lang.org/nomicon/working-with-unsafe.html)
- [Rust API Guidelines: Checklist](https://rust-lang.github.io/api-guidelines/checklist.html)
- [Rust API Guidelines: Naming](https://rust-lang.github.io/api-guidelines/naming.html)
- [Rust API Guidelines: Interoperability](https://rust-lang.github.io/api-guidelines/interoperability.html)
- [Rust API Guidelines: Documentation](https://rust-lang.github.io/api-guidelines/documentation.html)
- [Rust API Guidelines: Predictability](https://rust-lang.github.io/api-guidelines/predictability.html)
- [Rust API Guidelines: Type Safety](https://rust-lang.github.io/api-guidelines/type-safety.html)
- [Rust API Guidelines: Macros](https://rust-lang.github.io/api-guidelines/macros.html)
- [Clippy: Introduction](https://doc.rust-lang.org/stable/clippy/)
- [Clippy: Usage](https://doc.rust-lang.org/stable/clippy/usage.html)
- [Clippy: Lint Categories](https://doc.rust-lang.org/stable/clippy/lints.html)
- [Clippy: Continuous Integration](https://doc.rust-lang.org/clippy/continuous_integration/index.html)
- [Cargo Book: cargo test](https://doc.rust-lang.org/cargo/commands/cargo-test.html)
- [Cargo Book: cargo fmt](https://doc.rust-lang.org/cargo/commands/cargo-fmt.html)
- [Rustfmt repository and CI guidance](https://github.com/rust-lang/rustfmt)
- [Rustfmt stability RFC](https://rust-lang.github.io/rfcs/2437-rustfmt-stability.html)

### Maintainer examples

- [Tokio maintained async example](https://raw.githubusercontent.com/tokio-rs/tokio/master/examples/hello_world.rs)
- [Axum maintained testing example](https://raw.githubusercontent.com/tokio-rs/axum/main/examples/testing/src/main.rs)
- [Rust standard library channel implementation and examples](https://raw.githubusercontent.com/rust-lang/rust/main/library/std/src/sync/mpsc.rs)

### Practitioner talk

- [Niko Matsakis: Guaranteeing Memory Safety and Data-Race Freedom in Rust](https://speakerdeck.com/nikomatsakis/guaranteeing-memory-safety-and-data-race-freedom-in-rust)
