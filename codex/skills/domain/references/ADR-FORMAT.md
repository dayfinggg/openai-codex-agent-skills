<adr_format>
ADRs live in `docs/adr/` and use sequential numbering, as in `0001-slug.md` and `0002-slug.md`. Create the `docs/adr/` directory lazily, only when the first ADR is needed.
</adr_format>

<template>
An ADR follows this template.

```md
# {Short title of the decision}

{1-3 sentences: what's the context, what did we decide, and why.}
```

An ADR can be a single paragraph. Its value is the record that a decision was made and why, not filled-out sections.
</template>

<optional_sections>
Include these sections only when they add real value. Most ADRs do not need them.
- A `Status` frontmatter field (`proposed | accepted | deprecated | superseded by ADR-NNNN`) helps when decisions are revisited.
- A Considered Options section fits only when the rejected alternatives are worth remembering.
- A Consequences section fits only when non-obvious downstream effects need a mention.
</optional_sections>

<numbering>
Scan `docs/adr/` for the highest existing number and increment it by one.
</numbering>

<when_to_offer>
Offer an ADR only when three conditions all hold.
1. The decision is hard to reverse, so changing your mind later has a real cost.
2. It is surprising without context. A future reader will look at the code and wonder "why on earth did they do it this way?"
3. It is the result of a real trade-off, with genuine alternatives and specific reasons for the pick.

Skip a decision that is easy to reverse, because you will just reverse it. Skip one that is not surprising, because nobody will wonder why. With no real alternative, there is nothing to record beyond "we did the obvious thing."

<what_qualifies>
Seven kinds of decision qualify.
- Architectural shape qualifies. Examples are "We're using a monorepo" and "The write model is event-sourced, the read model is projected into Postgres."
- Integration patterns between contexts qualify, as in "Ordering and Billing communicate via domain events, not synchronous HTTP."
- Technology choices that carry lock-in qualify, such as the database, message bus, auth provider, or deployment target. This covers only the libraries that would take a quarter to swap out.
- Boundary and scope decisions qualify, as in "Customer data is owned by the Customer context. Other contexts reference it by ID only." The explicit refusals are as valuable as the acceptances.
- Deliberate deviations from the obvious path qualify, as in "We're using manual SQL instead of an ORM because X." A reasonable reader would assume the opposite. Recording them stops the next engineer from "fixing" something deliberate.
- Constraints not visible in the code qualify. One example is "We can't use AWS because of compliance requirements." Another is "Response times must be under 200ms because of the partner API contract."
- Rejected alternatives qualify when the rejection is non-obvious. If you considered GraphQL and picked REST for subtle reasons, record it. Otherwise someone will suggest GraphQL again in six months.
</what_qualifies>
</when_to_offer>
