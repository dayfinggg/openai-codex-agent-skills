# Strict, explicit types

- Start every PHP source file with `declare(strict_types=1);` unless an identified interoperability boundary requires otherwise.
- Strict typing is file-scoped and affects calls made from the strict caller, so migrate callers as well as declarations.
- Strict typing applies to scalar declarations; it does not make every PHP operation statically safe.
- Type every parameter, return value, property, promoted constructor parameter, and public constant where the language permits it.
- Prefer the narrowest useful native type: a domain class or interface is clearer than `array` or `object`.
- Use `?T`, unions, intersections, `void`, `never`, and enums when they describe the real contract.
- Use `false` and `true` types only when the API genuinely returns those sentinel values.
- Avoid `mixed`; confine it to an unavoidable boundary and normalize the value immediately.
- Model a stable record as a value object, DTO, or enum instead of an unbounded associative array.
- When an array is the right structure and native PHP cannot express its key, value, list, or array shape, use PHPDoc only where the public contract or static analyzer needs that information.
- Use analyzer-specific generics or type aliases only where they add information that native PHP cannot express.
- Treat a PHPDoc assertion as a proof obligation; never use `@var` to silence an error without checking the value.
- Psalm notes that an explicit `@var` can override inferred types and weaken checking, so prefer a runtime guard or a better signature.
- Keep input validation at the boundary and pass normalized domain values inward.
- Use `===` and `!==` by default; make any intentional coercion visible at the boundary.
- Return one documented result shape; avoid APIs that mix a value, `false`, `null`, and exceptions without a reason.
