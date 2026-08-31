# RuboCop and project configuration precedence

- Inspect the nearest `.rubocop.yml`, parent configurations, `.rubocop_todo.yml`, `inherit_from`, `inherit_gem`, and any project binstub.
- RuboCop searches from the inspected file's directory upward, then project `.config` locations, global configuration, and defaults.
- An explicit `--config` path replaces that search, so record it when reproducing a CI or editor result.
- For command options, explicit CLI options override `RUBOCOP_OPTS`, which overrides the `.rubocop` options file.
- Within inherited configuration, `inherit_gem` loads first, `inherit_from` files follow in listed order, and local directives win last.
- Child configuration overrides inherited values, while hashes merge and arrays normally replace unless `inherit_mode` says otherwise.
- Check `TargetRubyVersion` and the repository's `.ruby-version`, gemspec, lockfile, or CI matrix before accepting a syntax offense.
- Run RuboCop through Bundler when the repository locks the gem, such as `bundle exec rubocop` or `bin/rubocop`.
- Read the cop documentation before disabling or autocorrecting a rule, especially for unsafe corrections.
- Treat a TODO exclusion as debt with a reason and scope, not as evidence that the rule is irrelevant.
- Prefer a narrow per-file or per-cop exception over a global disable when legacy code requires an exception.
- Apply the project's configured style before the generic Ruby Style Guide when the two differ.
- Review autocorrect diffs manually because formatting changes can alter heredocs, semantics, or generated files.
- Run the same RuboCop command and target paths that CI runs before claiming style compliance.
- Keep style changes separate from behavior changes when that separation makes review and rollback clearer.
