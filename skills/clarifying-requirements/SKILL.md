---
name: clarifying-requirements
description: Turns a request into a short agreed specification before any work starts. Use when the user asks for something new, such as a feature, a page, an app, a report or an integration, when a request leaves open what to build, for whom, in which format, on which platform or with which behaviour, when it names a goal without a way to tell that it is done, or when the user asks to plan, design or scope something.
---

# Clarifying requirements

The goal is a short specification that you and the user both hold, reached with as few questions as possible. Work starts as soon as it exists.

## Find what is open

Read the project before you ask anything. The files, the manifest, the tests and the history answer most questions about language, structure, conventions and tooling, and a question the files could answer wastes the user's turn.

List every decision the request leaves open. Sort the list into two groups. The first group changes what gets built, such as the format of a result, where data lives, which platform or audience is meant, what happens in a case the request does not cover. When the user asks for something new and names only the kind of thing, what it does for its users, which parts it includes and which it leaves out belong to the first group. The second group is small and easy to change later, such as names, layout, defaults. Decide the second group yourself and record each choice as an assumption. The first group is empty only when the request and the project already answer it. Then start the work without a question and state the assumptions in the report.

## Ask once

Ask the first group in a single call of the `request_user_input` tool, or of `request_user_input_async` when only that one is available. The first tool takes up to three questions, so merge or drop until the list fits. Give each question two or three concrete options, put the option you recommend first, and say in the option what it leads to. A question that offers only "yes" and "no" usually hides a better question about which of two designs is wanted.

A decision in the first group stays the user's when a usual way to build the thing exists. Offer the usual way as the option you recommend. An instruction about how to work, such as to follow best practice, to do it properly or to check the result, leaves the first group open. So does the research that you did before asking. It makes the options better, and the question still goes to the user.

When neither tool is available, do not stop. Take the most likely reading, say which reading you took, and continue.

## State the specification

After the answers, state the specification in the reply and move straight to the work. It has five parts in this order. The goal in one sentence. What is in scope. What is out of scope. The acceptance criteria, each one a statement that a command, a test or a look at the result can confirm. The assumptions you made.

Wait for approval of the specification only when the user asked to approve a plan first. Write it to a file only when the user asks for a document.

## Gotchas

A long interview is a failure of this skill. If more than three decisions seem open, most of them belong to the second group.

No question at all is the opposite failure. A request that names only the kind of thing, such as an app, a page, a report or an integration, leaves the first group open.

Do not ask about a choice and then make it yourself anyway. Either it matters and you ask, or it does not and you decide.

An acceptance criterion such as "works correctly" confirms nothing. Name the input and the expected result.

## Related skills

Once the specification is agreed, load the skills for the work itself, such as `clean-code`, `writing-tests` and `verifying-work`.
