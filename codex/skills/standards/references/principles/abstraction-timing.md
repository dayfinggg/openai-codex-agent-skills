# Abstraction timing

- Start with the smallest concrete design that exposes the real requirement.
- Let multiple real uses reveal what is invariant, what varies, and what callers need.
- Treat duplication as a signal to investigate, not an automatic command to extract.
- A useful abstraction has a precise name, a coherent responsibility, a stable contract, and a cost justified by current callers.
- A speculative abstraction predicts future variation before the domain supplies evidence.
- Warning signs include flags, mode parameters, caller-specific branches, unused options, and names that need long explanations.
- If callers need incompatible behavior, split or inline the abstraction, remove irrelevant branches, and then extract any common concept that remains.
- Sandi Metz's [The Wrong Abstraction](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction) argues that temporary duplication is cheaper than preserving a condition-heavy abstraction that no longer represents one concept.
- Kent Beck's [Canon TDD](https://newsletter.kentbeck.com/p/canon-tdd) calls duplication a hint rather than a command and places implementation refactoring after a passing behavior.
- Design a boundary early when current requirements already have multiple implementations, a costly migration, or a safety and compatibility constraint.
- Do not create an abstract core or pluggable component framework until multiple real implementations reveal a stable shared contract and the substitution benefit exceeds the registration, lifecycle, and debugging cost.
