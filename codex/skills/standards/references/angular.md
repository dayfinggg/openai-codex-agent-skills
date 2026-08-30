# Angular engineering reference

This reference targets the Angular v22.1 documentation baseline checked on 2026-08-30.
Use the documentation for the exact Angular version in the project when a behavior is version-sensitive.

## Architecture

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

## Standalone composition and loading

- Import only the declarations a template uses so the dependency graph stays visible and tree-shakable.
- Prefer the built-in `@if`, `@for`, and `@switch` blocks over legacy structural syntax in new templates.
- Use `loadComponent` for a lazy page and `loadChildren` for a lazy route tree.
- Keep the main landing page eager when its immediate availability outweighs the initial bundle cost.
- Lazy-load secondary features, and measure whether nested lazy boundaries add more requests than value.
- Use `@defer` for non-critical standalone components, directives, pipes, and their component styles.
- Give deferred content a stable placeholder, loading state, and error state when users can observe the transition.
- Do not defer above-the-fold content without preserving its dimensions, because replacement can cause layout shift.
- Import a deferred component directly rather than through a barrel when a separate lazy chunk matters.
- Keep NgModule-based third-party dependencies at the boundary until the library offers a standalone-compatible API.

## Signals and RxJS

- Use `signal` for writable synchronous state and read it by calling the signal getter.
- Use `computed` for pure derived state; computed signals are lazy, memoized, and track only signals read by the derivation.
- Use `linkedSignal` when derived state must remain writable and reset or reconcile when its source changes.
- Use `effect` only for imperative side effects such as logging or synchronizing a non-reactive API.
- Do not use an effect to copy state, derive state, or create a second source of truth; use `computed` or restructure the state instead.
- Expose shared writable state as a readonly signal and expose mutation through named methods.
- Prefer immutable object and array updates so OnPush input comparisons observe changed references.
- Read signals before an `await` when the read must be tracked; reactive tracking does not cross an asynchronous boundary.
- Use RxJS for event streams, cancellation, time-based composition, WebSockets, and APIs that already expose Observables.
- Keep an Observable as an Observable when stream operators express the behavior more clearly than signal state.
- Use the `async` pipe for a template-only Observable and let Angular manage its subscription.
- Use `toSignal` once at a component or service boundary when imperative code or a template needs a current value.
- `toSignal` subscribes immediately and cleans up with the creating context, so do not call it repeatedly for the same Observable.
- Use `toObservable` when a signal must enter an RxJS pipeline, and remember that stabilized signal changes emit asynchronously.
- Use `takeUntilDestroyed` for subscriptions that cannot be expressed with `async`, `toSignal`, or another lifecycle-aware API.
- Treat `resource` or `httpResource` as optional signal-based async boundaries; use explicit loading and error states.

## Dependency injection

- Inject dependencies instead of constructing them in consumers so implementations can be replaced in tests and features can stay decoupled.
- Prefer `inject()` in field initializers, matching the Angular style guide and improving type inference.
- Call `inject()` only in an Angular injection context, such as a component, service, provider factory, guard, or route loader.
- Use `@Service()` for a new root singleton that uses `inject()` and needs no advanced provider configuration.
- Keep `@Injectable({providedIn: 'root'})` for constructor injection, non-root scopes, `useClass` or `useFactory` configuration, and libraries supporting older Angular versions.
- Use `InjectionToken` for configuration values, functions, and other non-class dependencies.
- Remember that Angular resolves an element injector tree before the environment injector tree.
- Provide at the narrowest intentional scope: root for application-wide state, route for feature state, and component for isolated instances.
- A component provider creates an instance for that component and its descendants, not for parents or siblings.
- Avoid hidden singleton state when a route or component lifetime is the real ownership boundary.

## Templates

- Treat a template as compiled HTML with interpolation, property or attribute binding, event statements, variables, pipes, and control flow.
- Bind DOM properties with `[property]`, attributes with `[attr.name]`, and events with `(event)`.
- Use two-way binding only when the component API intentionally models a value and its change together.
- Name event handlers for the action they perform, such as `saveUser()` rather than `handleClick()`.
- Keep template expressions short and side-effect free; move complex transformations into named methods or `computed` signals.
- Use `@for (item of items; track item.id)` with a stable unique key whenever a collection can change.
- Use `@empty` to provide an explicit empty state for a repeated collection.
- Use `@let` when a long expression needs a local name and a single evaluation within a template scope.
- Prefer direct `class` and `style` bindings over `ngClass` and `ngStyle` for simpler syntax and lower directive overhead.
- Mark members used only by a template as `protected`, and mark Angular-initialized inputs, outputs, models, and queries `readonly`.
- Keep `strictTemplates: true` and strict TypeScript checks enabled so bindings, event types, nullability, and local references are checked.
- Use AOT in production, and never generate or compile Angular templates from user-controlled strings.
- Angular v22 aligns template optional chaining with JavaScript by returning `undefined`; avoid relying on a `null` versus `undefined` distinction.

