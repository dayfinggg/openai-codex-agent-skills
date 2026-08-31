# Size and cohesion heuristics

There is no universal line-count limit for a Kotlin class or file.
Kotlin's conventions encourage colocating declarations that are semantically close while keeping a file to a reasonable size, described as no more than a few hundred lines.
Split a file when readers need separate mental models, when declarations change for different reasons, or when unrelated imports dominate.
Keep a sealed hierarchy and its small data alternatives together when that makes all cases visible at a glance.
Keep an extension with its receiver when the extension is part of that receiver's normal vocabulary; keep client-only adapters with the client.
Split a class when it owns multiple lifecycles, requires many unrelated dependencies, or needs unrelated fixtures to test its methods.
Keep a function to one coherent operation and introduce named helpers when nesting or branching hides the operation's contract.
Use expression bodies for genuinely single-expression functions, not to compress multi-step logic into a hard-to-read line.
Organize class members by reading flow and related behavior rather than alphabetically.
Let cohesion, dependency direction, testability, and change isolation decide when to split or combine code.
