# Counterexamples

- Duplicate test setup can make each scenario self-contained and easier to understand.
- Separate transport, domain, cache, and persistence representations can be correct when their contracts or lifecycles differ.
- A component or handler can contain trivial local state; move logic when coupling or test difficulty appears, not because a slogan demands a new file.
- A large cohesive module can be better than many shallow modules that leak the same decisions.
- A general abstraction can be correct when current requirements already need several implementations; YAGNI does not forbid necessary design.
- A measured optimization can justify less obvious code, but the benchmark and constraint must remain visible.
- Full test coverage is not the same as useful confidence; prioritize behavior and risk.
