# Container contracts

- Type a parameter by the operations it needs rather than by the caller's current concrete container.
- Treat `Iterable`, `Sequence`, and `Mapping` as behavioral contracts, not complexity guarantees. Check the concrete representation when operation cost matters.
- Accept `Iterable[T]` for a single pass, `Collection[T]` when size or emptiness is required, `Sequence[T]` when ordered indexing is required, and `Mapping[K, V]` for read-only keyed access.
- Use mutable interfaces or concrete mutable containers only when mutation is part of the callable's contract.
- Do not test a general `Iterable` for emptiness or assume it can be traversed twice. A generator may be single-use and is truthy even when it yields no items.
- Materialize an iterable once when the algorithm genuinely needs indexing, a length, repeated traversal, or sorting plus later reuse, and make that cost visible in the implementation.
- Spell fixed-length tuple shapes explicitly, such as `tuple[int, int]`, and use `tuple[int, ...]` only for a homogeneous variable-length tuple.
