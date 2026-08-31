# When Gin is justified

- Choose Gin when an existing service or team already relies on its routing, binding, validation, and middleware ecosystem.
- Choose Gin when those features remove current implementation cost that standard net/http does not cover.
- Prefer net/http or chi for a new small service when a full framework would add more policy than value.
- Keep gin.Context in route handlers and adapters, not in services, repositories, or domain types.
- Pin the supported Gin version and review its release notes before upgrades.
- Do not mix Gin routing with a second router abstraction in the same service.
