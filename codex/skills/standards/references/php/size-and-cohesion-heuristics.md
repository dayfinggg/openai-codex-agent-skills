# Size and cohesion heuristics

- Treat size numbers as review signals, not universal laws; generated code, protocol adapters, and framework entry points may be exceptions.
- A method that needs many branches, setup steps, or prose to remain understandable is a candidate for extraction around a named concept.
- PHPMD's defaults flag methods over 100 lines, classes over 1,000 lines, ten or more parameters, fifteen or more fields, twenty-five or more methods, and ten or more public methods.
- PHPMD also uses weighted method count 50 as a class-complexity threshold and describes excessive public surface as harder to test.
- Prefer stricter team triggers when the codebase permits them, but change thresholds only with examples and an agreed remediation path.
- A cohesive class keeps methods around the same state, invariant, or use case.
- If methods form separate groups with different collaborators or reasons to change, split the class or introduce a collaborator.
- Measure coupling and lack of cohesion over time; PhpMetrics exposes efferent coupling, complexity, class length, and LCOM metrics.
- A small class with one cohesive responsibility is better than several anemic classes created only to satisfy a line count.
- Refactor when a change routinely touches unrelated methods, requires many mocks, or exposes data that another object should own.
