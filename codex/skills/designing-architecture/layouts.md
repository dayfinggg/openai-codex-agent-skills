# Project layouts

Group by business feature. Each feature folder owns its entry points, domain logic and data access, and exposes a small public interface. Shared code lives in named libraries, never in a generic folder. When the framework defines its own conventions, such as Laravel or Nuxt, follow them first and apply feature grouping inside them.

## Node.js service

```text
src/
  orders/
    api.ts            routes and request parsing
    orders.ts         domain logic, no HTTP or database imports
    orders-store.ts   data access
    orders.test.ts
  admin/
    api.ts
    auth.ts
  config.ts           reads environment variables once
  server.ts           creates the server and mounts feature routes
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
      page.tsx            checks the session before reading data
      actions.ts          checks the session inside every Server Function
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
  stores/                 Pinia stores
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
    service.py
    repository.py
    models.py
  config.py
  main.py
tests/
  orders/
locales/
  en.json
```
