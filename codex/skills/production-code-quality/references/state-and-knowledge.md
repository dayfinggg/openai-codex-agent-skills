# State and authoritative knowledge

Use this reference only when the changed behavior duplicates a rule or fact, maintains derived data, introduces a cache, or requires several places to remain consistent.

1. Keep each independently changing piece of knowledge in one authoritative representation. Do not merge code that is merely similar when the concepts, owners, or change drivers differ.
2. Derive secondary data from its source of truth when feasible. When caching is necessary, give invalidation and consistency one explicit owner and verify the material mutation paths.
3. Minimize the places where nonessential configuration, policy, or domain knowledge must be supplied or kept consistent. Do not expand scope merely to deduplicate incidental syntax.

Primary basis: the reviewed Thomas and Hunt, Fowler, and Ousterhout material recorded in [sources](sources.md).
