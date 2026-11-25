---
name: clarifying-requirements
description: Turns a vague or underspecified request into a short agreed specification before any work starts. Use when a request leaves open what to build, for whom, in which format, on which platform or with which behaviour, when it names a goal without a way to tell that it is done, or when the user asks to plan, design or scope something.
---

# Clarifying requirements

The goal is a short specification that you and the user both hold, reached with as few questions as possible. Work starts as soon as it exists.

## Find what is open

Read the project before you ask anything. The files, the manifest, the tests and the history answer most questions about language, structure, conventions and tooling, and a question the files could answer wastes the user's turn.

List every decision the request leaves open. Sort the list into two groups. The first group changes what gets built: the format of a result, where data lives, which platform or audience is meant, what happens in a case the request does not cover. The second group is small and easy to change later: names, layout, defaults. Decide the second group yourself and record each choice as an assumption.

## Ask once

Ask the first group through the question tool in a single call. Keep the list short, and merge or drop questions that do not change what you build. Give each question two to four concrete options, put the option you recommend first, and say in the option what it leads to. A question that offers only "yes" and "no" usually hides a better question about which of two designs is wanted.

When no question tool is available, do not stop. Take the most likely reading, say which reading you took, and continue.

## State the specification

After the answers, state the specification in the reply and move straight to the work. It has five parts in this order. The goal in one sentence. What is in scope. What is out of scope. The acceptance criteria, each one a statement that a command, a test or a look at the result can confirm. The assumptions you made.

Wait for approval of the specification only when the user asked to approve a plan first. Write it to a file only when the user asks for a document.

## Gotchas

A long interview is a failure of this skill. If more than four decisions seem open, most of them belong to the second group.

Do not ask about a choice and then make it yourself anyway. Either it matters and you ask, or it does not and you decide.

An acceptance criterion such as "works correctly" confirms nothing. Name the input and the expected result.

## Related skills

Once the specification is agreed, load the skills for the work itself, such as `clean-code`, `writing-tests` and `verifying-work`.
