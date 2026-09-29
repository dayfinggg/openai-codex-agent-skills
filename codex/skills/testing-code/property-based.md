# Property-based tests

A property-based test states a rule that holds for every valid input and lets a library generate inputs and shrink a failure to the smallest counterexample. Use Hypothesis in Python and fast-check in TypeScript and JavaScript. If the project has no such library, adding one is a dependency the user decides on, so offer it with the property you would test.

## When it fits

Write one when the code has a rule you can state without recomputing the answer:

| Property | Rule | Typical code |
|---|---|---|
| Round trip | `parse(format(x)) == x` | Serializers, encoders, converters, URL and date formatting |
| Idempotence | `f(f(x)) == f(x)` | Normalizers, slug builders, formatters, deduplication |
| Invariant | A condition holds before and after | Totals stay equal after a transfer, a sorted list keeps its length and elements |
| Oracle | `fast(x) == simple(x)` | An optimized or rewritten function against a slow, obviously correct version |
| Easy to check | `is_sorted(sort(x))` | Results that are hard to compute but cheap to verify |

Prefer the strongest property the code supports. "Does not crash" is the weakest and rarely worth a new dependency. Code without such a rule, such as a plain CRUD handler, gets example tests. When the rule is hidden behind I/O, pull the pure calculation into its own function first.

## Two ways a property proves nothing

- A property that repeats the implementation, such as `add(a, b) == a + b`, passes for every bug the two share. Check a consequence of the result instead of computing it again.
- A filter that throws away most generated inputs, such as `assume(x > 0)` on all integers, runs few or no real cases. Build valid inputs directly in the generator, for example `st.integers(min_value=1)` or `fc.integer({ min: 1 })`, and derive dependent values from earlier ones inside a composite generator.

## Making them reliable

- Pin the edge cases you already know with explicit examples: empty, one element, all equal, zero, negative and the largest value, via `@example(...)` in Hypothesis or `examples` in fast-check.
- Turn off the per-example deadline for code that does real work, so a slow machine does not produce a flaky failure.
- When a property fails, read the shrunk counterexample first. Decide whether the code or the stated property is wrong, and add the counterexample as a fixed example once it is fixed.
