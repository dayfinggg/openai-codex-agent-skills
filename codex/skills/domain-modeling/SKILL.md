---
name: domain-modeling
description: Resolve unclear business meaning, invariants, consistency ownership, or bounded-context boundaries. Use only while one of those domain decisions remains material; skip technical architecture, file-tree organization, ordinary CRUD, utilities, and UI styling.
---

# Domain Modeling

1. Confirm that business meaning, invariants, consistency ownership, or bounded-context boundaries are materially unclear. If the remaining question concerns technical module, runtime, deployment, or team boundaries, continue with `design-project-architecture`. If it concerns only filesystem layout or naming, continue with `organize-project-structure`. Let `design-ui-ux` own user-facing flow and presentation decisions. Use `clarify-and-specify` only when authoritative evidence cannot resolve a material decision that requires user choice.
2. Read existing domain documents, decisions, tests, workflows, and relevant code. Identify the domain authority and mark unknowns instead of inventing business rules.
3. Collect representative success, failure, and edge scenarios. Resolve synonyms, overloaded terms, and meanings that differ by actor or context. Use the agreed language in models and code.
4. Extract business rules and invariants. Assign each invariant an owner and a consistency boundary, then challenge it against the scenarios and current implementation.
5. Read [ddd-reference.md](references/ddd-reference.md). Introduce subdomains, bounded contexts, context mappings, entities, value objects, aggregates, services, or events only when a concrete difference in meaning, ownership, lifecycle, or consistency requires them.
6. Read [aggregate-design.md](references/aggregate-design.md) before defining or changing an aggregate. Do not equate a bounded context with a service or an aggregate with an object graph.
7. Validate the model by walking every representative scenario with the user or an authoritative source. Record only the useful artifacts, using the repository's location and naming precedent. Name them by purpose, such as a glossary, scenario catalog, invariant catalog, context map, or aggregate decision. Read [artifact-formats.md](references/artifact-formats.md) for compact formats. Do not force one domain concept per file, rename public or serialized identifiers merely to match new vocabulary, or create a DDD document set without a consumer.

Finish when terms are unambiguous within each context, invariants have enforcement boundaries, cross-context translations are explicit where needed, and every technical pattern has a domain reason.
