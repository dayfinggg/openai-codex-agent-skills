# Blocks and Enumerable

- Use `map` for a transformation, `select` or `filter` for selection, and `find` for the first match.
- Use `any?`, `all?`, `none?`, and `one?` when the question is a predicate rather than a count.
- Use `each` for side effects and do not hide side effects inside `map`.
- Use `reduce` for a clear fold and `each_with_object` when accumulating into a mutable result object.
- Use `flat_map` for one-level flattening instead of `map` followed by `flatten`.
- Use `size` for a collection size when that is the operation intended; `count` may traverse an `Enumerable`.
- Use a lazy enumerator for large or unbounded pipelines when eager materialization is unnecessary.
- Keep a chain of collection calls readable; extract a named method when a block needs its own explanation.
- Use `&:method` when the block consists only of that method call and the shorthand remains clear.
- Prefer `{ ... }` for a short single-line block and `do ... end` for a multi-line block.
- Use `yield` when a method only invokes its block, and capture `&block` when the block must be stored or forwarded.
- Return an enumerator from a no-block collection method when the API is intended to support both styles.
- Document whether a block is required, how many times it runs, and what it should return.
- Use `next` to skip an item and `break` to stop an iteration; do not use exceptions to control ordinary iteration.
- Do not mutate the collection being traversed unless the method explicitly promises that behavior.
- Keep resource-owning blocks responsible for closing or releasing the resource, even when the block raises.
- Implement `#each` before including `Enumerable`, and yield successive elements in the collection's natural order.
- Test both the yielded values and the return value when a custom collection implements `Enumerable`.
