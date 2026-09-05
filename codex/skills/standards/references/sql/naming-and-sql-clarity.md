# Naming and SQL clarity

- Choose one identifier convention and apply it consistently; lowercase `snake_case` is a common portable choice, not a SQL requirement.
- Avoid reserved words, ambiguous abbreviations, and quoted mixed-case identifiers.
- Case folding, quoting, and reserved-word rules differ across engines; avoid quoted mixed-case names when portability matters.
- Use names that reveal the domain and unit, such as `amount_cents`, `started_at`, or `retry_count`.
- Use consistent suffixes for identifiers and timestamps, such as `_id`, `_at`, and `_date`.
- Keep table and column naming singular or plural according to the repository convention, not personal preference.
- Name indexes with their table and purpose, such as `ix_orders_customer_created_at`.
- Select explicit columns at stable interfaces; do not expose `SELECT *` from APIs, views, or long-lived reports.
- Put one selected expression per line and keep a stable column order so diffs remain reviewable.
- Qualify columns with short, descriptive aliases whenever more than one table is present.
- Prefer names, constraints, CTEs, and schema structure to express business rules and invariants. Do not add prose SQL comments. Preserve optimizer hints or other directives that affect execution.
- Format SQL with an agreed formatter and linter; configure the target dialect rather than linting everything as ANSI.
- SQLFluff is a concrete cross-dialect linting example; run `sqlfluff lint query.sql --dialect ansi` or the project’s dialect.
- Bind values through parameters or prepared statements; never concatenate untrusted values into SQL text.
- Allow-list dynamic identifiers and sort directions because ordinary bind parameters cannot represent identifiers.
- Give each statement one purpose and make its input, output grain, and side effects easy to state.
- Use a CTE to name a meaningful relational step, not to hide a trivial expression behind extra indirection.
