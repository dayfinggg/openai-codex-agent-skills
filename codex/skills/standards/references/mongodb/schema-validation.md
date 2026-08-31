# Schema validation
Flexible schema means the server does not enforce one shape unless you configure it.
Use per-collection validation after the application’s intended structure is known.
Use `$jsonSchema` with `bsonType`, `required`, `properties`, ranges, enums, array bounds, and descriptions.
MongoDB implements JSON Schema draft 4 with MongoDB-specific BSON types and differences.
Combine `$jsonSchema` with query expressions or `$expr` for cross-field rules.
Validation is a database guardrail, not a replacement for API input validation or authorization.
See [schema validation](https://www.mongodb.com/docs/manual/core/schema-validation/) and [specify JSON Schema](https://www.mongodb.com/docs/manual/core/schema-validation/specify-json-schema/).
The default `validationLevel` is `strict`, so inserts and updates must satisfy the validator.
`moderate` validates inserts and updates to documents that were already valid.
Use `moderate` only as a deliberate migration bridge, then clean old documents and return to `strict`.
The default `validationAction` is `error`, which rejects invalid writes.
`warn` permits the write and records a validation warning in the server log.
MongoDB 8.1 adds `errorAndLog`, which rejects and logs invalid writes.
Existing documents are not scanned merely because a validator was added.
Query existing invalid documents with `$nor` and the same `$jsonSchema` before tightening rules, as shown in [the validation query example](https://www.mongodb.com/docs/manual/core/schema-validation/use-json-schema-query-conditions/).
Use `collMod` to change validation on an existing collection.
`bypassDocumentValidation` is per operation and requires the corresponding privilege when access control is enabled.
Do not give ordinary application users `dbAdmin` or `restore` merely to bypass validation.