## State boundaries

- Keep ephemeral view state, such as an open panel or pending selection, in the owning component.
- Keep state shared by sibling or routed components in a narrowly scoped service with a small public API.
- Keep server state near its data-access boundary and represent loading, success, empty, and error states explicitly.
- Put durable navigation state in route parameters or query parameters so links and reloads preserve intent.
- Prefer one authoritative writable signal or Observable for each piece of state.
- Derive filters, counts, labels, and view models instead of storing duplicate copies.
- Introduce a global store only when cross-feature coordination, persistence, devtools, or replay justify its cost.
- Do not put HTTP calls, subscriptions, or DOM code in a `computed` derivation.

## Performance and rendering

- Profile first with Angular DevTools or the Angular track in Chrome DevTools, then optimize the measured bottleneck.
- Let OnPush skip unchanged subtrees, and notify Angular through signal reads, template events, input updates, `AsyncPipe`, or `markForCheck`.
- Avoid expensive function calls, allocations, and unbounded work in templates or lifecycle hooks.
- Use a stable `track` key and immutable collection updates for large or frequently changing lists.
- Lazy-load secondary routes and defer below-the-fold or interaction-only code to reduce initial JavaScript.
- Use `NgOptimizedImage` for application images, prioritizing the LCP image and lazy-loading non-critical images.
- Consider SSR or SSG for content that needs a fast first paint or search indexing, and enable hydration to reuse server DOM.
- Keep server and client DOM identical during hydration; avoid direct DOM mutation and browser globals in shared render paths.
- Use `afterNextRender` or `afterEveryRender` for browser-only work and prefer platform providers over template platform checks.
- In zoneless applications, connect reactive-form or third-party Observable updates to a signal or an explicit change notification.
- Remove ZoneJS only after testing all libraries and both production and test bootstraps; legacy zone-dependent code may need migration.

## Accessibility

- Start with semantic HTML and native controls because their keyboard and assistive-technology behavior is already defined.
- Give every form control a programmatic label and every meaningful image useful alternative text.
- Use Angular attribute bindings for dynamic ARIA values, and prefer native semantics over adding a role that duplicates them.
- Manage focus, keyboard interaction, disabled states, and announcements as part of the component contract.
- Use Angular CDK `a11y` utilities for focus trapping and live announcements when implementing custom widgets.
- Use Angular Aria for headless WAI-ARIA patterns when custom styling is needed, or Angular Material for styled components.
- Test keyboard-only flows, focus order, zoom or reflow, screen-reader names, and error announcements with real browsers.
- Wrap observable deferred state in an appropriate live region when a screen reader must hear placeholder-to-content changes.

## File organization

- Put application UI code under `src`, bootstrap in `src/main.ts`, and keep build or tooling configuration outside `src`.
- Organize by feature or user-facing domain, not by global `components`, `services`, or `directives` buckets.
- Co-locate a component's TypeScript, template, styles, and spec files in the feature directory.
- Use hyphenated file names that match the primary TypeScript symbol, such as `user-profile.ts` and `user-profile.spec.ts`.
- Keep one concept per file and split a directory when navigation becomes difficult.
- Avoid generic `utils.ts`, `helpers.ts`, and `common.ts` files; name a file for the concept it owns.
- Keep `app.config.ts` for application-wide providers and `app.routes.ts` for route declarations.

## Testing

- New Angular CLI projects use Vitest with `jsdom`; run `ng test` locally and in CI with watch mode disabled.
- Test a component as class plus template when DOM rendering, inputs, outputs, or user interaction matters.
- Use `TestBed.createComponent` and await `fixture.whenStable()` before asserting asynchronous rendering.
- Test services, pure transformations, validators, and signal derivations without rendering when DOM behavior is irrelevant.
- Provide fakes or test doubles through DI rather than reaching into private implementation details.
- Use `RouterTestingHarness` with real route configuration to test navigation, guards, parameters, and rendered routed components.
- Create component harnesses for shared interactive widgets; keep one-off page tests direct and focused.
- In zoneless tests, prefer Angular notifications and `whenStable()` over forcing every update with `detectChanges()`.
- Run unit, route, accessibility, and critical browser-flow tests before a major upgrade.

