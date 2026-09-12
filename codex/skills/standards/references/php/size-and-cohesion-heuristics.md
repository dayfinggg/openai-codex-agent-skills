# Size and cohesion heuristics

- Treat size numbers as review signals, not universal laws; generated code, protocol adapters, and framework entry points may be exceptions.
- A method that needs many branches, setup steps, or prose to remain understandable is a candidate for extraction around a named concept.
- Use the project's configured PHPMD thresholds for size, parameter count, public surface, and weighted complexity. Defaults vary by rule and version and do not prove a design defect.
- Change thresholds only with project evidence and an agreed remediation path, not to enforce an arbitrary preference.
- A cohesive class keeps methods around the same state, invariant, or use case.
- If methods form separate groups with different collaborators or reasons to change, split the class or introduce a collaborator.
- Measure coupling and lack of cohesion over time; PhpMetrics exposes efferent coupling, complexity, class length, and LCOM metrics.
- A small class with one cohesive responsibility is better than several anemic classes created only to satisfy a line count.
- Refactor when a change routinely touches unrelated methods, requires many mocks, or exposes data that another object should own.
