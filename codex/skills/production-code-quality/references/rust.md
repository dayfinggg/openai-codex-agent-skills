# Rust

Honor the crate's minimum supported Rust version, edition, feature flags, workspace policy, `rustfmt.toml` or `.rustfmt.toml`, Clippy configuration, Cargo aliases, and test tools. Run the repository command first. Otherwise check the selected workspace with `cargo fmt --all -- --check`, narrowing only when the installed tool and task scope support it. Do not pass ad hoc formatter flags that override repository configuration.

When no formatter configuration exists, the default Rust style is four-space indentation, spaces rather than tabs, and a 100-character maximum line width. Treat `rustfmt` output as the mechanical gate. If compatible `rustfmt` is unavailable, apply those defaults directly and record that the formatter gate was unavailable. Use [code shape and naming](code-shape-and-naming.md) unchanged for function, type, file, nesting, complexity, and parameter thresholds.

Use `snake_case` for variables, functions, methods, fields, modules, and ordinary module filenames, `UpperCamelCase` for types, traits, and enum variants, and `SCREAMING_SNAKE_CASE` for constants and immutable statics. Prefer a raw identifier or trailing underscore for a reserved word rather than a misspelling. Preserve Cargo target names and module resolution. Use `snake_case.rs` for modules, the edition-appropriate `foo.rs` plus `foo/` layout rather than adding `mod.rs` without precedent, and the Cargo convention of kebab-case for binaries, examples, benchmarks, and integration-test targets when compatibility permits.

Use ownership and borrowing to make lifetimes and mutation explicit. Prefer expressive domain types, enums, newtypes, iterators, and exhaustive matching over sentinel values and invalid states.

Use `Result` for recoverable failures and `Option` for absence. Preserve error sources and choose library or application error types according to callers' needs. Avoid `unwrap` and `expect` in retained production paths unless an invariant makes failure impossible and the project permits it.

Keep `unsafe` minimal, isolated behind a safe abstraction, and validated for every required invariant. Make concurrency and asynchronous cancellation behavior explicit; require `Send` and `Sync` only where the design needs them. Minimize public API and feature interactions, and evaluate SemVer effects before changing exported types or traits.

Primary references: [The Rust Book](https://doc.rust-lang.org/book/), [Rust Style Guide](https://doc.rust-lang.org/style-guide/), [Rust Reference modules](https://doc.rust-lang.org/reference/items/modules.html), [Cargo project layout](https://doc.rust-lang.org/cargo/guide/project-layout.html), [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/), and [Cargo SemVer compatibility](https://doc.rust-lang.org/cargo/reference/semver.html).
