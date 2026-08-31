# Idiomatic Rust

Use exhaustive `match` and deliberate enums when a value has a closed set of states.
Use `Option<T>` for absence and `Result<T, E>` for an operation that can fail.
Use `?` to propagate errors and add context at a boundary where the operation is understood.
Prefer iterator adapters when they make the transformation clearer, but use a loop when control flow is clearer.
Avoid needless allocation, cloning, conversion, and collection of intermediate values.
Treat every `clone` as an explicit cost and make its ownership reason clear through types and structure. Keep a source note only when the non-obvious constraint cannot be expressed in code and must be preserved for a maintainer.
Accept slices such as `&str` and `&[T]` when a function does not need ownership or vector-specific behavior.
Return an owned value when the result must outlive an input borrow or cross an ownership boundary.
Derive common traits when their semantics are correct, rather than implementing boilerplate manually.
Use `Default` only when a meaningful default exists and document non-obvious defaults.
Use `#[must_use]` for values whose omission would usually be a bug, such as a builder or a fallible result.
Keep unsafe-looking behavior out of safe APIs unless the safe wrapper enforces its complete invariant.
