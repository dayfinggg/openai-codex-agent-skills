---
name: prototype
description: Builds a throwaway prototype that answers one design question. Use when the user wants to check whether a state model, business rule, or data shape feels right before building. Use when the user wants to compare designs for a page, screen, or component before committing to one.
---

<overview>
A prototype is throwaway code that answers a question. The question decides the shape.
</overview>

<pick_a_branch>
Identify which question the prototype answers, from the user's prompt or the surrounding code. Ask if the user is present and the prompt does not settle it.
- "Does this logic or state model feel right?" leads to [LOGIC.md](references/LOGIC.md). It builds a single shareable HTML file with free-play buttons and tabbed guided walkthroughs. That file pushes the state model through cases that are hard to judge on paper. A non-developer can drive it.
- "What should this look like?" leads to [UI.md](references/UI.md). It generates several radically different UI variations on a single route. A URL search param and a floating bottom bar switch between them.

Read the matching file before you build. The two branches produce very different artifacts, so the wrong pick wastes the whole prototype. If the question stays ambiguous and the user is away, pick the branch that matches the surrounding code. A backend module points to logic, and a page or component points to UI. State that assumption at the top of the prototype.
</pick_a_branch>

<rules_for_both>
Six rules apply to both branches.
1. The prototype is throwaway from day one and clearly marked as such. Its files live in the session's scratchpad or a temporary directory, unless the user wants them in the repository. A UI prototype runs inside the app, so its variants go in the repository. There they follow the project's routing convention and carry `prototype` in their names. Tell the user which repository files the prototype adds.
2. It is trivial to run. A UI prototype starts with one command in the project's task runner, such as `pnpm <name>`, `python <path>`, or `bun <path>`. A logic demo is a single HTML file the user double-clicks.
3. It has no persistence by default, so state lives in memory. Persistence is the thing a prototype may check, not something it depends on. If the question involves a database, use a scratch database or a local file. Give it a clear "PROTOTYPE, wipe me" name.
4. It skips the polish. It has no test suite, no error handling beyond what keeps it runnable, and no abstractions. Run it once and use it yourself before you hand it over. The point is to learn something fast.
5. It surfaces the state. After every action (logic) or variant switch (UI), render the full relevant state. The user then sees what changed.
6. It ends with a captured answer. Report the verdict and the question it settled. Fold the validated decision into the real code when the user wants that. Then remove the prototype files from the main code. Keep them only where the user asks, such as a throwaway branch.
</rules_for_both>
