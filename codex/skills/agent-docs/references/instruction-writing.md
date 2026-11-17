# Write instructions agents can apply

Use a short, precise trigger that names the task and the decision the linked text supports. Put shared rules and the finish condition in the entrypoint. Link each branch-specific reference directly from it, and put its opening condition before the link. A description is useful when it catches relevant tasks and does not also catch adjacent ones.

Order steps only when the order matters. Give each ordered step a checkable result. State the wanted behavior first, and keep an exception with the rule it limits. Use the strongest wording only for a real boundary. Reconcile conflicts with the project and adjacent skills instead of relying on a model to pick one. Keep a single source of truth, and use current commands, tests, and manifests rather than restating facts the agent can read.

When porting instructions, read the source and its license. Adapt tool calls, local paths, capabilities, permissions, and invocation controls to the target runtime. Keep license notices and attribution. Keep version-specific details behind references and check them against the installed version before using them.

Verify discovery in the target runtime, then exercise a representative trigger and a close miss when routing matters. Test the behavior the instruction is meant to change. A valid descriptor alone cannot show that the loaded rule is useful.
