# Architectural model

- Build a component tree from the interface and its visual states before deciding where state belongs. [Thinking in React](https://react.dev/learn/thinking-in-react)
- Build the static UI with props first, then add the smallest state model that makes interaction possible. [Thinking in React](https://react.dev/learn/thinking-in-react)
- Keep data flow explicit from parent to child and use callbacks for deliberate inverse flow. [Thinking in React](https://react.dev/learn/thinking-in-react)
- Treat a component as a pure function of props, state, and context that returns JSX.
- React updates the screen through trigger, render, and commit phases; a render does not imply a DOM mutation. [Render and commit](https://react.dev/learn/render-and-commit)
- Keep render calculations pure, deterministic, and free of mutations to objects owned by another render. [Keeping components pure](https://react.dev/learn/keeping-components-pure)
- React may call render logic more than once in development or concurrent work, so render code must be safe to restart.
- Keep side effects in event handlers or Effects, never as incidental work during render.
- Use one responsibility per meaningful boundary and separate UI composition from business rules when the split clarifies ownership. Do not create mandatory layers without a current need.
- Keep business rules and request orchestration out of a component when they obscure the component's rendering responsibility.
- Prefer a narrow hook, service, or adapter boundary only when it gives the behavior a clear owner and focused tests.
