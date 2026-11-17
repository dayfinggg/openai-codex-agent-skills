# Migrating to edition 2024

This reference summarizes the [official Rust 2024 Edition Guide](https://doc.rust-lang.org/edition-guide/rust-2024/). Verify compiler and Cargo behavior against the project's installed toolchain.

## Migration

- Edition 2024 needs Rust 1.85. Run `cargo update`, then `cargo fix --edition --all-features`, once per `--target` that has platform `cfg` code. Then set `edition = "2024"`, build, test, and run `cargo fmt`.
- `cargo fix --edition` does not touch code behind inactive `cfg`s, doctests, `macro_rules!` bodies that the crate never invokes, or proc-macro output. Fix those by hand.
- Its rewrites preserve 2021 behavior: `if let` becomes `match`, `impl Trait` gains `use<>`, `$e:expr` becomes `$e:expr_2021`. Review each one and revert it where the 2024 behavior is what you want.

## Language

- `if let` scrutinee temporaries now drop before the `else` branch. A read guard from `lock.read().unwrap()` no longer deadlocks a `write()` in `else`. A `match` keeps temporaries until the end of the statement, as 2021 `if let` did.
- Tail expression temporaries now drop before the block's locals. `c.borrow().len()` as a tail compiles, but `let n = { &String::from("x") }.len();` fails. Bind the block result to a local first. The `tail_expr_drop_order` lint reports affected types with a `Drop` impl and has no automatic fix.
- `-> impl Trait` now captures every in-scope lifetime, so a returned iterator keeps its argument borrowed. Add `+ use<>` or `+ use<T>` to capture less. A parameter written as `impl Trait` in argument position cannot appear in `use<..>`, so turn it into a named generic first.
- Once a pattern has matched through a reference implicitly (match ergonomics), `mut`, `ref` or `ref mut` on a binding and `&` patterns below that point are errors. Write the outer `&` patterns explicitly or drop the modifier.
- The `expr` fragment now also matches `const { .. }` blocks and `_`. A macro with an `$e:expr` arm before a `const` or `_` arm changes meaning. Use `$e:expr_2021` there.
- A macro metavariable without a fragment specifier is a hard error.
- `gen` is a reserved keyword. Write `r#gen` for existing identifiers. Guarded strings like `#"foo"#` and runs of two or more `#` are reserved tokens.
- `unsafe_op_in_unsafe_fn` warns by default. Wrap each unsafe operation inside an `unsafe fn` body in its own `unsafe {}` block.
- `extern` blocks must be written `unsafe extern`, and `no_mangle`, `export_name` and `link_section` must be written `#[unsafe(...)]`. The unsafe and FFI reference listed in `SKILL.md` has the details.
- References to a `static mut` are denied by default (`static_mut_refs`).
- `std::env::set_var` and `remove_var` are `unsafe`.
- The never type fallback change that the edition guide lists for 2024 applies to all editions since Rust 1.100. `SKILL.md` covers the fixes.

## Standard library

- `Future` and `IntoFuture` are in the prelude. A method like `x.poll()` from a crate trait can become ambiguous. Call it as `MyTrait::poll(&mut x)`.
- `boxed_slice.into_iter()` yields `T` by value in 2024 and `&T` before.
- `CommandExt::before_exec` is `unsafe` in 2024 and long deprecated. Use `pre_exec`.

## Cargo

- `[project]`, `default_features`, `crate_type`, `proc_macro`, `dev_dependencies` and `build_dependencies` are rejected. Use `[package]` and the dashed names.

## Rustdoc

- Doctests are compiled into one binary and each still runs in its own process. Doctests marked `compile_fail` or `edition`, with crate attributes, `#[global_allocator]` or `$crate` macros stay separate automatically. Tag any other doctest that depends on line numbers or compilation layout with `standalone_crate`.
- In docs pulled in with `#[doc = include_str!("../README.md")]`, `include!`, `include_str!` and `include_bytes!` paths inside doctests resolve relative to the Markdown file.

## Rustfmt

- `cargo fmt` uses the manifest edition, but editors that run `rustfmt` directly default to the 2015 style. Add `style_edition = "2024"` to `rustfmt.toml` so both agree.
- Style 2024 sorts imports by version order (`NonZeroU8` before `NonZeroU16`) and puts names like `Read` and `Write` before `stdout`, so the first `cargo fmt` reorders many `use` lines.
