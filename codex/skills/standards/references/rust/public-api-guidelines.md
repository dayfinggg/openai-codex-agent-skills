# Public API guidelines

Follow Rust casing: types and traits use `UpperCamelCase`, while functions, methods, and modules use `snake_case`.
Use `new` for the primary constructor and `with_*` for meaningful construction alternatives.
Name getters after the value, such as `path`, and reserve `get` for an unambiguous getter or a checked lookup convention.
Use `as_` for a cheap borrowed view, `to_` for a potentially costly same-level conversion, and `into_` for ownership transfer.
Name collection iterators `iter`, `iter_mut`, and `into_iter`, with matching iterator type names.
Prefer meaningful enums, structs, and newtypes over several positional booleans or overloaded primitive arguments.
Use a builder when a value has optional configuration, compound inputs, or side-effecting construction.
Validate arguments at the narrowest boundary that can report a useful error.
Document side effects, allocation behavior, blocking, ordering, panic conditions, and thread-safety when they matter to callers.
When a public item's usage or failure contract is not clear from its signature, tests, and nearby examples, provide a focused rustdoc example or direct link; make fallible examples use `?`.
Make examples compile as documentation tests and keep them free of accidental `unwrap` calls.
Avoid inherent methods on smart pointers when the method belongs semantically to the pointee.
Treat every public signature, re-export, trait implementation, and error variant as a compatibility commitment.
