# Templates

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
