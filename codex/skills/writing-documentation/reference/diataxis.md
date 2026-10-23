# Diátaxis document types

The wording follows diataxis.fr, so check that site when a detail matters. Adjacent types tend to blur, and tutorials and how-to guides collapse into each other most often.

## Tutorial

A lesson that takes a beginner to a complete, working result. It states the goal at the start, uses concrete steps in a fixed order with a visible result early and often, shows the expected output at each stage, warns about surprising output and likely mistakes, and ends by naming what the learner built. It leaves out explanation beyond a sentence, options and alternatives, and abstraction. Every step works for every reader every time, so run the whole tutorial from a clean environment before publishing. Diátaxis suggests "we" in tutorials, and this skill uses "you" to match the Google style guide.

## How-to guide

Steps toward a goal the reader already has. The title names the goal exactly, as in "Deploy the app to staging". The steps include the judgement the reader has to make, with forks such as "If you want x, do y", and fit real situations rather than one tidy case. Teaching, explanation, and complete option lists stay on their own pages behind links, and trivial actions are left out. Practical usability beats completeness.

## Reference

Neutral, factual description of the machinery, such as commands, options, configuration keys, endpoints, classes, limits, and error messages. Every entry of one kind has the same layout, and the structure mirrors the product, such as one page per command or module. Examples stay short. Instructions, explanation, opinion, and stylistic flair stay out, because reference is read in fragments.

## Explanation

Why things are the way they are, with design decisions, history, constraints, trade-offs, alternatives, and reasoned judgement. The title reads naturally after an implied "About", as in "About caching". A single "why" question sets the edges of the page. Steps move to a how-to guide and exhaustive description to reference. Architecture decision records belong to the recording-architecture-decisions skill.

## Common files

| File | Type | Notes |
|---|---|---|
| `README.md` | Landing page | Links to pages of every type and holds only a short quickstart |
| `CONTRIBUTING.md` | How-to guide | Setting up, running tests, and submitting changes |
| Migration or upgrade guide | How-to guide | One goal, with old and new code side by side |
| `CHANGELOG.md` | Reference | Notable changes per version |
| API reference pages | Reference | One layout per endpoint, class, or command |
| Getting started lesson | Tutorial | One complete path for a beginner |
| Design or concept pages | Explanation | Why the system works the way it does |

When the project groups docs by type, use `docs/tutorials/`, `docs/how-to/`, `docs/reference/`, and `docs/explanation/`. Keep an existing layout.

## Splitting a mixed page

1. Label each paragraph with the compass.
2. Keep only the content of the type most of the page serves.
3. Move every other block to an existing page of its type, or to a new page when none exists.
4. Replace each moved block with a descriptive link to its new place.
5. Check that every page still makes sense on its own and that no fact now lives in two places.
