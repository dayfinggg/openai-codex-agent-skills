---
name: agentdocs
description: Guides the writing of documents that agents read, so each run takes the same process. Use when creating or editing a skill, its description, or its reference files. Use when writing or modifying AGENTS.md, CLAUDE.md, a rule file, or a doc that an agent reaches through a pointer.
---

<overview>
This skill is a reference for writing any document an agent consumes. That covers a skill, an `AGENTS.md` or `CLAUDE.md`, and a doc reached by a pointer. The packaging differs, but the writing does not. The same levers make each one predictable. The agent then takes the same process every run, though its output may differ.

When the document is a Claude Code skill, read [SKILL-MECHANICS.md](references/SKILL-MECHANICS.md). It covers frontmatter, the invocation choice, the skill listing, and router skills. For another harness, check its own skill documentation before applying invocation fields or context budgets.
</overview>

<context_pointers>
A context pointer is a reference in the agent's context that names out-of-context material. It also encodes the condition for reaching it. A skill's description is one. A line in `AGENTS.md` that names a doc is the same object. The pointer's wording, not its target, decides when and how reliably the agent reaches the material. A must-have target behind a weakly worded pointer is a variance bug. Sharpen the wording first, and inline the material only if sharpening fails.

A pointer does two jobs. It states what the material is, and it lists the branches that should trigger reaching it. A branch is a distinct case the document handles, so different runs take different paths through it. Every word of an always-loaded pointer costs on every turn, so prune it even harder than the body.
- Front-load the leading word, because the pointer is where it does its triggering work.
- Write one trigger per branch. Synonyms that rename one branch are that branch written twice. Collapse them and keep only distinct branches.
- Cut identity that the body already carries.
</context_pointers>

<the_two_loads>
Every document and pointer you add spends one of two budgets.
- Context load is the cost of always-loaded material on the agent's window. It covers an `AGENTS.md` line, a skill description, and anything else in context every turn. It spends tokens and attention whether or not it fires.
- Cognitive load is the cost on the human, who must know which documents exist and when to reach for each. The human is the index. This cost is the price of human agency, not a cost to minimize. Spend it where human judgment matters, and remove it where it does not.

Material reached only through a pointer escapes context load, at the price of the pointer's own line. Material with no pointer at all rides entirely on cognitive load.
</the_two_loads>

<information_hierarchy>
A document holds two content types. Steps are the ordered actions the agent performs. Reference is the definitions, rules, and facts consulted on demand. The two mix freely. A recipe is all steps, the rules of a review are all reference, and many documents hold both. Write steps only where their order matters, and state outcomes for the rest. The core decision is where each piece sits on the information hierarchy. This ladder ranks material by how soon the agent needs it.
1. An in-file step is the primary tier, meaning what the agent does, in order.
2. In-file reference is consulted on demand. It is often a flat peer set, such as every rule of a review on one rung. That arrangement is fine, not a smell.
3. Disclosed reference sits in a separate file, behind a context pointer, and loads only when the pointer fires. It ranges from a sibling file in the same folder to external reference that any document can point at.

Push too little down and the top bloats. Push too much and you hide material the agent needs. That tension is the whole decision.

<progressive_disclosure>
Progressive disclosure moves material down the ladder, out of the main file and behind a pointer. The top then stays legible. It is mainly how the hierarchy stays protected, and only secondarily a token saving. Branching is the cleanest test. Inline what every branch needs, and put behind a pointer what only some branches reach. In a document with steps, reference that should be disclosed buries the steps. Attending to them then becomes a coin flip, so disclosure is a variance lever, not only a legibility one.
</progressive_disclosure>

<co_location>
Co-location is the companion rule within a file. The ladder decides how far down a piece sits, and co-location decides what sits beside it. Keep a concept's definition, rules, and caveats together in one section. Reading one part then brings its neighbors along. The document should read like documentation written for the agent. Grouped material reads that way, and scattered material does not. Co-location differs from duplication. Duplication repeats one meaning in two places, while scattering splits one meaning across many.
</co_location>

<sprawl>
Sprawl is the failure mode here. The document is simply too long, even when every line is live and unique. Attention thins across the excess, and every extra line is one more to keep relevant. The cure is the ladder. Disclose reference behind pointers, and split by branch or sequence so each path carries only what it needs.
</sprawl>
</information_hierarchy>

<completion_criteria>
Every step ends on a completion criterion, the condition that tells the agent the step is done. Two properties make it a lever.

<clarity>
Clarity asks whether the agent can tell done from not done. A vague bound such as "understanding reached" invites premature completion. The agent ends the step early, because its attention slips to being done. The visible steps still ahead, the post-completion steps, supply that pull, and a clear criterion resists it. Defend in order. Sharpen the bound first, because that is local and cheap. Hide the later steps by splitting the sequence only if the bound stays fuzzy and you observe the rush. Hiding works only across a real context boundary. Examples are a handoff, a subagent dispatch, or a skill with `context: fork`. An inline skill call leaves the later steps in context and clears nothing.
</clarity>

