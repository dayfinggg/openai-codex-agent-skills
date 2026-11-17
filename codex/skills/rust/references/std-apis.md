# Std APIs and the crates they replace

Use an item only when `rust-version` is at least the listed version. The list starts at 1.85, the edition 2024 baseline.

## Crates and idioms that std replaces

| Instead of | Use | Since |
|---|---|---|
| `once_cell`, `lazy_static` | `std::sync::LazyLock`, `OnceLock`, `std::cell::LazyCell` | 1.80 |
| `cfg-if` | `cfg_select! { unix => { .. } _ => { .. } }`, also in expression position | 1.95 |
| `scopeguard` | `std::mem::DropGuard::new(value, closure)`, cancel with `DropGuard::dismiss(guard)` | 1.100 |
| `itoa` | `let mut buf = NumBuffer::new();` then `n.format_into(&mut buf)` | 1.98 as `core::fmt`, 1.99 as `std::fmt` |
| `fs2`, `fs4` file locks | `File::lock`, `try_lock`, `lock_shared`, `unlock` (unsupported on Solaris since 1.98) | 1.89 |
| `filetime` | `std::fs::set_times`, `set_times_nofollow` | 1.99 |
| `os_pipe` | `std::io::pipe` | 1.87 |
| `home`, `dirs` for the home directory | `std::env::home_dir`, no longer deprecated | 1.87 |
| `allocator-api2` for `Vec` and `Box` | `std::alloc::Allocator`, `Vec::new_in`, `Box::new_in` | 1.100 |
| `assert!(matches!(..))` | `use std::assert_matches;` then `assert_matches!(v, pat)` | 1.96 |
| `as_any()` methods for downcasting | `trait Foo: Any`, then upcast `&dyn Foo` to `&dyn Any` | 1.86 |
| `Captures<..>` or `+ 'a` tricks on `impl Trait` | `+ use<'a, T>`, or no bound in edition 2024 | 1.82 |
| closures returning `async move {}` | `async` closures with `impl AsyncFn(X) -> T` bounds | 1.85 |
| `addr_of!`, `addr_of_mut!` | `&raw const x`, `&raw mut x` | 1.82 |
| `(0..n).map(f).collect::<Vec<_>>()` | `Vec::from_fn(n, f)` | 1.100 |
| `s.strip_prefix(p).unwrap_or(s)` | `s.trim_prefix(p)`, `trim_suffix` | 1.100 |

## Stabilized by version

