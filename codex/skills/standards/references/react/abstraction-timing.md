# Abstraction timing

- Prefer visible, semantic duplication over an abstraction whose future use cases are unknown. [AHA Programming](https://kentcdodds.com/blog/aha-programming)
- Optimize for change first and let several real uses reveal the stable concept and variation.
- Extract when a repeated behavior has a stable name, owner, inputs, and invariant.
- Keep component APIs narrow; do not add flags and configuration for unrelated consumers.
- Prefer composition and focused custom Hooks over a mega-component with conditional branches for every screen.
- Keep route- or feature-specific components specific until another feature demonstrates the same contract.
- Do not add a state library, adapter, factory, or design-system layer solely to avoid a few repeated lines.
- Do not use Effects, memoization, or indirection to hide a state-ownership or data-flow problem.
- Revisit boundaries after real usage exposes change pressure, testing pain, or duplicated knowledge.
