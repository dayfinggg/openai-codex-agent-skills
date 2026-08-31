# Traits and generics

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
