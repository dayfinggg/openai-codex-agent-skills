# File organization

- Put application UI code under `src`, bootstrap in `src/main.ts`, and keep build or tooling configuration outside `src`.
- Organize by feature or user-facing domain, not by global `components`, `services`, or `directives` buckets.
- Co-locate a component's TypeScript, template, styles, and spec files in the feature directory.
- Use hyphenated file names that match the primary TypeScript symbol, such as `user-profile.ts` and `user-profile.spec.ts`.
- Keep one concept per file and split a directory when navigation becomes difficult.
- Avoid generic `utils.ts`, `helpers.ts`, and `common.ts` files; name a file for the concept it owns.
- Keep `app.config.ts` for application-wide providers and `app.routes.ts` for route declarations.
