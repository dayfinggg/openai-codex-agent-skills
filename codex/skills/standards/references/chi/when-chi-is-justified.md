# When chi is justified

- Choose chi when route groups, subrouters, mounts, or inline middleware materially reduce routing complexity.
- Choose chi when preserving standard http.Handler signatures is an explicit interoperability requirement.
- Keep net/http when Go 1.22 ServeMux already expresses the route tree and no chi-specific capability is needed.
- Do not add chi only to rename paths or wrap a single handler.
- Keep one router abstraction in a service and document the dependency decision.
- Pin the major import path and review chi changes before upgrades.
