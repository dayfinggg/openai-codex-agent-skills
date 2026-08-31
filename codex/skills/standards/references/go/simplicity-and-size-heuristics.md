# Simplicity and size heuristics

Review in this order: clarity, simplicity, concision, maintainability, then consistency.[3]
Use the least mechanism that makes the behavior clear; add complexity only for a measured requirement or a deliberate public-API tradeoff.[3]
If a function feels too long, too repetitive, or too deeply nested, change its semantic boundaries rather than counting lines.[2][3]
Avoid long parameter lists and adjacent parameters of the same type; use a documented option struct when many inputs are genuinely needed.[5]
Keep contexts out of option structs and configuration state; they describe call lifetime, not object configuration.[5][9]
Treat exported types, interfaces, dependencies, and package names as cognitive and maintenance costs.[3][5]
Keep a package large enough to contain one coherent domain and small enough for its docs and call sites to remain navigable.[5]
Keep related unexported implementation details together, and split only when a distinct concept or ownership boundary improves use.[5]
Prefer a focused file layout with related code grouped together; do not use file count as a proxy for quality.[5]
When an interface, helper package, or dependency exists only to avoid a little duplication, reconsider the boundary first.[5][21]