## Migration-safe simplicity

- Prefer stable public Angular APIs over private internals, experimental features, and framework-wide custom abstractions.
- Keep Angular core and CLI majors aligned, and update one supported major at a time with `ng update`.
- Read the versioning page and changelog before upgrading; deprecated APIs remain for at least one major release, but removal occurs only in a major release.
- For an NgModule application, run the standalone schematic in order: convert declarations, remove unnecessary modules, then switch bootstrap APIs.
- Build, test, lint, format, and review the diff after each migration step rather than batching unrelated edits.
- Preserve NgModule interop when a library or team boundary still needs it; migration is optional and can be incremental.
- For older components that depend on eager checks, make `ChangeDetectionStrategy.Eager` explicit instead of relying on an old default.
- Keep public component inputs and outputs narrow and typed so future refactors do not require callers to understand internals.
- Prefer direct composition, explicit imports, and one source of truth over clever base classes or global flags.
- Record the Angular version and browser or SSR assumptions near unusual compatibility code, then delete the workaround when its migration aid is no longer needed.

## Sources

### Official Angular documentation and RFCs

1. [Angular overview](https://angular.dev/overview) and [Angular v22 release](https://angular.dev/events/v22).
2. [Versioning and releases](https://angular.dev/reference/releases) and [Angular roadmap](https://angular.dev/roadmap).
3. [Angular style guide](https://angular.dev/style-guide), [component anatomy](https://angular.dev/guide/components), and [file structure](https://angular.dev/reference/configs/file-structure).
4. [Standalone migration](https://angular.dev/reference/migrations/standalone) and the Angular team’s [standalone RFC](https://github.com/angular/angular/discussions/43784).
5. [Angular templates](https://angular.dev/guide/templates), [control flow](https://angular.dev/guide/templates/control-flow), [template variables](https://angular.dev/guide/templates/variables), [expression syntax](https://angular.dev/guide/templates/expression-syntax), and [template type checking](https://angular.dev/tools/cli/template-typecheck).
6. [Signals](https://angular.dev/guide/signals), [linked signals](https://angular.dev/guide/signals/linked-signal), [async resources](https://angular.dev/guide/signals/resource), and the Angular team’s [signals and RxJS RFC](https://github.com/angular/angular/discussions/49681).
7. [RxJS interop](https://angular.dev/ecosystem/rxjs-interop), [takeUntilDestroyed](https://angular.dev/ecosystem/rxjs-interop/take-until-destroyed), and [Angular’s signal examples](https://github.com/angular/skills/blob/main/angular-developer/references/signals-overview.md).
8. [Dependency injection](https://angular.dev/guide/di), [services](https://angular.dev/guide/di/creating-and-using-services), and [hierarchical injectors](https://angular.dev/guide/di/hierarchical-dependency-injection).
9. [Lazy-loaded routes](https://angular.dev/best-practices/performance/lazy-loaded-routes), [deferred loading](https://angular.dev/guide/templates/defer), and [performance](https://angular.dev/best-practices/performance).
10. [OnPush subtree skipping](https://angular.dev/best-practices/skipping-subtrees), [zoneless change detection](https://angular.dev/guide/zoneless), and the Angular team’s [OnPush RFC](https://github.com/angular/angular/discussions/66779).
11. [Server-side rendering](https://angular.dev/best-practices/performance/ssr) and [hydration](https://angular.dev/guide/hydration).
12. [Accessibility in Angular](https://angular.dev/best-practices/a11y) and [Angular Aria](https://angular.dev/guide/aria).
13. [Testing overview](https://angular.dev/guide/testing), [component testing basics](https://angular.dev/guide/testing/components-basics), and [routing tests](https://angular.dev/guide/routing/testing).
14. [Component harnesses](https://angular.dev/guide/testing/component-harnesses-overview) and [creating harnesses](https://angular.dev/guide/testing/creating-component-harnesses).

### Angular team and community examples

15. Angular team and community examples: the archived, unofficial [Angular Signals codelab](https://github.com/angular/codelabs/tree/signals-get-started), [Angular documentation examples](https://github.com/angular/angular/tree/main/adev/src/content/examples), and the [v21 game-world example](https://angular.dev/events/v21).

### Traceable talks

16. Traceable talks: [Rethinking reactivity with Angular Signals](https://www.youtube.com/watch?v=EIF0g9LDHcQ), [What’s new in Angular v22](https://www.youtube.com/watch?v=h5OJUSS_8IA), and the [Google I/O 2023 program](https://io.google/2023/program/?hl=fr).
