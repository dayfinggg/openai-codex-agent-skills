# Project layouts

Use this reference when choosing a layout or untangling ownership. Read only the applicable example. File names and separated roles illustrate decisions, not files to generate automatically. Follow existing organization and framework conventions before adopting a different tree.

## Choose boundaries before implementation

Map the current feature to its responsibilities before selecting folders. For each affected module, identify what it owns, what it exposes, which collaborators it needs and what it must not do. Use the existing code and current requirements, not hypothetical future services.

Group business capabilities that evolve together. Separate a responsibility when it has distinct rules, dependencies, state ownership or a useful test boundary. A simple handler can stay cohesive in one file. Larger behavior can need presentation, domain or persistence boundaries without needing a separate package, service or deployment.

Keep composition entry points responsible for wiring dependencies and starting or stopping the application. A route or screen can orchestrate a use case without owning unrelated business rules. Cross-feature callers should use the owning module's contract rather than reaching into its private state or storage details. Avoid circular dependencies. Move genuinely shared behavior to a named owner only when current callers need the same concept, not merely similarly shaped code.

## Assign state and resource ownership

Choose the framework's existing ownership and lifecycle mechanisms. Resolve only the kinds of state or resources used by the task.

| Concern | Ownership decision |
| --- | --- |
| Domain state | Identify the authoritative writer and operations that preserve its invariants. Keep mutations behind that contract. |
| UI state | Keep transient state with its component or feature. Lift it only to the scope that actually shares it. Avoid a second independently mutable copy of the same fact. |
| Persistent data and transactions | Identify the use case coordinating atomic changes and the data-access boundary performing them. Extraction must not silently change transaction scope. |
| Connections and clients | Identify who creates or borrows them, their request or application lifetime, and who closes owned resources. A borrower must not close a shared resource it does not own. |
| Timers, subscriptions and background tasks | Identify startup, cancellation and cleanup ownership, including failure paths. Keep tasks tied to an explicit lifetime. |
| Configuration and caches | Decide initialization, scope and invalidation where relevant. Do not turn a convenient shared cache into an implicit source of domain truth. |

## Review growth without arbitrary caps

Inspect a growing file before adding another responsibility. Size is a signal to review cohesion, not a universal limit. Look for independent reasons to change, interleaved rules and I/O, unrelated dependency groups, scattered mutation or cleanup, and tests that require unrelated infrastructure. A long cohesive algorithm or generated file does not need mechanical splitting.

Extract the responsibility with a clear owner and contract. Keep closely related helpers beside it. Avoid splitting a workflow into tiny files that still reach into each other's internals, moving code to a generic utility bucket, or introducing layers whose only job is forwarding calls. If no useful boundary exists, keep the code together and simplify locally.

After extraction, trace a real caller through the new boundary. Check imports and exports, dependency direction, preserved state invariants, transaction lifetime, failure handling and cleanup. Exercise the affected behavior with appropriate existing tests. A smaller file alone is not evidence that the design improved.

## Layout examples

Use feature folders when they fit the project. Share components or libraries for real consumers and name their responsibility clearly. Localization folders below apply only when the project needs localization. Services, repositories and domain files are optional separations justified by the behavior, not a required trio.

## Node.js service

```text
src/
  orders/
    api.ts            routes and request parsing
    orders.ts         substantial domain rules, independent of HTTP
    orders-store.ts   data access
    orders.test.ts
  admin/
    api.ts
    auth.ts
  config.ts           reads environment variables once
  server.ts           wires dependencies, mounts routes, owns shutdown
dictionaries/
  en.json
```

## Next.js app

```text
app/
  (shop)/
    page.tsx
    menu/page.tsx
    order/
      page.tsx
      actions.ts          Server Functions for this route
      _components/        components used only here
  (admin)/
    layout.tsx
    orders/
      page.tsx            route presentation and authorized data access
      actions.ts          validates and authorizes mutation entry points
  layout.tsx
  dictionaries/
    en.json
lib/
  orders/                 domain logic and data access shared by routes
components/               components shared across routes
```

## Vue app

```text
src/
  features/
    catalog/
      CatalogPage.vue
      ProductCard.vue
      useCatalogFilters.ts
      catalog-api.ts
    cart/
  components/             shared presentational components
  stores/                 state genuinely shared across features
  locales/
    en.json
  router.ts
```

## PHP project

```text
src/
  Order/
    OrderController.php
    OrderService.php
    OrderRepository.php
    Order.php
  Admin/
config/
lang/
  en.json
public/
  index.php               front controller only
tests/
  Order/
```

## Python service

```text
src/app/
  orders/
    api.py
    service.py          coordinates substantial use cases
    repository.py       persistence operations when separation is useful
    models.py           feature-owned types
  config.py
  main.py               composition and application lifecycle
tests/
  orders/
locales/
  en.json
```

## Source basis

[Microsoft architectural principles](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/architectural-principles) supports separation of concerns, encapsulation and explicit dependencies. Apply those principles at the scale of the actual project, not as a mandate for layers or microservices.

[Google code review guidance](https://google.github.io/eng-practices/review/reviewer/looking-for.html) supports reviewing system fit and complexity while avoiding speculative generality. [Google small-change guidance](https://google.github.io/eng-practices/review/developer/small-cls.html) emphasizes cohesive changes over simplistic line counts. Its change-review advice informs reviewability here, not a numeric file-size policy. The ownership checklist and example trees above adapt these principles for implementation decisions.
