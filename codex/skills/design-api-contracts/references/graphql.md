# GraphQL Contracts

Apply these checks only to GraphQL schemas and operations.

## Schema Semantics

- Choose nullability from guarantees, not optimism. A non-null output promises that the field and its parent propagation behavior are safe for every resolver path.
- Distinguish omitted input from explicit null. Use dedicated input types instead of reusing output types.
- Give fields and arguments stable domain meanings. Avoid generic JSON scalars unless the domain value is inherently unstructured and its validation is documented.
- Define custom scalar serialization, parsing, bounds, and time or unit semantics.
- Design enums so clients can handle server evolution. Confirm the target client generators' unknown-value behavior before adding values.

## Queries and Mutations

- Provide stable node identifiers when identity is part of the public contract.
- Use connection-style pagination when cursor traversal is required. Define edge ordering, cursor opacity, page boundaries, and total-count cost or availability.
- Make mutations describe one domain outcome. Define whether validation failures appear as typed payload data, GraphQL errors, or both, and keep that choice consistent.
- Specify partial-data behavior and error paths for nullable subtrees. Do not make clients infer business failures from free-form messages.

## Evolution Checks

- Adding a nullable output field is usually schema-compatible. Adding a required input, removing a field, tightening nullability, or changing a type is breaking.
- Deprecate fields and enum values with a usable replacement and measurable removal criterion. Keep deprecated elements operational throughout the announced support window.
- Validate representative persisted queries and generated clients when the system relies on them.
- Account for selection complexity, depth, or cost limits in the contract when consumers can observe rejection or throttling.
