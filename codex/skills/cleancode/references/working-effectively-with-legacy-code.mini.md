These rules come from Working Effectively with Legacy Code by Michael Feathers. They show how to change code safely when tests and clear structure are missing.

<when_to_use>
Use them when code is expensive to change safely. Typical causes are unclear behavior, weak or missing tests, and hidden dependencies. Runtime or framework setup that blocks fast feedback is another cause.
</when_to_use>

<primary_bias>
Gain control before you improve the design. Understand the current behavior, and protect what must stay. Create the smallest useful seam, and break the dependency that blocks feedback. Then make the requested change, and leave the area more testable.
</primary_bias>

<legacy_change_loop>
Each legacy change follows these steps in order.
1. Identify the change point.
2. Check which tests already protect it.
3. Add characterization tests where possible.
4. Find or create a seam.
5. Break the dependency that blocks the test.
6. Change the behavior.
7. Refactor the changed code locally.
</legacy_change_loop>

<decision_rules>
- Treat any area without trustworthy tests as legacy code. Do not start with a rewrite or module-wide cleanup unless it is required or clearly safer.
- Before you edit, state the requested behavior change and the current behavior that must remain. Characterize uncertain or suspicious behavior instead of fixing it silently.
- Prefer fast, focused tests around the slice you change. Use broader interception or integration tests only when they are the safest first observation point.
- Choose test points by tracing effects outward from the change point. Follow values, calls, fields, outputs, and collaborators to interception points and pinch points.
- Use the smallest seam that allows substitution, observation, or interception. Make clear whether the seam serves sensing, separation, or both.
- Break dependencies deliberately, and only where they block a test or a safe change. Typical targets are hidden inputs, hard outputs, hard construction, globals, statics, ambient context, and framework callbacks.
- Keep behavior changes, structural refactors, and cleanup separate. Verify small steps, and do not commit restructuring done only to understand the code.
- When a direct edit is risky, add behavior with sprout method, sprout class, wrap method, or wrap class. Extract and override also works. Fold the temporary structure into a better design once tests support it.
- For a hard-to-test method, apply the testability rules of the `design` skill in small steps. Carve out pure computation first. Then isolate policy from runtime, persistence, UI, and framework code.
- Pick the dependency-breaking technique by the actual barrier. Options include adapt parameter, extract interface, extract implementer, parameterize constructor, and parameterize method. Others are encapsulate global references, introduce instance delegator, and override a factory or call. Use link or preprocessor seams only when object seams are impractical.
- In large code, sketch the effects and group responsibilities before you move behavior. Excessive setup, impossible observation, and repeated changes point to responsibilities to extract.
- In review, flag modified logic without tests and mixed structural and behavioral edits as legacy-change risks. Also flag broad edits in poorly understood modules, hard-coded collaborators, and global or static reach-through. Constructor side effects and business logic trapped in framework entry points are risks too.
- Reject changes that expand hidden dependencies or mock around untestable structure without improving it. Also reject renames and formatting that leave the real dependency knots intact. Large architecture before basic seams exist is another reason to reject.
- Leave the code you changed easier to understand, test, or change, within the scope of the task. Test-only seams, wrappers, subclass tricks, and build tricks are not design improvements by themselves.
</decision_rules>

<trigger_rules>
- When behavior is uncertain, callers may rely on ugly behavior, or a path is hard to prove, observe it first. Add characterization tests or another explicit observation path before you change semantics.
- When tests need too much setup, or a class cannot be built cheaply, break the first real barrier. Typical barriers are constructor work, hidden allocation, factory calls, global state, static construction, framework objects, and hard parameters.
- When time, randomness, environment, current user, files, network, or database writes block repeatable tests, wrap or inject that boundary. Thread-local state, process exits, messages, and control-flow logging count as such boundaries too.
- When you change database-heavy, UI, framework, or API-boundary code, separate policy from queries, mapping, persistence, handlers, and runtime setup. Keep integration tests at the real boundaries where they matter.
- When a seam is magical, temporary, public for tests, or based on subclass, link, or preprocessor tricks, plan its removal. Remove it once safer structure exists, or name it in the report.
- When repeated edits cluster across several places, remove the duplication step by step under tests. Do not launch a broad redesign.
- When a rewrite or heroic cleanup tempts you, choose the smallest step that makes today's change safer. Sprout, wrap, seam, characterization, and small refactors are such steps.
</trigger_rules>

<final_checklist>
- Is the untested or weakly tested area treated as a legacy risk?
- Are the behavior change and the behavior to preserve stated?
- Is uncertain current behavior characterized or observed?
- Are the tests close enough and fast enough to diagnose the change?
- Is the seam the smallest useful one, with sensing or separation clear?
- Is the blocking dependency reduced without new hidden dependencies?
- Are behavior change, refactoring, and cleanup separate?
- Does each temporary seam or trick have a removal path?
- Is the changed code easier to understand, test, or change?
</final_checklist>
