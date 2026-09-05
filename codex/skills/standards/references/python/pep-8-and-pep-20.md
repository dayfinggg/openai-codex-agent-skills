# PEP 8 and PEP 20

- Use four spaces for indentation and never mix tabs and spaces.
- Prefer implicit continuation inside parentheses, brackets, and braces over backslashes.
- Follow the configured formatter's line length. Use PEP 8's 79-column default only when the project has no established limit.
- Keep existing comments and docstrings within the repository's formatter and linter rules; do not add them merely to satisfy a line-length convention.
- Put two blank lines around top-level classes and functions, and one inside classes.
- Use one statement per line unless a tiny, unambiguous conditional expression is clearer.
- Surround operators with the spacing PEP 8 specifies, and avoid trailing whitespace.
- Use `lower_snake_case` for functions, methods, variables, modules, and packages.
- Use `CapWords` for classes and exception types.
- Use `UPPER_SNAKE_CASE` for constants and a single leading underscore for internal names.
- Choose descriptive names; scope may justify a short loop variable but not a vague public name.
- Keep public and internal interfaces visibly distinct through names, types, and structure.
- Do not add source comments or docstrings. Write contract documentation only when explicitly requested, in the requested destination.
- Favor simple control flow over clever expressions, implicit mutation, or metaprogramming.
- Break a style rule only for a documented compatibility, readability, or local-consistency reason.
