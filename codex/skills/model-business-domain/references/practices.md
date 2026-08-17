# Domain Modeling Practices

Strategic DDD aligns language and boundaries before tactical patterns. A bounded context gives a model a precise meaning. An aggregate is a consistency boundary, not an object graph convenience. Keep aggregates small and transact across them only when a business invariant truly demands it.

Use entities for identity and lifecycle, value objects for immutable descriptive concepts, and domain events for facts the domain cares about. Translate models across context boundaries rather than forcing one enterprise-wide object model.

Primary sources:

- [Eric Evans DDD reference](https://www.domainlanguage.com/ddd/reference/)
- [Martin Fowler on Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [Martin Fowler on bounded contexts](https://martinfowler.com/bliki/BoundedContext.html)
- [Martin Fowler on DDD aggregates](https://martinfowler.com/bliki/DDD_Aggregate.html)
- [Microsoft domain model guidance](https://learn.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/microservice-domain-model)
