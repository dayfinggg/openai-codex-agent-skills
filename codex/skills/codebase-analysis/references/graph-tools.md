# Dependency graph and unused-code tools

Version snapshot dated 2026-11-17. Check the installed tool and current documentation before using these examples. Commands use the shell shown in each code block; translate quoting and pipelines when the active shell differs. Examples assume project-managed tools are installed; do not let a package runner download a tool unless task scope and dependency policy allow it.

## Commands

| Stack | Graph as data | Who depends on a module |
|---|---|---|
| JS, TS | dependency-cruiser 18.7: `npx depcruise src test --output-type json` | `--reaches '^src/billing/invoice\.ts$'`, or `--affected <base>` for modules changed since `<base>` plus all that reach them |
| JS, TS | madge 8.0: `npx madge --extensions ts,tsx --ts-config tsconfig.json --json src` | `--depends <id> --json`, with the id as `--json` prints it |
| JS, TS | knip 6.45: `npx knip --reporter json` | `--trace-file <path>` or `--trace-export <name>` |
| pnpm workspace | `pnpm --filter "...<pkg>" run typecheck` runs a script in the package and every package that depends on it | `"...^<pkg>"` selects the dependents only, `"...[origin/main]"` the changed packages and their dependents |
| Python | pydeps 3.0: `pydeps <pkg> --show-deps --no-output --max-bacon 0` prints `imports` and `imported_by` per module | grimp 3.20, below |
| Rust | `cargo metadata --format-version 1 --locked` | `cargo tree -i <crate> --workspace --target all` |
| Go | `go list -json ./...` with `Imports`, `TestImports` and `XTestImports` per package | the packages whose three lists contain the target |
| PHP | deptrac 4.7 with a `deptrac.php`: `vendor/bin/deptrac debug:dependencies <Layer> <TargetLayer>` prints one class dependency per line with `file:line` | the same with the layers swapped |
| Java, Kotlin | `jdeps -R --class-path '<libs>/*' --dot-output <dir> <jars-or-classes>` | `jdeps --inverse --package <pkg> --class-path '<libs>/*' <jars-or-classes>` |

Modules that import `pkg.billing`, directly or not, from grimp in the project environment (import-linter 2.16 installs it, otherwise add `--with grimp` after `uv run`):

```bash
uv run python -c 'import grimp; g = grimp.build_graph("pkg"); print(sorted(g.find_downstream_modules("pkg.billing", as_package=True)))'
```

## Traps

- Without `--ts-pre-compilation-deps` (or `tsPreCompilationDeps: true` in the config), dependency-cruiser drops `import type` consumers from the graph. Without `--ts-config tsconfig.json`, path-alias imports do not resolve.
- dependency-cruiser `--reaches` and `--affected` find dependents only inside the paths you cruise. Pass `src`, `test`, `scripts` and every workspace package. `--affected` with no revision compares with `main`. Without a config, add `-X '^node_modules'` so the cruise stops at packages.
- madge reads only `.js` files from a directory by default (`fileExtensions: ['js']`), so a TypeScript tree gives an empty graph without `--extensions ts,tsx`. It needs `--ts-config` for path aliases and skips files it cannot resolve, which only `--warning` lists.
- knip reports a file as unused when no entry file reaches it, which missing generated files, dynamic import specifiers and a missing plugin also cause. Fix the entry and plugin config before trusting the list. Exit code 1 means issues were found, 2 means knip failed.
- pydeps given a script sees only what the script imports, and given a package it includes every module in it. Its default `--max-bacon 2` drops modules more than 2 hops from the target, in `--show-deps` output too, and modules it cannot import are dropped unless `--include-missing`.
- grimp names direction by import flow: `find_downstream_modules` returns the modules that import the given one, `find_upstream_modules` what it imports. With `as_package=True` the result leaves out modules inside the given package. `build_graph` includes imports under `if TYPE_CHECKING:` unless `exclude_type_checking_imports=True`.
- `cargo tree -i` shows reverse dependencies only inside the current member's tree unless `--workspace`, only for the host platform unless `--target all`, and prints `(*)` for a subtree already shown (`--no-dedupe` repeats it). `cargo metadata` resolves features as the current package enables them and omits inactive optional dependencies.
- `go list` reports one build configuration, like gopls. Repeat it with other `GOOS`, `GOARCH` or `-tags` values for code behind build constraints. Test-only importers appear only in `TestImports` and `XTestImports`.
- deptrac `--formatter=json` reports rule violations, not the dependency graph. `debug:dependencies` covers only classes inside the layers the config defines.
- jdeps reads compiled classes, so build first. `-verbose:class` hides dependencies inside the same archive, and `--ignore-missing-deps` hides classes it could not resolve.
- pnpm `[<since>]` compares with the merge base since pnpm 12.7.0 and includes uncommitted changes.
