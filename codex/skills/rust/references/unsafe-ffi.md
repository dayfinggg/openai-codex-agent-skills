# Unsafe Rust, FFI and Miri

Verify current language rules in the [Rust Reference](https://doc.rust-lang.org/reference/unsafe-keyword.html) and the [Rust 2024 Edition Guide](https://doc.rust-lang.org/edition-guide/rust-2024/unsafe-extern.html).

Rules for `unsafe` code and foreign function interfaces on Rust 1.100 and edition 2024.

## Edition 2024 syntax

- Write `unsafe extern "C" { .. }` and `#[unsafe(no_mangle)]`, `#[unsafe(export_name = "..")]`, `#[unsafe(link_section = "..")]`. Inside `unsafe extern`, declare `pub safe fn` for items that are sound to call without `unsafe`.
- `std::env::set_var` and `remove_var` are `unsafe` in edition 2024. Call them only before any other thread starts. The `unsafe {}` wrapper that `cargo fix` inserts does not make the call sound.
- Define C-variadic functions as `unsafe extern "C" fn f(mut args: ...)` (1.99).

## Statics and pointers

- A reference to a `static mut`, written as `&X` or created implicitly by a method call or `println!`, is a deny-by-default error in edition 2024 and is undefined behavior when it aliases, even unused. Use atomics, `Mutex`, `LazyLock`, `OnceLock`, or pass `&raw mut STATIC` to FFI.
- `slice::from_raw_parts` and `from_raw_parts_mut` need a non-null, aligned pointer even for a zero-length slice. C code often passes `(NULL, 0)` for an empty buffer, so check for null first and use `NonNull::dangling()` or `ptr::dangling()` (1.84) instead.
- Do not free memory from `Box::leak` by rebuilding a `Box` from the leaked reference (discouraged since 1.99). Use `Box::into_raw` or `Box::into_non_null`, then `Box::from_raw` or `Box::from_non_null`.
- Create a zero-sized value with `unsafe { std::mem::conjure_zst::<T>() }` (1.100), not by transmuting `()` or `MaybeUninit::uninit().assume_init()`. `T` must be inhabited, and the call panics if `T` is not zero-sized.
- Matching a union field together with other values in one pattern can read the union before the tag is checked, which is undefined behavior. The Rust Reference stopped recommending that pattern in 1.99. Match the tag first, then read the field.

## Panics across FFI

- A panic escaping an `extern "C"` function aborts the process (1.81). Use `extern "C-unwind"` when unwinding must cross the boundary.

## Miri

- When the project already has the nightly toolchain and Miri component, run unsafe code with `cargo +nightly miri test`. If they are missing, do not install a toolchain or component unless the task scope and dependency policy allow it. On Windows add `--target x86_64-unknown-linux-gnu`.
- Miri has no FFI or networking, so mark such tests `#[cfg_attr(miri, ignore)]`. Vary addresses and thread schedules with `MIRIFLAGS="-Zmiri-many-seeds=0..16"`.
- A Miri pass covers only the executions it tried. A `// SAFETY:` comment must argue the invariant rather than cite Miri, fuzzing or sanitizers.
