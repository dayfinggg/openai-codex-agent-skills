# Architecture and API style

- Use Vue's declarative, component-based model instead of manual DOM mutation.
- Prefer Single-File Components for build-tool projects; keep template, logic, and styles close when that improves comprehension. [V1]
- Use Composition API with `<script setup>` for new full applications unless an existing module has a deliberate Options API convention. [V1][V3]
- Treat a component tree as the UI composition boundary, with clear input, output, and ownership of rendered markup. [V2]
- Prefer one-way data flow: pass state through props and report intent through emitted events.
- Use slots when a parent owns content structure but a child owns layout or behavior.
- Keep business rules independent of Vue where practical so they can run in a plain unit test.
- Keep pages and root components orchestration-focused rather than turning them into a second domain layer.
- Use Options API for low-complexity progressive enhancement or established code that already depends on it.
