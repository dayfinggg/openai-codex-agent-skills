# Ownership-driven design

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
Make whether a method borrows, mutates, consumes, caches, or invalidates its receiver visible through the signature and tests; use public API documentation only when those forms cannot express the contract.
