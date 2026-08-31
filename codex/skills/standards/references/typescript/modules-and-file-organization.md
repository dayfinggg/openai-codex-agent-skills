# Modules and file organization

- Use ES module `import` and `export` syntax for new code unless an external runtime requires another form. [S11][S12]
- Make every source file's module status intentional; avoid relying on accidental script globals.
- Match module resolution to the runtime or bundler, including package `exports`, conditions, and file extensions. [S11]
- Do not assume that TypeScript `paths` aliases rewrite runtime imports; configure the runtime or bundler separately. [S11]
- Prefer relative imports for files in the same logical project when that is the repository convention. [S23]
- Limit long chains of parent imports because they obscure ownership and make moves expensive. [S23]
- Avoid namespaces, triple-slash references, and `import = require` in application code unless interoperability requires them. [S12]
- Organize files around a cohesive domain or feature, not a growing catch-all `utils` directory.
- Keep a file's imports, types, implementation, and tests easy to locate without artificial section ordering.
- Place a type beside its implementation until sharing or ownership gives it a clearer home.
- Use a small public entry module for a package and keep implementation modules private by default.
- Add an index or barrel only when it expresses a deliberate public boundary.
- Remove unused imports and avoid side-effect imports except for explicit initialization contracts.
- Use `.mts`, `.cts`, or repository-specific extensions only when the package's module semantics require them.
