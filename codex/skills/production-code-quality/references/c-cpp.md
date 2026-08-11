# C and C++

Honor the selected C or C++ standard, supported compilers and platforms, warning policy, the closest `.clang-format` or `_clang-format`, analyzer configuration, build system, ABI requirements, and test tools. Run the repository formatter target first. When ClangFormat is configured, check changed files with `clang-format --dry-run --Werror --style=file --fallback-style=none path/to/file.cpp`. Pin or use the repository's ClangFormat version because option support and output can change. Do not let its built-in LLVM fallback silently choose project style.

ISO C and C++ define no universal indentation, width, or identifier morphology. When repository policy and formatter configuration are both absent, use this skill's local fallback only for new or materially reshaped code: four-space indentation, spaces rather than tabs, and the line-width row in [code shape and naming](code-shape-and-naming.md). Use that reference unchanged for function, type, file, nesting, complexity, and parameter thresholds.

Preserve neighboring and public naming before the local fallback. If none exists, use `lower_snake_case` for C functions, variables, and typedef names, `UPPER_SNAKE_CASE` for C macros and constants, `UpperCamelCase` for C++ types, `lower_snake_case` for C++ functions and variables, and `UPPER_SNAKE_CASE` only for macros. These choices are a coherent local policy, not ISO or C++ Core Guidelines rules. Use lowercase `snake_case` filenames, keep a header and implementation stem aligned, and retain the extension set, generated headers, platform suffixes, include paths, and module filenames already recognized by the build.

Make ownership, lifetime, bounds, and error contracts explicit. In C++, use RAII, value semantics, standard containers, smart pointers for ownership, and narrow interfaces. In C, centralize cleanup paths, validate sizes and conversions, and pair every allocation or acquisition with an unambiguous owner and release.

Avoid undefined behavior, unchecked arithmetic and narrowing, raw owning pointers, unsafe string operations, data races, and manual resource management when a safer facility exists. Keep concurrency synchronization and memory ordering justified and reviewable.

Avoid a Singleton when it obscures ownership or distributes access to mutable global state. Treat mutable namespace or program-wide state as a deliberate exception with explicit ownership and access rationale. Do not rely on cross-translation-unit static initialization order for dependent C++ objects. Do not treat immutable program-wide constants as equivalent to mutable globals.

Limit conditional compilation in retained production code when it obscures behavior or creates unmanaged source-level program variants. Reserve a preprocessing seam for a pervasive dependency only when a clearer interface, wrapper, link, or runtime seam is unavailable. Keep the rationale for a version-sensitive C++ guideline available when repository policy requires it, and recheck the current guideline and target standard before enforcing it.

Use warnings, sanitizers, static analysis, fuzzing, and platform builds according to risk. Evaluate ABI and binary compatibility before changing exported layouts, symbols, calling conventions, or templates.

Primary references: [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines), [SEI CERT C](https://wiki.sei.cmu.edu/confluence/display/c/SEI+CERT+C+Coding+Standard), and [ClangFormat](https://clang.llvm.org/docs/ClangFormat.html).
