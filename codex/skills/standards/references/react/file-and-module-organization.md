# File and module organization

- Keep a file around one cohesive component, Hook, domain policy, adapter, or test concern.
- Split a file when it has multiple independent reasons to change or requires unrelated dependencies.
- Keep a larger file when extraction would create shallow wrappers or scatter one invariant across navigation-heavy fragments.
- Separate UI composition from business rules and I/O when the split makes ownership and tests clearer.
- Keep imports directed from shared primitives to features and from features to screens; avoid cycles and route-to-route knowledge.
- Put a narrow public surface at the module boundary and keep implementation details private.
- Create only folders the project needs now. A maximal directory tree hides ownership and slows discovery.
- Group files by feature or change path when a screen, its state logic, data access, and tests usually change together.
- Keep constants and configuration separate from component render logic when doing so prevents accidental recreation or hidden environment coupling.
- Load heavy modules or data only when a current interaction needs them, and verify that the deferred boundary improves the measured path.
- Avoid barrel files or generic utility folders when they create unclear ownership or broad dependency graphs.
