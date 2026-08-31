# Nullable reference types

- Enable nullable analysis with `<Nullable>enable</Nullable>` at the project or repository level.
- Treat `string` as a non-null contract and `string?` as an intentional maybe-null contract.
- Initialize every non-nullable field and property on every valid construction path.
- Check nullable values at the boundary where absence is handled, then keep the core non-nullable.
- Use nullable analysis attributes when a method's result depends on an argument or a boolean test.
- Use the null-forgiving operator `!` sparingly; it disables a compiler safeguard at that expression.
- Remember that nullable reference types are compile-time analysis; they do not change runtime types or runtime null behavior.
- Validate data from serialization, reflection, configuration, and other unannotated boundaries at runtime.
- Do not assume `default` structs or newly allocated reference arrays contain initialized non-nullable members.