<demand>
Demand is how much the criterion requires. "Every modified model accounted for" forces thorough work, where "produce a change list" does not. Demand drives legwork, the digging the agent does within the work. Legwork lives in the wording, not in a step of its own. Demand is not bound to steps either. "Every rule applied" binds a body of flat reference just as "every step done" binds a sequence. That is how an all-reference document still carries a bar for exhaustiveness.
</demand>

The strongest criteria are both checkable and exhaustive.
</completion_criteria>

<when_to_split>
Splitting one document into two spends one of the two loads, so split only when the cut earns it.
- Split by sequence where the post-completion steps tempt the agent to rush the current one. Keeping them out of view drives more legwork on the current task. The reverse also holds. Merging sequences exposes each step to the steps after it and invites premature completion.
- Split by invocation, which applies only to skills and is described in [SKILL-MECHANICS.md](references/SKILL-MECHANICS.md).
</when_to_split>

<leading_words>
A leading word is a compact concept from the model's pretraining. The agent thinks with it while it runs the document. Examples are "lesson", "fog of war", and "tracer bullets". Repeat it as a token, never as a sentence. It then gathers a distributed definition and anchors a whole region of behavior in few tokens. It works because it recruits priors the model already holds. Coining your own word works if you define it clearly. A made-up word recruits no priors, though, so you pay in definition tokens what a pretrained word gives free. Reach for an existing word first.

A leading word anchors twice. In the body it anchors execution. The agent reaches for the same behavior every time the word appears. Inside flat reference, the word focuses attention on a class of thing to look for. In a pointer it anchors invocation. The same word may live in your prompts, docs, and codebase. The agent then links that shared language to the material and reaches it more reliably.

Hunt for chances to refactor with leading words. Typical candidates are a triad spelled out at three sites, or a pointer that spends a sentence on one idea. Each such passage can collapse into a single token, as these two examples show.
- "Fast, deterministic, low-overhead" becomes "tight", as in a tight loop.
- "A loop you believe in" becomes "red". That turns a fuzzy gate into a binary observable state. The loop either goes red on the bug or it does not.

You win twice, with fewer tokens and a sharper hook for the agent's thinking. Assume every document carries restatements that leading words could retire, and go find them.

<negation>
Negation is the failure mode beside this lever. Steering by prohibition drags the forbidden behavior into context and makes it more available, not less. Tell someone not to think of an elephant, and the elephant is all there is. The negation is a weak modifier that the strongly activated concept overruns. So the ban half-reads as an instruction to do the thing. Prompt the positive instead. State the target behavior, as in "write one-line comments," so the banned one is never spoken. A prohibition earns its place only as a hard guardrail you cannot phrase positively. Even then, pair it with the positive target and give its reason, so attention lands on what to do.
</negation>
</leading_words>

<pruning>
Four habits keep a document lean.
- Keep each meaning in a single source of truth, so changing a behavior is a one-place edit. Duplication costs maintenance and tokens. It also lifts a meaning's prominence on the ladder past its real rank. Duplication is the accidental inverse of a leading word, which repeats a token on purpose, never the meaning.
- Treat the environment as a source of truth too. That covers `package.json` scripts, config files, the directory layout, and `--help` output. A document that restates it is a cache, meaning a copy of a lookup. A cache earns its load only when the lookup is expensive. Cache what the agent cannot find by looking. Examples are an unwritten convention, the reason behind a choice, or a gotcha no config reveals. Leave one-file and one-command lookups to the environment, where they cannot go stale.
- Check every line for relevance to what the document does. A line loses relevance when it never bears on the task. Mere exposition and a branch that belongs behind a pointer are such lines. It also loses relevance when the behavior or world it describes changes. Without a pruning habit, stale layers settle as sediment, because adding feels safe and removing feels risky.
- Hunt no-ops sentence by sentence. A no-op is an instruction the model already obeys by default, so it pays load to say nothing. The test asks whether the sentence changes behavior against the default. That test is relative to the model, not the reader. So settle a dispute by running the document, not by debate. When a sentence fails, delete the whole sentence rather than trim its words.
</pruning>

<emphasis>
Current models follow instructions closely, so emphasis overcorrects. Capitals, "CRITICAL", "MUST", and pressure such as "be thorough, do not be lazy" make a model over-trigger and act rigidly. A hedge such as "try to" on a real requirement reads as permission to skip it. State each rule once at normal volume, with its reason beside it. A word too weak to beat the default is a no-op, so delete it. An example is "be thorough" for an agent that is already thorough. Choose a stronger word, such as "relentless", only when a run shows the default falls short. Trigger text in a description is the one place where calibrated urgency can help, because skills tend to under-trigger.
</emphasis>
