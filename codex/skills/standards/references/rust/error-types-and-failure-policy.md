# Error types and failure policy

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
When API documentation is explicitly requested, cover relevant error, panic, and safety contracts. Otherwise express and check those invariants through types, control flow, and focused verification without adding prose comments.
Write error names in a consistent order such as `ParseFooError`, matching standard-library vocabulary.
At an application boundary, aggregate or render errors for humans only after the typed cause has done its work.
