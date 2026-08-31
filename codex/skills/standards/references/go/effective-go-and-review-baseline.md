# Effective Go and review baseline

Run `gofmt` on every Go file, and use `goimports` when it is the project's chosen import tool.[1][2]
Keep standard-library imports in the first group and third-party or local imports in later groups.[2]
Write the successful path with minimal indentation, handle errors first, and omit `else` after `return`, `continue`, or `break`.[1][2]
Document an exported name only when callers need contract details that are not clear from its name, signature, types, or tests. When a source comment is required, make it a full sentence that starts with the declared name; do not add boilerplate.[1][2]
Prefer names, types, and structure that make behavior evident. Keep a source note only for a surprising, performance-sensitive, security-sensitive, or externally constrained reason that code cannot express; do not narrate syntax.[3]
There is no fixed line-length rule; refactor names or semantic boundaries instead of wrapping code mechanically.[2][3]
Use `defer` immediately after acquiring a resource when cleanup must happen on every return path.[1]
Keep APIs explicit about ownership, cleanup, blocking, concurrency, and error behavior.[3][5]
Prefer ordinary language constructs and standard-library facilities before adding abstractions or dependencies.[3]
