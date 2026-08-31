# Modules and package boundaries

- Use ECMAScript modules with `import` and `export` for new code when the runtime and toolchain support them. [J1][J2]
- Mark Node packages explicitly with `"type": "module"` or `"type": "commonjs"`; use `.mjs` and `.cjs` for file-level exceptions. [J3][J4]
- Use complete file extensions for relative and absolute ESM specifiers, including directory indexes. [J4]
- Keep ordinary imports and exports static so the dependency graph is visible to readers and tools.
- Use dynamic `import()` only for a real lazy, optional, or runtime-selected dependency, and handle its rejection.
- Prefer named exports for public APIs unless an established project convention or one conceptual default clearly justifies a default export. [J5]
- Treat imported bindings as read-only views, and do not expose mutable module state without an explicit ownership contract. [J2][J5]
- Keep import-time work minimal. Put network, filesystem, DOM, timers, and registration behind explicit functions when possible.
- Avoid cyclic imports. Merge the concepts, move shared code to a lower-level module, or introduce a deliberate inversion at the boundary. [J2][J5]
- Define a package's public entry points with `exports` and export every supported subpath explicitly. [J3]
- Do not make consumers deep-import private files that are absent from `exports`.
- Choose either extensioned or extensionless package subpaths and use one spelling consistently. [J3]
- For dual ESM and CommonJS packages, use conditional exports, test both loaders, and provide a `default` branch when possible. [J3]
- Import Node built-ins with the `node:` scheme in Node-specific modules. [J4]
- The maintained `p-map` package demonstrates explicit `type`, `exports`, `engines`, `sideEffects`, and test metadata in `package.json`. [J16][J29]
- The MDN `js-examples` repository provides executable module examples for named exports, aggregation, dynamic imports, and top-level `await`. [J6]
