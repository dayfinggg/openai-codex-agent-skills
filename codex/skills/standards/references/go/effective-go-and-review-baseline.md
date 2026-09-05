# Effective Go and review baseline

Run `gofmt` on changed Go files, and use `goimports` when it is the project's chosen import tool. Avoid formatting unrelated files.[1][2]
Keep standard-library imports in the first group and third-party or local imports in later groups.[2]
Write the successful path with minimal indentation, handle errors first, and omit `else` after `return`, `continue`, or `break`.[1][2]
Prefer names, types, and structure that make behavior evident. Do not add source comments. Provide API documentation only when explicitly requested, while preserving existing notices and tool-required directives.[1][2][3]
There is no fixed line-length rule; refactor names or semantic boundaries instead of wrapping code mechanically.[2][3]
Use `defer` immediately after acquiring a resource when cleanup must happen on every return path.[1]
Keep APIs explicit about ownership, cleanup, blocking, concurrency, and error behavior.[3][5]
Prefer ordinary language constructs and standard-library facilities before adding abstractions or dependencies.[3]
