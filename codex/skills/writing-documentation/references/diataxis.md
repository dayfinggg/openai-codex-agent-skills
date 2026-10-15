# Diátaxis document types

Diátaxis divides documentation into four types, each serving one need of the reader. Use it to decide what a page is for, what belongs on it, and what moves to another page. The wording here follows diataxis.fr, so check that site when a detail matters.

## Contents

- The compass
- Tutorial
- How-to guide
- Reference
- Explanation
- Common files and their types
- Splitting a mixed page

## The compass

Ask two questions of a whole page or of a single sentence.

1. Does the content inform action, meaning practical steps and doing, or cognition, meaning theoretical knowledge and thinking?
2. Does it serve the acquisition of skill, meaning study, or the application of skill, meaning work?

| Content informs | Serves | Type | Oriented to | Form |
|---|---|---|---|---|
| Action | Acquisition | Tutorial | Learning | A lesson |
| Action | Application | How-to guide | Goals | A series of steps |
| Cognition | Application | Reference | Information | Dry description |
| Cognition | Acquisition | Explanation | Understanding | Discursive explanation |

Rephrase the questions to fit the situation, and do not get stuck on the exact names. The compass helps most when something about a page feels wrong. Adjacent types tend to blur, and in the worst case tutorials and how-to guides collapse into each other until neither serves its reader.

## Tutorial

A tutorial is a lesson that takes a beginner through a complete, working result.

Contains
- The goal at the start, so the learner sees where the steps lead.
- Concrete steps in a fixed order, each with a visible result early and often.
- The expected output at each stage, and warnings about surprising output or likely mistakes.
- Prompts that point out what the learner should notice.
- A short acknowledgment of what the learner built at the end.

Avoids
- Explanation beyond a sentence. Link to an explanation page instead.
- Options and alternatives, because they distract from reaching the end.
- Abstraction, generalization, and lists of information.

Every step must work for every reader every time, because the author is not there to help. Run the whole tutorial from a clean environment before publishing it. Diátaxis suggests "we" in tutorials, and this skill uses "you" to stay consistent with the Google developer documentation style guide.

## How-to guide

A how-to guide helps a reader who already knows what they want to achieve and needs the steps to get there.

Contains
- A title that names the goal exactly, as in "Deploy the app to staging".
- A logical sequence of steps, including the judgement the reader has to make, with forks such as "If you want x, do y".
- Enough flexibility to fit the reader's real situation, not only one tidy case.

Avoids
- Teaching, digression, and explanation. Link to them.
- Complete lists of options. Link to the reference page.
- Instructions for trivial actions the reader already knows.
- Walking the reader through the tool's features instead of toward their goal.

Prefer practical usability over completeness.

## Reference

Reference describes the machinery, such as commands, options, flags, configuration keys, API endpoints, classes, limits, and error messages.

Contains
- Neutral, factual description of behavior, with warnings where needed.
- A consistent, predictable layout, repeated for every entry of the same kind.
- A structure that mirrors the structure of the product, such as one page per command or per module.
- Short examples that show usage in context.

Avoids
- Instructions, explanation, opinion, and speculation. Link to how-to guides and explanation pages.
- Stylistic flair. Reference is read in fragments and should be austere.
- Examples that grow into tutorials.

## Explanation

Explanation helps the reader understand why things are the way they are.

Contains
- Context such as design decisions, history, constraints, and trade-offs.
- Connections to related topics, alternatives, and counter-examples.
- Reasoned judgement, as in "X fits better than Y here, because ...".
- A title that reads naturally after an implied "About", as in "About caching" or "About connection pooling".

Avoids
- Step-by-step instructions. Move them to a how-to guide.
- Exhaustive technical description. Move it to reference.
- Unbounded scope. Let a single "why" question define the edges of the page.

Architecture decision records also explain why, and the recording-architecture-decisions skill owns them.

## Common files and their types

| File | Type | Notes |
|---|---|---|
| `README.md` | Landing page | Links to pages of every type and holds only a short quickstart |
| `CONTRIBUTING.md` | How-to guide | Setting up, running tests, and submitting changes |
| Migration or upgrade guide | How-to guide | One goal, moving from one version to the next, with old and new code side by side |
| `CHANGELOG.md` | Reference | A record of notable changes per version |
| API reference pages | Reference | One layout per endpoint, class, or command |
| Getting started lesson | Tutorial | One complete path for a beginner |
| Design or concept pages | Explanation | Why the system works the way it does |

When a project groups docs by type, use folders such as `docs/tutorials/`, `docs/how-to/`, `docs/reference/`, and `docs/explanation/`. Keep the existing layout when the project already has one.

## Splitting a mixed page

1. Read the page and label each paragraph with the compass.
2. Pick the type most of the page serves and keep only that content.
3. Move every other block to an existing page of its type, or to a new page when none exists.
4. Replace each moved block with a descriptive link to its new place.
5. Check that every page still makes sense on its own and that no fact now lives in two places.
