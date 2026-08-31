# Static analysis

- Install PHPStan and/or Psalm as development dependencies and run them on code owned by the project.
- Analyze `src/` and relevant tests; do not analyze `vendor/` as if the project could fix third-party code.
- Start at a level the codebase can sustain, remove errors, and raise the level in controlled increments.
- PHPStan levels are cumulative; its current documented scale runs from level 0 to level 10.
- Treat a baseline as migration inventory, not as permission to add new suppressions.
- Make every suppression narrow, named, justified, and reviewed for removal.
- Keep analyzer configuration and stubs in version control.
- Prefer native types first. Use PHPDoc or analyzer-specific syntax only when the public contract or analyzer needs generic, shape, template, or other information that native PHP cannot express.
- Use Psalm's `array<K,V>`, `list<T>`, and `array{...}` forms to state collection invariants that `array` alone cannot state.
- Run analysis against the same PHP version and extensions used by the test matrix.
- Make static analysis, syntax linting, formatting checks, and Composer validation required CI jobs.
- PHPStan's own analyzer source is a useful verified example of strict types, typed constructor injection, and precise collection annotations.
