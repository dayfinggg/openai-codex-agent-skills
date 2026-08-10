# C and C++

Honor the selected C or C++ standard, supported compilers and platforms, warning policy, formatter, analyzer, build system, ABI requirements, and test tools. Prefer the repository's established idioms; do not import modern-language techniques that its compatibility targets cannot support.

Make ownership, lifetime, bounds, and error contracts explicit. In C++, use RAII, value semantics, standard containers, smart pointers for ownership, and narrow interfaces. In C, centralize cleanup paths, validate sizes and conversions, and pair every allocation or acquisition with an unambiguous owner and release.

Avoid undefined behavior, unchecked arithmetic and narrowing, raw owning pointers, unsafe string operations, data races, and manual resource management when a safer facility exists. Keep concurrency synchronization and memory ordering justified and reviewable.

Avoid a Singleton when it obscures ownership or distributes access to mutable global state. Treat mutable namespace or program-wide state as a deliberate exception with explicit ownership and access rationale. Do not rely on cross-translation-unit static initialization order for dependent C++ objects. Do not treat immutable program-wide constants as equivalent to mutable globals.

Limit conditional compilation in retained production code when it obscures behavior or creates unmanaged source-level program variants. Reserve a preprocessing seam for a pervasive dependency only when a clearer interface, wrapper, link, or runtime seam is unavailable. Keep the rationale for a version-sensitive C++ guideline available when repository policy requires it, and recheck the current guideline and target standard before enforcing it.

Use warnings, sanitizers, static analysis, fuzzing, and platform builds according to risk. Evaluate ABI and binary compatibility before changing exported layouts, symbols, calling conventions, or templates.

Primary references: [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines) and [SEI CERT C](https://wiki.sei.cmu.edu/confluence/display/c/SEI+CERT+C+Coding+Standard).
