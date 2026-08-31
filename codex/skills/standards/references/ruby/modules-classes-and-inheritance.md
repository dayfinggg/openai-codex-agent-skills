# Modules, classes, and inheritance

- Use a module for a namespace or for a coherent mix-in protocol, not as a miscellaneous utility drawer.
- Give a mix-in a small API and document the host methods, state, and callbacks that it requires.
- Include a module only when the receiver genuinely satisfies the module's behavior, not merely because a helper is convenient.
- Prefer an object or a namespaced module over adding methods to `Object`, `Kernel`, or unrelated core classes.
- Do not reopen a class or module that the project does not own; use an adapter, decorator, or explicit refinement instead.
- Keep constants under the namespace that owns them, and avoid ambiguous top-level constants.
- Keep one primary class or module per file when the project layout permits it.
- Name a file with the snake-case form of its primary constant.
- Make visibility explicit when a method is part of an internal implementation.
- Keep public methods above private helpers unless the repository uses another consistent layout.
- Use `extend` for class-level behavior only when the module's class contract is intentional and tested.
- Avoid class variables and module-level mutable state because they blur ownership and inheritance behavior.
- Use inheritance to share a substitutable contract, not just to reuse a few lines of implementation.
- Prefer explicit delegation over callbacks that silently modify the host class.
