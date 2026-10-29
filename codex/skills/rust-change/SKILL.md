---
name: rust-change
description: "Change Rust crates or services with ownership, error, feature, target, and async-boundary verification. Use for Rust implementation, refactoring, or runtime defects."
---

Verify Rust changes against the crate's real configuration and consumers.

1. Establish toolchain, edition, MSRV, workspace members, targets, and features from project and CI configuration. Do not use APIs newer than the MSRV without an authorized upgrade.
2. Find the public contract, ownership, and error boundary. Do not resolve a borrow-checking failure through large clones or an architectural rewrite without understanding lifetimes.
3. For async code, identify the runtime, task owner, cancellation, and held resources. Inspect guards and blocking work across await boundaries. Ending a wait does not always cancel a side effect.
4. For unsafe or FFI code, establish the invariant callers must uphold and how it is checked. Minimize the unsafe region and prefer an existing safe interface.
5. Check errors and panic on external input. Do not replace expected failure handling with unwrap or expect for convenience. Preserve public trait bounds and Send/Sync semantics.
6. Run formatting, appropriate Clippy checks, cargo check, a real build, and relevant tests for material configurations. Use all-features only when those features can coexist.
7. For library API changes, check consumers and documentation tests. Use Miri or sanitizers only when the risk and supported environment justify them.

Cargo check does not perform all code generation and does not replace builds or tests. State the tested targets and features when the distinction affects confidence.

Consult [Cargo Check](https://doc.rust-lang.org/cargo/commands/cargo-check.html), [Cargo Features](https://doc.rust-lang.org/cargo/reference/features.html), and the selected async runtime's documentation.

