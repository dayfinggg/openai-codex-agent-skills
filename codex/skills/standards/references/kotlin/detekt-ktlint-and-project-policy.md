# Detekt, ktlint, and project policy

Use ktlint for the project's Kotlin formatting and style rules, and use detekt for configured inspections, smells, and complexity checks.
Treat `.editorconfig`, detekt YAML, Gradle task wiring, and CI as executable project policy rather than optional advice.
Ktlint reads `.editorconfig` files along the path, with a project-root file normally providing shared defaults and nested files narrowing scope.
Run the repository's pinned formatter command instead of inventing a local ktlint version or rule set.
Review formatter diffs and avoid formatting unrelated files in a feature change.
Use a ktlint baseline only as a migration record; new violations should not be added silently.
Detekt custom configuration can replace default values unless `buildUponDefaultConfig` is enabled, so inspect the actual project configuration before interpreting a finding.
Enable detekt configuration validation when practical so misspelled or deprecated first-party rules fail early.
If the detekt plugin is wired conventionally, its analysis task participates in `gradle check`; verify the repository task graph before assuming this.
Treat a baseline as known debt that needs ownership, not as permission to ignore new findings.
Prefer a narrow suppression with a reason over a global rule disable, and revisit suppressions when the surrounding design changes.
