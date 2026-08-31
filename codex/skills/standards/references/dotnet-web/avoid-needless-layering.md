# Avoid needless layering

- Start a small service as one deployable project organized by feature, and add projects only when a boundary earns its cost.
- Keep endpoint or controller code thin but meaningful; a chain of pass-through classes is not separation of concerns.
- Add an abstraction when it protects a volatile dependency, defines a domain boundary, enables a needed replacement, or improves a specific test seam.
- Do not create generic repositories, generic services, mapping layers, or mediator pipelines merely to satisfy a template.
- Let simple CRUD use direct EF Core access when that is the clearest design.
- Use a richer application core and infrastructure separation when business rules, ownership, persistence replacement, or team boundaries justify it.
- Prefer feature cohesion over folders or projects that scatter one use case across many horizontal layers.
- Keep cross-cutting policy in the framework pipeline and keep feature-specific policy beside the feature.
- Reassess architecture when measured complexity or change pressure shows that the current boundary no longer serves the product.
