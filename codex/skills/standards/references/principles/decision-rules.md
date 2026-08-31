# Decision rules

- If two pieces must change together, seek one source of truth; if they change independently, keep them separate.
- If a second use is almost the same, compare semantics and change reasons before extracting; a third confirming use often supplies better evidence.
- If an abstraction needs a flag or branch for each caller, stop adding parameters and reassess the boundary.
- If a module exposes internal decisions, move those decisions behind the module and simplify the contract.
- If a dependency cycle appears, identify the shared policy or misplaced ownership before adding an import workaround, global registry, or service locator.
- If transport, domain, and persistence models change for different reasons, keep explicit representations and mappings. If they are genuinely the same stable contract, do not duplicate them for ceremony.
- If a split creates pass-through methods or duplicated state, undo the split or move the boundary.
- If a function is hard to test, identify the dependency or responsibility causing the difficulty before merely shortening it.
- If performance is suspected, measure the relevant path, isolate the hotspot, change only that path, and remeasure.
- If an API is hard to call correctly, improve its types, names, result shape, or documentation before adding convenience wrappers.
