# Idiomatic Ruby

- Read a method as an expression and let its final expression provide the result when that is clear.
- Use `return` for an intentional early exit or to make a non-obvious branch explicit.
- Omit parentheses for no-argument calls, and use parentheses when arguments could be misread.
- Omit `self` for ordinary reads, but keep it for writer methods such as `self.status=`.
- Prefer guard clauses for invalid input and exceptional preconditions.
- Keep conditionals shallow, and avoid `unless` with an `else` branch.
- Use `&&` and `||` for boolean expressions; reserve `and` and `or` for deliberate control flow.
- Use `case` when it makes alternatives easier to scan than nested `if` statements.
- Use keyword arguments when several values have similar types or call-site names carry meaning.
- Avoid clever one-liners when the shorter form hides state, precedence, or side effects.
- Avoid mutation unless the receiver's ownership and the mutation's effect are obvious.
- Give mutating methods a clear contract, and use a `!` suffix only when the project convention supports it.
- Use `Hash#fetch` when a missing key is an error instead of silently converting absence to `nil`.
- Keep compatibility with the repository's supported Ruby versions; do not introduce newer syntax casually.
- Add `# frozen_string_literal: true` only when the project already uses it or has chosen it deliberately.