- 1.100: `bool::toggle`, `Box::take`, `Box::map`, `Rc::map`, `Arc::map`, `str` and `[T]::trim_prefix` and `trim_suffix`, `Path::trim_prefix`, `UnsafeCell::replace`, `as_ref_unchecked`, `as_mut_unchecked`, `Default for Once`, `impl PartialEq<Cow<[U]>>` for `Vec` and slices, `core::mem::conjure_zst`, the `Allocator` API with `Box::new_in`, `Vec::new_in`, `Vec::with_capacity_in` and friends, `os::windows::process::CommandExt::show_window`.
- 1.99: `Box::into_non_null`, `Box::from_non_null`, `Vec::into_parts`, `Vec::from_parts`, `String::from_utf8_lossy_owned`, `FromUtf8Error::into_utf8_lossy`, `LocalKey<Cell<T>>::update`, `VecDeque::retain_back`, `IntoIterator` for `Box<[T; N]>`, `core::ffi::VaList`, `mem::size_of_val_raw`, `mem::align_of_val_raw`, `Layout::for_value_raw`, C-variadic function definitions `unsafe extern "C" fn f(mut args: ...)`.
- 1.98: `str::substr_range`, `[T]::subslice_range`, `str` and `[T]::strip_circumfix`, `bool::ok_or`, `bool::ok_or_else`, `Option::map_or_default`, `Result::map_or_default`, `String::from_utf16le`, `from_utf16be` and their `_lossy` forms, `Box::as_ptr`, `Box::as_mut_ptr`, `Path::is_empty`, `PathBuf::into_string`, `Atomic<T>::from_mut`, `NonZero::from_str_radix`, `{f32,f64}::algebraic_add` and siblings (reorderable, results may differ between builds). `{core,std}::derive` counts as 1.96.
- 1.97: `{integer}::bit_width`, `highest_one`, `lowest_one`, `isolate_highest_one`, `isolate_lowest_one`, also on `NonZero`.
- 1.96: `assert_matches!`, `debug_assert_matches!`, `core::range::Range`, `RangeFrom`, `RangeToInclusive`, `From<T>` for `LazyLock` and `LazyCell`, iteration over `NonZero` ranges.
- 1.95: `Vec::push_mut`, `Vec::insert_mut`, `VecDeque::push_front_mut`, `push_back_mut`, `AtomicBool::update`, `try_update` and the same on integer atomics and `AtomicPtr`, `core::hint::cold_path`, `core::range::RangeInclusive`, `cfg_select!`, `bool: TryFrom<{integer}>`, `Layout::repeat`.
- 1.94: `[T]::array_windows`, `[T]::element_offset`, `LazyLock::get`, `get_mut`, `force_mut` and the same on `LazyCell`, `Peekable::next_if_map`, `f64::consts::GOLDEN_RATIO`, `EULER_GAMMA`.
- 1.93: `fmt::from_fn`, `[T]::as_array`, `as_mut_array`, `VecDeque::pop_front_if`, `pop_back_if`, `Vec::into_raw_parts`, `String::into_raw_parts`, `Duration::from_nanos_u128`, `char::MAX_LEN_UTF8`, `[MaybeUninit<T>]::assume_init_ref`, `write_copy_of_slice`.
- 1.92: `RwLockWriteGuard::downgrade`, `Box::new_zeroed`, `Arc::new_zeroed`, `btree_map::Entry::insert_entry`, `NonZero::div_ceil`.
- 1.91: `{integer}::strict_add`, `strict_sub`, `strict_mul` and siblings (panic on overflow in release builds too), `Duration::from_mins`, `from_hours`, `PathBuf::add_extension`, `with_added_extension`, `Path::file_prefix`, `str::floor_char_boundary`, `ceil_char_boundary`, `BTreeMap::extract_if`, `BTreeSet::extract_if`, `core::array::repeat`, `core::iter::chain`, `Ipv4Addr::from_octets`, `PartialEq<str>` for `Path`.
- 1.90: `u{n}::checked_sub_signed`, `saturating_sub_signed`, `wrapping_sub_signed`, comparisons between `CStr`, `CString` and `Cow<CStr>`.
- 1.89: `Result::flatten`, `NonNull::from_ref`, `NonNull::from_mut`, `OsString::leak`, `PathBuf::leak`, `File::lock` and siblings, `#[repr(u128)]`.
- 1.88: `HashMap::extract_if`, `HashSet::extract_if`, `Cell::update`, `[T]::as_chunks`, `as_rchunks`, `hint::select_unpredictable`, `#[unsafe(naked)]` functions, `cfg(true)` and `cfg(false)`.
- 1.87: `Vec::extract_if`, `[T]::split_off`, `split_off_first`, `split_off_last`, `String::extend_from_within`, `OsStr::display`, `{uN}::is_multiple_of`, `cast_signed`, `cast_unsigned`, `unbounded_shl`, `TryFrom<Vec<u8>>` for `String`, `str::from_utf8` as an inherent function, `io::pipe`.
- 1.86: `[T]::get_disjoint_mut`, `HashMap::get_disjoint_mut`, `Vec::pop_if`, `Once::wait`, `OnceLock::wait`, `f64::next_up`, `next_down`, `#[target_feature]` on safe functions, trait upcasting.
- 1.85: `FromIterator` and `Extend` for tuples up to 12 elements, `Waker::noop`, `ptr::fn_addr_eq`, unsigned and float `midpoint`, `#[diagnostic::do_not_recommend]`, async closures.
