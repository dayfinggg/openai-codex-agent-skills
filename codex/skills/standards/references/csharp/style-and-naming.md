# Style and naming

- Follow the project's `.editorconfig`; use four spaces and one consistent brace style.
- Prefer Allman braces, explicit visibility, and imports at the top of the file unless local style says otherwise.
- Name types and public members with PascalCase and parameters and locals with camelCase.
- Prefix private or internal instance fields with `_`; use `s_` for static fields when that is the repository convention.
- Use `I` for interfaces, `Async` for methods returning awaitable types, and `Exception` for exception types.
- Use singular names for ordinary enums and plural names for flags enums.
- Choose descriptive names and prefer clarity over abbreviations or unnecessary brevity.
- Use `var` only when the type is obvious from the right-hand side and the declaration remains easy to scan.
- Prefer `nameof` to duplicated parameter or member-name strings.
- Keep methods and types easy to scan; avoid deeply nested conditionals and long argument lists.
- Do not reformat an unrelated file; match the file's established style before applying a general rule.
