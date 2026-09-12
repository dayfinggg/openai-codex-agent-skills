# Unsafe boundaries

Use unsafe only for a demonstrated need such as FFI, hardware access, layout control, or a measured optimization.
Keep each unsafe block as small as possible and surround it with ordinary safe code that establishes its preconditions.
`unsafe` enables a small set of operations; it does not disable all borrow checking or make an invalid operation sound.
Establish the safety contract of unsafe APIs and implementations: pointer validity, alignment, initialization, aliasing, lifetime, thread-safety, and ownership. A safe wrapper must enforce its unsafe preconditions without imposing unchecked obligations on safe callers.
When API documentation is requested, put caller obligations for unsafe APIs in a `Safety` section. Otherwise preserve the proof through design, review evidence, and focused checks without adding unsolicited source commentary.
Validate inputs before unchecked operations and keep the validation adjacent to the unsafe use.
Prefer a safe abstraction that owns the invariant instead of exporting raw pointers or repeating unsafe reasoning at call sites.
Audit unsafe code as a boundary, not as an isolated expression, because safe code can establish or invalidate its assumptions.
Keep FFI translation types explicit and convert external ownership and error conventions immediately at the boundary.
Use safe tests for the wrapper's behavior and targeted tools or reviews for the unsafe invariant itself.
Implement `Send` or `Sync` manually only after establishing the required concurrency guarantees. Tests alone are not a proof of soundness.
