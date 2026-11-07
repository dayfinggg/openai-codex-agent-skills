<structure>
A `GLOSSARY.md` follows this structure.

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```
</structure>

<rules>
Four rules keep the glossary useful.
- Be opinionated. When several words exist for the same concept, pick the best one and list the others under `_Avoid_`.
- Keep definitions tight, at one or two sentences. Define what the term is, not what it does.
- Include only terms specific to this project's context. General programming concepts (timeouts, error types, utility patterns) stay out, even when the project uses them heavily. Before you add a term, ask whether it is unique to this context or a general programming concept. Only the former belongs.
- Group terms under subheadings when natural clusters emerge. If all terms belong to one cohesive area, a flat list is fine.
</rules>

<single_vs_multi_context>
A single-context repo, which is most repos, has one `GLOSSARY.md` at the repo root.

A multi-context repo has a `GLOSSARY-MAP.md` at the repo root. It lists the contexts, where they live, and how they relate, as in this example.

```md
# Glossary Map

## Contexts

- [Ordering](./src/ordering/GLOSSARY.md): receives and tracks customer orders
- [Billing](./src/billing/GLOSSARY.md): generates invoices and processes payments
- [Fulfillment](./src/fulfillment/GLOSSARY.md): manages warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`
```

Infer which structure applies from the files that exist.
- If `GLOSSARY-MAP.md` exists, read it to find the contexts.
- If only a root `GLOSSARY.md` exists, the repo has a single context.
- If neither exists, offer to create a root `GLOSSARY.md` when the first term is resolved.

When multiple contexts exist, infer which one the current topic relates to. If that is unclear, ask.
</single_vs_multi_context>
