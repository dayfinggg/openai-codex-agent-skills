# Conventions and structure

- Keep conventional names and paths so routing, autoloading, generators, and teammates can find code.
- Use `app/models`, `app/controllers`, `app/views`, `app/jobs`, and the matching `test` directories.
- Prefer resourceful routes and actions such as `index`, `show`, `new`, `create`, `edit`, `update`, and `destroy`.
- Let routes describe resources, not implementation details or arbitrary controller verbs.
- Keep one resource and one responsibility per controller where practical.
- Use generators as a starting point, then review every generated migration, callback, route, and test.
- Keep schema changes reversible where feasible and deploy them in an order that works with old and new code. For inherently destructive changes, raise `ActiveRecord::IrreversibleMigration` or require an explicit backup and forward-fix plan.
- Treat the database schema as a shared contract, not merely a reflection of Ruby classes.
- Use Rails' naming and inflection conventions before adding explicit table, class, or foreign-key configuration.
- Add explicit configuration when the domain genuinely differs from the convention, and document the reason.
- Keep configuration in the normal Rails files so a new contributor can trace behavior without hunting custom boot code.
- Follow the application's formatter, linter, Ruby version, and test commands rather than imposing a new tool.
- Prefer the integrated Rails stack when it solves the problem; add a dependency only for a concrete capability.
- Make deviations easy to remove by isolating them behind normal Rails interfaces.
