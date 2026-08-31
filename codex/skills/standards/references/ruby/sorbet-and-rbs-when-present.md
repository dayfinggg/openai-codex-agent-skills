# Sorbet and RBS when present

- Inspect for `sorbet/config`, `sorbet/`, `.rbi`, `sig/`, `Steepfile`, `rbs_collection*.yaml`, and type-checker entries in the `Gemfile`.
- Follow the repository's existing checker and version rather than introducing a second typing system without a migration plan.
- Keep Sorbet file sigils, method `sig` declarations, and RBI files synchronized with the Ruby implementation.
- Treat `T.untyped` and `T.unsafe` as narrow, documented escape hatches rather than routine fixes for type errors.
- Raise Sorbet strictness deliberately and incrementally; do not weaken a file merely to make a change pass.
- Run the repository's normal `bundle exec srb tc` or binstub after changing Sorbet code, signatures, or generated RBI files.
- Commit generated Sorbet interface files when the repository treats them as source-controlled artifacts.
- Keep RBS declarations in the configured signature directory, commonly `sig/`, and align them with visibility and overload behavior.
- Model nilability, block types, keyword arguments, and unions explicitly instead of hiding uncertainty in `untyped`.
- Treat `rbs prototype` output as a starting point that requires human correction, not as an authoritative contract.
- Run the repository's configured `rbs validate` and `steep check` commands when those tools are present.
- Use RBS type assertions or the project's equivalent when an API's runtime behavior needs signature coverage.
- Keep dynamic DSLs and generated methods represented in the project's RBI or RBS mechanism so callers see the real interface.
- Prefer `void` in RBS when a return value is intentionally discarded, and use `bool` for Ruby truth-value semantics when appropriate.
- Update type declarations in the same change as a public API change, and test the runtime behavior separately.
