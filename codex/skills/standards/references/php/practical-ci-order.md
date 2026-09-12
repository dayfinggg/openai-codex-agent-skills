# Practical CI order

Use existing CI and compatible tool versions. Start with manifest validation and syntax linting on the minimum supported PHP, then the formatter check, static analysis, focused unit and integration tests, and supported dependency-security checks. Run `composer check-platform-reqs` on the actual target installation; use `--no-dev` for a production installation where appropriate.

Exercise the promised runtime/dependency matrix as described in [version compatibility](version-compatibility.md). Keep separate tooling interpreters explicit. An analyzer pass on modern PHP is not an execution test on legacy PHP.

For affected changes, verify module consumers, cache consistency, serialization, migrations, and worker behavior. Review public API and dependency changes, suppressions, and any support-range changes. Report unavailable runtime checks precisely rather than marking them passed.
