# Rule precedence

When guidance conflicts, apply the following order.

1. Compiler errors, language semantics, runtime safety, and public compatibility come first.
2. Repository instructions, build files, CI checks, `.editorconfig`, and configured analyzers define the project contract.
3. Kotlin's official coding conventions and API guidance define the default style.
4. Maintainer guidance and team idioms refine the default when the project has no stronger rule.
5. Personal preference comes last.

Do not silence a project check merely to match a generic style guide.
Scope a necessary suppression narrowly and record its invariant in the tool-supported configuration or directive; do not add a prose comment when the exception can be expressed mechanically.
