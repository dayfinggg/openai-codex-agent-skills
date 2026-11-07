<when_to_explore>
Explore `node_modules` to learn what the project really runs. Typical reasons are an installed version, a dependency tree, a conflict, or the internals of a package. The installed code is the ground truth that the `investigate_first` block asks you to check.
</when_to_explore>

<package_versions>
Read `node_modules/<name>/package.json` with the file-reading tool to get the installed version. A scoped package lives at `node_modules/@scope/<name>/package.json`. `npm ls` shows the version from the dependency tree.

```bash
npm ls pino
```

The same `package.json` names the entry points in `main` and `exports`, and the type definitions in `types` or `typings`. DefinitelyTyped packages live under `node_modules/@types/`.
</package_versions>

<package_manager_layouts>
npm and yarn classic hoist dependencies to the top of `node_modules`. In this layout, `sonic-boom` sits next to `pino` although only `pino` depends on it.

```
node_modules/
  pino/
  sonic-boom/
  @types/node/
```

pnpm keeps each package in a content-addressable store under `.pnpm` and links it into place. A package then sees only its declared dependencies.

```
node_modules/
  .pnpm/
    pino@10.0.0/
      node_modules/
        pino/
        sonic-boom/
  pino -> .pnpm/pino@10.0.0/node_modules/pino
```

Check the lockfile to know which layout applies. `package-lock.json` means npm, `yarn.lock` means yarn, and `pnpm-lock.yaml` means pnpm.
</package_manager_layouts>

<readmes>
Read a package README at its known path instead of searching the whole tree. A search through `node_modules` is slow and floods the output.

1. Read `node_modules/<name>/README.md`, then `readme.md` and `README` if the first is missing.
2. If none exists, list `node_modules/<name>/` and read the file with the exact name you find.
3. Check `docs/README.md` or the `readme` field in `package.json` as a last step.
</readmes>

<dependency_trees>
npm explains why a package is installed and prints the tree. `npm find-dupes` lists packages that deduplication could merge.

```bash
npm why lodash
npm ls --all
npm ls --omit=dev
npm find-dupes
```
</dependency_trees>

<conflicts>
A peer dependency conflict shows in the `peerDependencies` field of the plugin's `package.json`. Compare it with the installed version.

```bash
npm ls react
```

When the same package is installed several times, `npm ls` shows each copy and the dependent that pulled it in.

```bash
npm ls lodash
```
</conflicts>

<package_internals>
List the package folder and read its source files directly to understand how it works. Start from the entry point that `exports` or `main` names.

```bash
ls node_modules/pino/lib/
```
</package_internals>

<module_resolution>
Node.js shows how it resolves a module. `require.resolve` follows the `require` condition, and `import.meta.resolve` follows the `import` condition of `exports`.

```bash
node -e "console.log(require.resolve('pino'))"
node --print "require.resolve.paths('pino')"
node --input-type=module -e "console.log(import.meta.resolve('pino'))"
```
</module_resolution>
