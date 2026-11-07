<logic_prototype>
A logic prototype is a single, self-contained HTML file that lets anyone drive a state model by clicking buttons. Use it when the question is about business logic, state transitions, or data shape. Such things look reasonable on paper but only feel wrong once you push them through real cases.

The file has nothing to install, so the user can hand it to a non-developer. A designer, a PM, or a domain expert can then feel the model for themselves. So the demo speaks their language, not the code's.
</logic_prototype>

<when_it_fits>
This shape fits questions like these.
- "I'm not sure if this state machine handles the edge case where X then Y."
- "Does this data model actually let me represent the case where..."
- "I want to feel out what the API should look like before writing it."
- Anything where someone wants to press buttons and watch state change.

If the question is "what should this look like," this is the wrong branch. Use [UI.md](UI.md).
</when_it_fits>

<process>
<state_the_question>
Before you write code, write down the state model and the question it explores. Put that one paragraph in a visible intro at the top of the demo. A logic prototype that answers the wrong question is pure waste. An explicit question lets the user check it later, whether they watch now or return to it afterward.
</state_the_question>

<isolate_the_logic>
Put the logic that answers the question in a single `<script>` block. Write it as a small, pure module that could later move into the real codebase. The page around it is throwaway, but this module is not.

The right shape depends on the question.
- A pure reducer, `(state, action) => state`, fits when actions are discrete events and state is a single value.
- A state machine with explicit states and transitions fits when the question includes "which actions are legal right now?"
- A small set of pure functions over a plain data type fits when there is no current state, only transformations.
- A class or module with a clear method surface fits when the logic owns ongoing internal state.

Pick the shape that fits the question, not the one easiest to wire to a page. Keep the module pure, with no DOM, no `document`, and no button handlers inside it. The page calls into the module, and nothing flows the other way. This purity keeps the prototype useful after its question is answered. The validated reducer, machine, or function set then moves into the real module as it is.
</isolate_the_logic>

<build_the_html_file>
Build one file of plain HTML, CSS, and JS. Use no framework, no bundler, and no server, and inline everything. The file then opens by double-click and survives being emailed around.

Write it for a non-developer. Every label uses domain language, so buttons and state read like the business, not the reducer. Explain in plain words what is happening.

Lay it out top to bottom in four parts.
1. A title and a one-line explanation of what the demo lets you explore, which is the question from the intro.
2. The current state, as a readable panel of labeled fields, not a raw JSON dump. Re-render it after every click so the change is visible. Where it helps a non-developer, call out what just changed.
3. Free-play buttons, one per action and always available, so anyone can poke at the model in any order. Each click dispatches its action and re-renders the state.
4. Guided walkthroughs, one scenario per tab. Each tab holds a short plain-language description of the situation and what to watch for. Under it sit the ordered buttons to press for that scenario. Each step is a real button that performs its action and moves to the next step. Starting a walkthrough resets to a known initial state, so the scenario runs the same way every time.

Choose scenarios that show the awkward cases, the ones hard to reason about on paper. Cover the happy path, a tricky edge case, and an attempt at something that should be illegal.

Keep it clean but restrained, with clear typography, generous spacing, and one accent color. Leave out animations and gimmicks, because nothing should compete with the state and the buttons.
</build_the_html_file>

<hand_it_over>
Give the user the file's absolute path, or open it for them. They click through the walkthroughs and free-play when they get to it. The interesting moments come when they say "wait, that shouldn't be possible" or "huh, I assumed X would be different." Those are the bugs in the idea, which is the whole point. If they want new actions or a new scenario, add them.
</hand_it_over>

<capture_the_answer>
Once the prototype has answered its question, capture the answer as [SKILL.md](../SKILL.md) describes. The validated reducer, machine, or function set moves into the real module when the user wants that. The HTML shell stays in the scratchpad, or wherever the user asks to keep it. As one self-contained file, it stays easy to re-run.
</capture_the_answer>
</process>

<anti_patterns>
Six habits break a logic prototype.
- Adding tests turns it into something other than a prototype.
- Wiring it to the real database adds risk without need. Use in-memory state unless the question is about persistence.
- Generalizing for "what if we wanted to support X later" dilutes it. The prototype answers one question.
- Blurring the logic and the page together makes the module impossible to lift out. A module that references the DOM, `document`, or button handlers is no longer liftable. Keep the page a thin shell over a pure module.
- A framework, bundler, or server defeats "shareable". The recipient double-clicks one file, and a React app or a dev server cannot work that way.
- Shipping the HTML shell into production misuses it. The page suits hand clicking, and only the logic module behind it is worth keeping.
</anti_patterns>
