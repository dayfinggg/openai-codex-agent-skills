# Avoiding utility and abstraction excess

- Keep semantic component classes as the primary styling contract when they make the UI easier to read and change.
- Use utilities for genuinely repeated single-purpose rules or layout primitives, not as a class for every declaration.
- Do not encode page meaning in a pile of presentational classes that obscures the component's structure and state.
- Do not add a wrapper, variant, token, mixin, utility, or design-system layer without a current use and a clear owner.
- Prefer a small amount of visible repetition over a generic abstraction with flags, hidden coupling, or unused extension points.
- Reuse stable knowledge, not coincidental selector shapes; split abstractions when callers need incompatible behavior.
- Delete unused CSS, markup, dependencies, and hooks instead of preserving them for hypothetical future screens.
- Record exceptions when compatibility, browser behavior, or measured performance justifies a less obvious rule.
