Compare genuinely different interfaces for the same requirement.
Establish caller needs, invariants, dependencies, and error behavior from the code.
Develop alternatives around different tradeoffs, such as a smaller interface, easier common use, or explicit dependency substitution.
For each alternative, show the caller-facing contract, a usage example, hidden implementation responsibilities, and the cost of change.
Use [DEEPENING.md](DEEPENING.md) when dependency placement affects testability.
Delegate independent alternatives only when the user and runtime permit it. Otherwise explore them yourself.
Recommend the alternative that best fits the actual callers and explain its main risk. Do not implement until authorized.
