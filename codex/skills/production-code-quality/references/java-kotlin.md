# Java and Kotlin

Honor the configured JDK, Kotlin, Android or server target, build tool, formatter, static analyzers, nullability model, and test framework. Follow repository naming first; otherwise use the established [Java style](https://google.github.io/styleguide/javaguide.html) or [Kotlin conventions](https://kotlinlang.org/docs/coding-conventions.html) appropriate to the language.

In retained Java code, do not introduce raw generic types. Eliminate unchecked warnings or isolate an unavoidable legacy operation behind the narrowest safe boundary and verify its type invariant. Use generic types and methods when an API must operate safely over multiple element types. Use bounded wildcards only when they safely increase API flexibility, and combine generics with varargs only after eliminating or containing heap-pollution risk. Use a type-safe heterogeneous container only for a concrete API need.

Model required states with types, keep visibility narrow, favor immutable values, and use records, sealed hierarchies, data classes, or value classes when they express the domain. Prefer composition when inheritance would expose implementation or create an unsupported subclass contract. Use inheritance only when substitutability and the extension contract are intentional and supportable.

Validate method parameters at the boundary that owns the contract. Return an empty collection or array instead of `null` when the API contract represents an empty result. Handle, translate, or propagate exceptions according to caller recovery, preserve causes, and never leave an empty catch block. Use `try`-with-resources for applicable Java `AutoCloseable` resources. Synchronize access to shared mutable Java data when required and state the thread-safety contract where repository policy requires it.

For Kotlin coroutines, preserve structured concurrency and cancellation, and do not hide blocking work in asynchronous code. Keep transaction and resource boundaries explicit through language facilities.

Do not impose one declaration per file on Kotlin or several declarations per file on Java without considering their distinct conventions. Evaluate source, binary, and behavioral compatibility for published libraries.

Primary references: [Java Language Specification](https://docs.oracle.com/javase/specs/), [Dev.java generics](https://dev.java/learn/generics/), [Java `AutoCloseable`](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/lang/AutoCloseable.html), and [Kotlin documentation](https://kotlinlang.org/docs/home.html).
