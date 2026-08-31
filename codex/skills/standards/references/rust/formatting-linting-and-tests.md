# Formatting, linting, and tests

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
