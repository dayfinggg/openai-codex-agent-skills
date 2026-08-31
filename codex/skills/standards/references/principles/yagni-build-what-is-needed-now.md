# YAGNI: build what is needed now

- Do not implement an imagined feature, extension point, option, or abstraction before a real requirement calls for it.
- State the current requirement and the evidence that the extra capability is needed now.
- Future-proofing that adds no complexity is different from speculative behavior that complicates today's path.
- Tests, refactoring, observability, and reversible boundaries make later change safer; they are not future features.
- Security, compatibility, migration, durability, and accessibility work is current scope when the contract requires it.
- Revisit a deferred capability when a real caller, cost threshold, or irreversible decision makes it current.
- Fowler's [YAGNI](https://martinfowler.com/bliki/Yagni.html) defers presumptive features and future-flexibility abstractions that add present complexity.
