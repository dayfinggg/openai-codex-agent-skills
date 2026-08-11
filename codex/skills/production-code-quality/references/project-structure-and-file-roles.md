# Project structure and file roles

Use this reference only when creating, moving, renaming, exporting, or assigning a role to a retained file, module, package, test, migration, configuration, or generated artifact. A folder is not an architecture boundary by itself.

## Resolution workflow

1. Find the affected application or package root from its manifest and build entry points. Establish the language, framework, runtime, module resolver, generator, router, test discovery, ORM, and their effective versions.
2. Inspect scoped instructions, configuration, and several neighboring files with the same role. Check declarations, imports, exports, registration, tests, and generation commands rather than copying a basename alone.
3. Identify mechanically significant names before choosing a style. Route files, package entry points, generated paths, test suffixes, migration identifiers, autoloaded constants, and public import subpaths are contracts.
4. Prefer a coherent precedent in the same package or feature. When precedents conflict, use the official generator or documented default for the installed version. Do not mass-rename neighboring files to make the local choice look uniform.
5. Create a boundary only for a current responsibility, information-hiding need, data owner, trust boundary, deployment unit, team owner, or stable consumer contract. Do not introduce a package, layer, barrel, or `shared` directory only for visual symmetry.

## Ecosystem precedent

| Ecosystem | Recognized forms | Do not project into it |
| --- | --- | --- |
| NestJS or Angular TypeScript | Role suffixes such as `user.service.ts` or `users.service.ts`, `auth.controller.ts`, `users.module.ts`, `user.repository.ts`, `create-user.dto.ts`, and configured `.spec.ts` tests | Choose singular or plural base from the feature, symbol, generator, and local precedent. Do not create a role file unless its contents perform that role or wrap every ORM call by ceremony. |
| React without file routing | Component identifiers start uppercase. Filenames may be PascalCase or kebab-case according to package precedent | Do not infer a universal React filename case or Nest-style service grammar. |
| Next.js App Router | Preserve special names such as `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`, `not-found.tsx`, and `route.ts` plus route-group and private-folder syntax | Do not rename special files or add `.controller.ts`, `.module.ts`, or `.service.ts` as framework conventions. |
| Python and FastAPI | Importable lowercase modules, usually with underscores. Use local forms such as `users/service.py`, `services/users.py`, `user_service.py`, or small-package `services.py` | Do not create `user.service.py`. Do not mix transport schemas, ORM models, and domain objects just to shorten the tree. |
| Java or C# | The primary public type and filename commonly use forms such as `UserService.java` or `UserService.cs` in package or namespace folders | Do not translate the role into a TypeScript dot suffix. Preserve language rules linking public type and filename. |
| Go | Use short lowercase package names and cohesive files such as `service.go` or a more domain-specific name. Tests require `_test.go` | Do not copy class-oriented suffix systems or create packages named `utils` without a focused contract. |

For TypeScript role suffixes, interpret the suffix semantically:

- `.controller.ts` is a transport adapter, not the owner of persistence and core business rules.
- `.service.ts` is a cohesive application, domain-facing, or framework provider responsibility, not a default name for unrelated helpers.
- `.repository.ts` owns a real persistence port, adapter, or aggregate query contract. Do not add an empty pass-through layer for ceremony.
- `.module.ts` is a framework composition boundary such as Nest `@Module()`, not every ECMAScript module.
- `.schema.ts`, `.dto.ts`, and `.entity.ts` name distinct runtime-validation, transport, or persistence representations. Qualify `schema` when several schema kinds coexist.
- `.spec.ts`, `.test.ts`, `.e2e-spec.ts`, `test_*.py`, `*_test.py`, and `_test.go` follow the configured runner and local placement. Do not mix suffixes without a discovery or ownership reason.

## Ambiguous and misspelled names

Treat `lib.serivces.ts` as ambiguous and probably misspelled, not as precedent. Tokenize role-like suffixes and compare them with framework generators, nearby roles, exported symbol names, and the repository vocabulary. Check the current path, imports, public package exports, route discovery, and code generation before renaming an existing file.

Choose `lib.service.ts` only when one actual service and the ecosystem precedent support it. Choose `lib/services.ts`, `lib/services/index.ts`, or another aggregator name only when the file owns an aggregate or public boundary. If evidence cannot distinguish choices and a rename changes a public import or runtime contract, stop for the material decision. Do not copy a likely typo merely for local consistency, and do not silently repair a public path.

## Special file classes

- Create a barrel such as `index.ts` only for an intentional consumer-facing surface. Use explicit exports when the public API is controlled. Avoid same-folder barrel imports between Nest providers because they can introduce cycles.
- Keep tests where the configured runner and ownership precedent place that test kind. Separate integration, end-to-end, and contract environments when their lifecycle differs.
- Keep migrations with the owner of the data schema. Preserve tool-defined order and identifiers. Do not rename or edit an applied migration through an ordinary refactor.
- Preserve canonical configuration filenames and package-local policy. Do not move package-specific configuration to the repository root without a real shared contract.
- Distinguish scaffolded retained source, reproducibly derived output, and generated-but-reviewable migration history. Edit the source of truth for derived output and follow repository policy on committing it.

Primary basis: [Nest CLI](https://docs.nestjs.com/cli/usages), [Nest modules](https://docs.nestjs.com/modules), [Next.js project structure](https://nextjs.org/docs/app/getting-started/project-structure), [PEP 8 naming](https://peps.python.org/pep-0008/#naming-conventions), [FastAPI larger applications](https://fastapi.tiangolo.com/tutorial/bigger-applications/), [Google Java Style](https://google.github.io/styleguide/javaguide.html), [Microsoft C# naming](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/identifier-names), [Go code organization](https://go.dev/doc/code), [Node package entry points](https://nodejs.org/api/packages.html#package-entry-points), and [Prisma migration histories](https://www.prisma.io/docs/orm/prisma-migrate/understanding-prisma-migrate/migration-histories).
