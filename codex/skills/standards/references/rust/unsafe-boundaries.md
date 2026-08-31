# Unsafe boundaries

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
