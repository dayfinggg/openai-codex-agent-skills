# Architecture

- Model the application as a tree of components, each combining a TypeScript class, an HTML template, and a selector.
- Keep rendering, inputs, outputs, and user interaction in components; move reusable business logic and data access into services.
- Build new applications with standalone components, directives, and pipes.
- Standalone components declare their template dependencies in the component `imports` array.
- A standalone component may import another standalone declaration or an existing `NgModule`.
- Do not add `standalone: true` to new v19+ declarations because standalone is the default; retain `standalone: false` only for deliberate NgModule compatibility.
- Bootstrap with `bootstrapApplication` from `src/main.ts` and place application providers in `app.config.ts`.
- Keep routes in a typed `app.routes.ts` file and configure the router with `provideRouter`.
- Use route-level providers when a service should live only for a feature or route.
- Treat `NgModule` as an interoperability and migration boundary, not as a reason to reorganize new code around modules.
- Components default to `ChangeDetectionStrategy.OnPush` in Angular v22.
- Use `ChangeDetectionStrategy.Eager` when legacy behavior is required, and do not rely on the deprecated `Default` name in new code.
- Zoneless change detection is the default from Angular v21 onward, so state changes must use Angular-notifiable APIs.
- SSR, SSG, hydration, and client-only rendering are rendering strategies; choose per product needs rather than by framework fashion.
