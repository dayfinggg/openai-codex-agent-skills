# Data and mutation

- Decide who owns each object, array, stream, timer, and resource before deciding whether to mutate it.
- Mutate data owned by the current operation when that keeps the algorithm clear. Do not mutate caller-owned inputs unless the API documents it.
- Return a new array or object when callers may retain the previous value or when change detection depends on identity.
- Remember that object and array spreads make shallow copies. Nested objects and functions remain shared references.
- `Object.freeze` freezes the object passed to it, returns that same object, and is shallow. It is not a deep-clone or a general immutability policy. [J9]
- Use `structuredClone` only when a genuine deep copy is required and its supported value types and cost are acceptable. [J10]
- Do not deep-clone every state update. Prefer a targeted copy-on-write update or an owned mutable accumulator.
- Use `Map` and `Set` when key identity or membership is the domain operation. Avoid unbounded property bags for untrusted keys.
- Distinguish own properties from inherited properties. Prefer `Object.keys`, `Object.entries`, or `Object.hasOwn()` when processing record-like objects, and use `for...in` only when inherited enumerable properties are intentional. [J33]
- Treat an iterator as stateful and potentially single-use. Materialize it only when repeated traversal, indexing, or random access is genuinely required. [J34]
- Iterate a string by code point with `for...of` or spread when UTF-16 code units are not the intended unit. Use `Intl.Segmenter` when the user-perceived grapheme, word, or sentence is the real unit. [J35]
- Keep `null`, `undefined`, omission, and an empty value distinct when the public contract distinguishes them.
- Normalize external data once at the boundary, then keep internal representations stable.
- Avoid retaining large request bodies, closures, listeners, or caches longer than their ownership and lifetime require.
- Remember that a closure retains access to its lexical environment. Remove long-lived listeners and callbacks, and avoid capturing large objects when only a small stable value is needed. [J36]
