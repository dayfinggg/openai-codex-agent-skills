# Inference and boundary annotations

- Fully annotate callable inputs and returns at public and cross-module boundaries, including explicit `-> None` where applicable.
- Let the checker infer obvious local variables instead of repeating types that add no information.
- Annotate a local when inference would otherwise be too broad or unknown, such as an empty collection, a value from an untyped dependency, or a deliberately widened interface type.
- Isolate untyped libraries behind a typed adapter. Prefer maintained stubs when available, and verify that stub versions match the runtime package.
- Do not use an annotation or `cast()` as evidence that external data has the promised runtime shape. Parse or validate the data first.
