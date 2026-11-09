<contents>
This file has these sections, in order.
- ui prototype
- when it fits
- two sub shapes
- process
- anti patterns
</contents>

<ui_prototype>
A UI prototype generates several radically different UI variations on a single route, switchable from a floating bottom bar. The user flips between variants in the browser and picks one, or takes parts from each. Then the rest goes away.

If the question is about logic or state rather than looks, this is the wrong branch. Use [LOGIC.md](LOGIC.md).
</ui_prototype>

<when_it_fits>
This shape fits requests like these.
- "What should this page look like?"
- "I want to see a few options for this dashboard before committing."
- "Try a different layout for the settings screen."
- Any case where the user would otherwise spend a day choosing between three vague mockups in their head.
</when_it_fits>

<two_sub_shapes>
A UI prototype is much easier to judge when it sits against the rest of the app. That means the real header, real sidebar, real data, and real density. A throwaway route on its own is a vacuum, where every variant looks fine. So default to sub-shape A whenever a plausible existing page can host the variants. Use sub-shape B only if the prototype has no nearby home.

<sub_shape_a>
Sub-shape A adjusts an existing page, and it is the default. The route already exists, and a `?variant=` URL search param gates the variants on that route. The existing data fetching, params, and auth all stay, and only the rendering swaps.

Something without its own page may still belong inside one. Examples are a new dashboard section, a settings card, or a flow step. That is still sub-shape A, so mount the variants inside the host page.
</sub_shape_a>

<sub_shape_b>
Sub-shape B is a new page, and it is the last resort. Use it only when the prototyped thing has no existing page to live inside. Examples are a new top-level surface, or a flow that cannot be embedded anywhere sensible.

Create a throwaway route that follows the project's existing routing convention, without a new top-level structure. Name it so it is obviously a prototype, for example with the word `prototype` in the path or filename. It uses the same `?variant=` pattern.

Before you commit to sub-shape B, check again that no existing page could host it. An empty route hides design problems that a populated one would expose.
</sub_shape_b>

The floating bottom bar is the same in both sub-shapes.
</two_sub_shapes>

<process>
<state_the_question_and_pick_n>
Default to 3 variants. More than 5 stops being radically different and becomes noise, so cap there.

State the plan to the user in one line. An example is "Three variants of the settings page, switchable via `?variant=`, on the existing `/settings` route." This line works whether or not the user is present to push back.
</state_the_question_and_pick_n>

<generate_radically_different_variants>
Draft each variant against three constraints.
- It serves the page's purpose with the data the page has access to.
- It uses the project's component library or styling system, such as Tailwind CSS, shadcn/ui, MUI, or plain CSS.
- It has a clear exported component name, such as `VariantA`, `VariantB`, or `VariantC`.

Variants must differ in structure. They need different layouts, information hierarchy, and primary affordances, not just different colors. Three slightly tweaked card grids are wallpaper, not a UI prototype. If two drafts come out too similar, redo one with an explicit "no card grid" constraint.
</generate_radically_different_variants>

<wire_them_together>
Create a single switcher component on the route. This sketch shows the shape in React, so adapt it to the project's framework.

```tsx
const variant = searchParams.get('variant') ?? 'A';
return (
  <>
    {variant === 'A' && <VariantA {...data} />}
    {variant === 'B' && <VariantB {...data} />}
    {variant === 'C' && <VariantC {...data} />}
    <PrototypeSwitcher variants={['A','B','C']} current={variant} />
  </>
);
```

In sub-shape A, keep all the existing data fetching above the switcher, so only the rendered subtree changes per variant. In sub-shape B, the throwaway route under `/prototype/<name>` mounts the same switcher.
</wire_them_together>

<build_the_floating_switcher>
The switcher is a small fixed-position bar at the bottom center of the screen, with three pieces.
- A left arrow cycles to the previous variant and wraps around.
- A variant label shows the current variant key, plus the variant's exported name if it has one, as in `B (Sidebar layout)`.
- A right arrow cycles forward and wraps around.

Four behaviors complete it.
- Clicking an arrow updates the URL search param through the framework's router. The variant is then shareable and survives a reload. Examples are `router.replace` in Next.js and `navigate` in React Router.
- The left and right arrow keys also cycle. Leave arrow keys alone while an `<input>`, `<textarea>`, or `[contenteditable]` element has focus.
- The bar looks distinct from the page, for example as a high-contrast pill with a subtle shadow. Then nobody mistakes it for part of the design under review.
- Production builds hide it. Gate it on `process.env.NODE_ENV !== 'production'` or an equivalent check, so a stray prototype merge cannot ship the bar to users.

Put the switcher in a single shared component, so both sub-shapes can reuse it. Place it wherever shared UI lives in the project.
</build_the_floating_switcher>

<hand_it_over>
Give the user the URL and the `?variant=` keys. They flip through when they get to it. The most useful feedback is usually "I want the header from B with the sidebar from C." That mix is the design they actually want.
</hand_it_over>

<capture_the_answer_and_clean_up>
Once a variant has won, capture the answer, meaning which variant won and why, as [SKILL.md](../SKILL.md) describes. Fold the winner into the real code when the user wants that, and rewrite it properly as you do.
- In sub-shape A, fold the winner into the existing page. Remove the losing variants and the switcher.
- In sub-shape B, promote the winning variant to a real route. Remove the throwaway route and the switcher.

Variant components and a switcher left in the main code rot fast and confuse the next reader. If the user wants the full set kept as a record, keep it where they ask, such as a branch.
</capture_the_answer_and_clean_up>
</process>

<anti_patterns>
Four habits break a UI prototype.
- Variants that differ only in color or copy are a tweak, not a prototype. Real variants disagree about structure.
- Sharing too much code between variants defeats the point. A shared `<Header>` is fine, but a shared `<Layout>` is not. Each variant must be free to throw out the layout.
- Wiring variants to real mutations tests the wrong thing. Read-only prototypes are fine. If a variant needs to mutate, point it at a stub, because the question is about looks, not the backend.
- Promoting the prototype straight to production ships code written without tests and with minimal error handling. Rewrite it properly when you fold it in.
</anti_patterns>
