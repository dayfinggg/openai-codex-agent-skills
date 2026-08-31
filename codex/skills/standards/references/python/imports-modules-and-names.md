# Imports, modules, and names

- Put imports after the module docstring and future imports, before executable module code.
- Group imports as standard library, third party, and local application code.
- Put a blank line between import groups and keep imports sorted by the project's tool.
- Prefer absolute imports; use explicit relative imports when they make a package layout clearer.
- Avoid wildcard imports because they hide the module's namespace and defeat static tools.
- Import modules when a qualified name improves provenance or avoids a local name collision.
- Keep module import time cheap and deterministic; do not perform network, file, or registration work implicitly.
- Put executable behavior in `main()` behind `if __name__ == "__main__":`.
- Keep each module centered on one concept, layer, or cohesive group of related operations.
- Treat circular imports as a design signal; fix dependency direction instead of adding import tricks.
- Keep `__init__.py` small and intentional; re-export only stable public names.
- Use `__all__` when a module deliberately defines a public export surface.
- Use namespace packages only when multiple distributions intentionally contribute to one namespace.
