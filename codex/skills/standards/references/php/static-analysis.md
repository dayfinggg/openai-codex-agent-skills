# Static analysis

- Reuse the project's PHPStan or Psalm setup. Add an analyzer only when the task calls for it, choosing a version compatible with tooling execution and the supported source PHP range. Do not add a second analyzer without a concrete unmet need.
- Analyze `src/` and relevant tests; do not analyze `vendor/` as if the project could fix third-party code.
- Start at a level the codebase can sustain, remove errors, and raise the level in controlled increments.
- PHPStan levels are cumulative; select from the installed release's documented levels rather than assuming a fixed latest scale.
- Treat a baseline as migration inventory, not as permission to add new suppressions.
- Make every suppression narrow, named, justified, and reviewed for removal.
- Keep analyzer configuration and stubs in version control.
- Prefer native types first. Use PHPDoc or analyzer-specific syntax only when the public contract or analyzer needs generic, shape, template, or other information that native PHP cannot express.
- Use Psalm's `array<K,V>`, `list<T>`, and `array{...}` forms to state collection invariants that `array` alone cannot state.
- Configure the analyzed PHP target to the supported range, independently of the interpreter running the analyzer. Check extension stubs and framework plugins against installed versions, and complement analysis with real runtime tests.
- Make static analysis, syntax linting, formatting checks, and Composer validation required CI jobs.
- PHPStan's own analyzer source is a useful verified example of strict types, typed constructor injection, and precise collection annotations.
