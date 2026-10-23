# Project structure

Starting points only. An existing project's structure wins.

## Python

```
src/shop/
  orders/
    domain/          entities, value objects, domain errors
    application/     use cases, ports (typing.Protocol), request and response dataclasses
    adapters/        repositories, API clients, controllers, presenters
  infrastructure/    framework app, ORM setup, settings
  main.py            composition root
tests/
  orders/unit/       domain and use case tests with fakes
  orders/integration/ adapter tests against real services
```

## TypeScript

```
src/
  orders/
    domain/
    application/     use cases and port interfaces
    adapters/        http controllers, repositories, gateways
  infrastructure/    server setup, database client, config
  main.ts            composition root
```

## Java

```
com.example.shop.orders.domain
com.example.shop.orders.application        use cases, port interfaces
com.example.shop.orders.adapters.in.web    controllers
com.example.shop.orders.adapters.out.persistence
com.example.shop.config                    Spring configuration as composition root
```

Keep Spring, JPA, and Jackson annotations out of `domain` and `application`, and map JPA entities to domain objects in the persistence adapter.

## C#

```
Shop.Domain           class library, no project references
Shop.Application      references Domain, holds use cases and port interfaces
Shop.Infrastructure   references Application, holds EF Core, external clients
Shop.Api              references Application and Infrastructure, holds controllers and DI setup
```

Separate projects make the compiler enforce the dependency rule.

## Go

```
internal/
  orders/
    order.go          domain types and rules
    service.go        use cases, plus the interfaces they consume
    postgres/         repository implementation
    http/             handlers
cmd/shop/main.go      composition root
```

Define interfaces in the package that uses them.

## Enforcing dependency direction in CI

| Language | Tool |
|---|---|
| Python | import-linter with layers or forbidden contracts |
| TypeScript, JavaScript | dependency-cruiser, or ESLint `no-restricted-imports` |
| Java | ArchUnit tests |
| C# | separate projects, or NetArchTest |
| Go | separate packages under `internal`, plus depguard in golangci-lint |
