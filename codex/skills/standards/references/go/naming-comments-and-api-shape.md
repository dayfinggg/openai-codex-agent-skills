# Naming and API shape

Use `MixedCaps` and `mixedCaps`, not underscores, for Go identifiers.[1][3]
Keep initialisms consistent: write `URL`, `HTTP`, `ID`, and `DB`, not `Url`, `Http`, `Id`, or `Db`.[2][4]
Use short receiver names derived from the type, consistently across methods; do not use `this`, `self`, or `me`.[2][4]
Do not prefix ordinary getters with `Get`; use the concept name unless “get” describes an actual operation such as HTTP GET.[1][4]
Choose variable-name length from scope and use: short local names are fine in tiny scopes, while long-lived or ambiguous values need more context.[4]
As a rough, non-normative guide, small scopes are 1–7 lines, medium scopes 8–15, large scopes 15–25, and very large scopes exceed 25 lines.[4]
Use package and type context to remove redundant words, but keep names specific enough to distinguish similar values.[3][4]
Document package or API contracts only when callers need details that names and signatures cannot express. Keep a package comment adjacent to the package clause only when the public contract or repository tooling requires it, and include lifecycle or cleanup obligations only when callers must know them.[2][5]
Keep error strings lower-case and without terminal punctuation unless a proper noun or acronym requires capitalization.[2]
