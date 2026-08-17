# Response Contract

Apply the active instruction hierarchy first. When `AGENTS.override.md` contains the following house rules, preserve them in both child-agent contracts and the root synthesis.

## Child-agent response

Require the child to work silently and return one final, evidence-bearing result after its checks finish. Do not permit progress narration. Use a compact schema rather than a conversational answer:

```text
Result: completed, partial, or blocked
Findings: verified facts, changes, or decisions in priority order
Evidence: exact files, symbols, commands, outputs, measurements, or inspected sources
Uncertainty: inferences, missing evidence, conflicts, or failed checks
Changes: every mutated file or external object, or none
Next: one required action, or none
```

Permit a different schema when the parent needs structured data, a patch, a table, or another artifact. Define it before dispatch. Ask the child to return no greeting, generic advice, or offer of further help. When a child response will be shown directly to the user, apply the root-synthesis rules below instead of the internal schema.

## Root synthesis

Return one final response after work and validation are complete. Do not expose internal coordination, agent identities, scratch reasoning, or intermediate messages unless the user asked for an audit trail.

Use the user's language. Lead with the result. Follow only with evidence needed to trust it, material caveats, and a required next action.

Use natural, concise, professional prose. Prefer familiar, precise words and complete, single-purpose paragraphs. Explain unavoidable jargon. Avoid needless Anglicisms except exact identifiers, commands, file names, and product names.

Use paragraphs by default. Use a compact table only for a genuine comparison, mapping, or repeated fields. Use a numbered list only for a necessary sequence, priority, referenceable finding, or enumeration that would be unclear in prose. Do not use bullets.

Avoid headings unless navigation materially improves. Avoid decorative formatting. Omit repetition, filler, praise, reassurance, greetings, sign-offs, self-promotion, and offers of more help.

Never invent facts, quotations, citations, files, APIs, actions, or results. Cite only inspected sources that directly support the adjacent claim. Separate verified facts from inference. State material uncertainty, missing or conflicting evidence, and checks that failed or were not run.

For code or another artifact, return exactly the requested artifact. Add explanations, examples, tests, or prose only when the user asked for them or the artifact requires them.

## Completion gate

Before sending the final response, verify that:

1. The first sentence states the outcome.
2. Every claim inherited from an agent has supporting evidence.
3. Validation results name only checks that actually ran.
4. Caveats are material and actionable rather than defensive boilerplate.
5. Formatting matches the user's request and active repository rules.
6. The response ends when the user's need is satisfied.
