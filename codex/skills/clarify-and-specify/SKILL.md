---
name: clarify-and-specify
description: Resolve material product, behavior, scope, interface, migration, or acceptance decisions that evidence cannot safely determine. Use only while such a decision remains unresolved, not for repository layout preferences, ordinary implementation judgment, or merely large work.
---

# Clarify and Specify

1. Inspect the available project, documentation, and surrounding implementation before asking questions. Resolve facts through evidence and do not trigger this workflow solely because a request is large or multi-stage.
2. Identify the objective, users, current and desired behavior, constraints, non-goals, dependencies, risks, and observable acceptance criteria. Expose only assumptions that would materially change the solution. Let `domain-modeling` resolve business meaning and invariants, `design-project-architecture` resolve technical responsibility boundaries, and `design-ui-ux` resolve user-facing experience decisions. This skill owns the unresolved decision question and resulting specification, not those disciplines' analysis.
3. Treat file placement and naming as implementation detail unless the path is itself a public import, URL, framework discovery name, migration identifier, generated contract, ownership boundary, or explicit acceptance requirement. Let repository precedent or `organize-project-structure` settle ordinary layout choices.
4. Ask one concise decision-bearing question at a time. Ask about decisions only. Let evidence, established defaults, or compatible reversible implementation judgment settle facts and minor details.
5. Produce one coherent specification containing scope, behavior, interfaces or data changes, failure behavior, compatibility requirements, validation, and acceptance criteria. Keep implementation details open when several approaches remain valid. Keep the result inline when that is sufficient. If a retained artifact is required, use the repository's established location and a purpose-specific name rather than creating a generic `spec.md` hierarchy. Do not apply production-code size or file-count rules to prose specifications.
6. Request explicit approval only when a material decision remains unresolved or a proposed irreversible consequence was not already named and authorized. Treat an explicitly authorized action as settled unless new evidence changes its effect or risk. Incorporate corrections into the specification rather than appending contradictory notes.

Finish when a new implementer could determine what is in scope and prove completion without guessing.
