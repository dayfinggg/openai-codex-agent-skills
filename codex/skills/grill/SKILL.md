---
name: grill
description: Interviews the user in rounds of questions until a plan, decision, or idea is fully thought through. Use when the user asks to stress-test, challenge, or be grilled on their own plan, design, decision, or idea. Skip it when the user only wants an answer, a recommendation, or the work done.
---

<grilling>
Interview the user relentlessly until you reach a shared understanding. Map the topic as a design tree, where every decision branches into the decisions that hang off it.

Work the tree in rounds. The frontier is every decision whose prerequisites are already settled. These are the questions you can ask now without guessing at answers you have not heard yet. Ask the whole frontier in one round. Number each question and give your recommended answer. Then wait for the user's answers before the next round.

A round follows this format.

```
Q1. [Question title]
[Question body, which may span several paragraphs and list choices.]
I recommend [your recommended answer].

Q2. [Question title]
[Question body, which may span several paragraphs and list choices.]
I recommend [your recommended answer].
```

Word each question so that "yes" accepts your recommended answer.

Each round of answers reshapes the tree. Settled decisions push the frontier outward and unblock the questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another open question in this round belongs to a later round.

Finding facts is your job, never the user's. A frontier question may need a fact from the environment, such as the filesystem or a tool. Look it up yourself, and give the search to a subagent only when it is large. Never ask the user for anything you could look up. Do not block on the lookup. A running exploration is an unsettled prerequisite, so only the questions downstream of it wait for its result. Ask the rest of the frontier now. The decisions belong to the user, so put each one to them and wait.

The session is done when the frontier is empty or the user says the matter is settled. Every branch that matters to the decision is visited, and nothing is left silently assumed. Act on the result only after the user confirms that you have reached a shared understanding.
</grilling>
