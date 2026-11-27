---
name: clarifying-requirements
description: Turns an open request into a short agreed specification with one round of questions. Use when the user asks for something new, such as a feature, page, app, report or integration, asks to plan, design or scope work, or leaves open what to build, its format, platform, audience or behaviour, or how to tell it is done. Use before the first edit or build step of a request for something new or open-ended.
---

# Clarifying requirements

## Find what is open

1. Read the project first. The manifest, files, tests and history settle language, structure, conventions and tooling, so questions cover only what the files cannot answer.
2. Look up what the documentation and the standards recommend for this kind of thing. A recommendation you do not plan to follow becomes an open decision.
3. Sort the open decisions into two groups.
   - Decisions that change what gets built, such as the format of the result, where data lives, the platform or audience, and behaviour in cases the request does not cover. When the request names only the kind of thing, such as "an app" or "a report", what it does, includes and leaves out belong here, also when a usual way to build it exists.
   - Small choices that are easy to change later, such as names, layout and defaults. Decide these yourself.
4. When the request and the project already settle the first group, start the work and name the main assumption in one sentence of the final answer.

## Ask once

The question tool takes up to four questions with two to four options each, so merge or drop questions until they fit. More than four open decisions usually means most are small choices you can make. Each option says what it leads to, and an option that falls short of the documentation or the standards says so. Turn a yes-or-no question into a choice between the two designs it hides.

An instruction about how to work, such as "do it properly", leaves the first group open, and your own research improves the options while the decision stays with the user. Once you ask about a choice, build what the user picked.

When no question tool is available, do not ask in chat. Build on the most likely reading and name that reading in one sentence of the final answer.

## State the specification

After the answers, state in a few plain sentences the goal, what is in and out of scope, the acceptance criteria and the assumptions, then start the work. Each acceptance criterion names an input and the expected result that a command, a test or a look at the result confirms, because "works correctly" confirms nothing.

Wait for approval only when the user asked to approve a plan first, and write the specification to a file only when the user asks for a document.
