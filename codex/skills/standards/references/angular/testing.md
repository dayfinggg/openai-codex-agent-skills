# Testing

- New Angular CLI projects use Vitest with `jsdom`; run `ng test` locally and in CI with watch mode disabled.
- Test a component as class plus template when DOM rendering, inputs, outputs, or user interaction matters.
- Use `TestBed.createComponent` and await `fixture.whenStable()` before asserting asynchronous rendering.
- Test services, pure transformations, validators, and signal derivations without rendering when DOM behavior is irrelevant.
- Provide fakes or test doubles through DI rather than reaching into private implementation details.
- Use `RouterTestingHarness` with real route configuration to test navigation, guards, parameters, and rendered routed components.
- Create component harnesses for shared interactive widgets; keep one-off page tests direct and focused.
- In zoneless tests, prefer Angular notifications and `whenStable()` over forcing every update with `detectChanges()`.
- Run unit, route, accessibility, and critical browser-flow tests before a major upgrade.
