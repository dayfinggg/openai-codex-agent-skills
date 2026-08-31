# PEP 8 and PEP 20

- Use four spaces for indentation and never mix tabs and spaces.
- Prefer implicit continuation inside parentheses, brackets, and braces over backslashes.
- Use 79 columns for conservative library code, or a documented project limit up to 99.
- Keep existing comments and docstrings within the repository's formatter and linter rules; do not add them merely to satisfy a line-length convention.
- Put two blank lines around top-level classes and functions, and one inside classes.
- Use one statement per line unless a tiny, unambiguous conditional expression is clearer.
- Surround operators with the spacing PEP 8 specifies, and avoid trailing whitespace.
- Use `lower_snake_case` for functions, methods, variables, modules, and packages.
- Use `CapWords` for classes and exception types.
- Use `UPPER_SNAKE_CASE` for constants and a single leading underscore for internal names.
- Choose descriptive names; scope may justify a short loop variable but not a vague public name.
- Keep public and internal interfaces visibly distinct and document the public contract.
- Prefer names, types, and structure that express intent. Retain a short source note only for a non-obvious constraint that code cannot express; never narrate the code.
- Use a docstring for a public module, class, function, or method only when its externally relevant contract is not clear from names, types, tests, or generated API metadata.
- Favor simple control flow over clever expressions, implicit mutation, or metaprogramming.
- Break a style rule only for a documented compatibility, readability, or local-consistency reason.
