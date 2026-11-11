---
name: domain
description: Builds and sharpens a project's domain model as design work happens. Use when a discussion turns on codebase terminology, or when a term is vague, overloaded, or against the glossary. Use when writing or editing a GLOSSARY.md. Use when recording or editing an architecture decision record (ADR).
---

<overview>
Actively build and sharpen the project's domain model as you design. This is the active discipline. It challenges terms, invents edge-case scenarios, and writes the glossary and decisions down the moment they settle. Merely reading `GLOSSARY.md` for vocabulary is not this skill, because any task can do that. This skill is for changing the model, not just consuming it.
</overview>

<file_structure>
Most repos have a single context, with this layout.

```
/
├── GLOSSARY.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

A `GLOSSARY-MAP.md` at the root means the repo has multiple contexts. The map points to where each one lives. System-wide decisions stay in the root `docs/adr/`, and context-specific decisions sit in each context's own `docs/adr/`.

```
/
├── GLOSSARY-MAP.md
├── docs/
│   └── adr/
├── src/
│   ├── ordering/
│   │   ├── GLOSSARY.md
│   │   └── docs/adr/
│   └── billing/
│       ├── GLOSSARY.md
│       └── docs/adr/
```

Create files lazily, only when you have something to write. If no glossary exists, offer to create a root `GLOSSARY.md` when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.
</file_structure>

<during_the_session>
<challenge_against_the_glossary>
Call out a conflict as soon as the user uses a term against the existing language in `GLOSSARY.md`. An example is "Your glossary defines 'cancellation' as X, but you seem to mean Y. Which is it?"
</challenge_against_the_glossary>

<sharpen_fuzzy_language>
Propose a precise canonical term when the user uses a vague or overloaded one. An example is "You're saying 'account'. Do you mean the Customer or the User? Those are different things."
</sharpen_fuzzy_language>

<discuss_concrete_scenarios>
Stress-test domain relationships with specific scenarios while they are under discussion. Invent scenarios that probe edge cases. They force the user to be precise about the boundaries between concepts.
</discuss_concrete_scenarios>

<cross_reference_with_code>
Check whether the code agrees when the user states how something works. Surface any contradiction you find. An example is "Your code cancels entire Orders, but you just said partial cancellation is possible. Which is right?"
</cross_reference_with_code>

<update_the_glossary_inline>
When the project keeps a `GLOSSARY.md` or the user agreed to one, update it right when a term is resolved. Capture terms as they happen instead of in batches. Use the format in [GLOSSARY-FORMAT.md](references/GLOSSARY-FORMAT.md), and read it before the first glossary edit.

`GLOSSARY.md` holds no implementation details. It is not a spec, a scratch pad, or a store for implementation decisions. It is a glossary and nothing else.
</update_the_glossary_inline>

<offer_adrs_sparingly>
Offer to create an ADR only when three conditions all hold.
1. The decision is hard to reverse, so changing your mind later has a real cost.
2. It is surprising without context, so a future reader will wonder "why did they do it this way?"
3. It is the result of a real trade-off, with genuine alternatives and specific reasons for the pick.

If any of the three is missing, skip the ADR. Read [ADR-FORMAT.md](references/ADR-FORMAT.md) before you write one, for its template, numbering, and the kinds of decisions that qualify.
</offer_adrs_sparingly>
</during_the_session>
