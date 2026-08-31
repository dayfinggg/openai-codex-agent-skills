# Change discipline

- Add a route group, provider, data abstraction, or client boundary only when it solves a current URL, ownership, performance, security, or testing problem.
- Prefer the framework's special files and composition patterns over wrappers that merely forward props.
- Keep a cache policy close to the data it governs and record its freshness and invalidation assumptions.
- Keep client boundaries narrow until a measured interaction or shared behavior justifies moving them upward.
- Revisit route and module boundaries after real usage exposes repeated change, slow builds, awkward tests, or duplicated policy.
