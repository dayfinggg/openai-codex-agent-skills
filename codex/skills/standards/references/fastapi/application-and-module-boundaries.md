# Application and module boundaries

- Keep `main.py` small and use it as the composition root for the `FastAPI` app, middleware, lifespan, and routers. [F1]
- Use one `APIRouter` per business capability or bounded route group.
- Apply a router's prefix, tags, common responses, and shared dependencies at the router boundary. [F1]
- Keep route modules focused on transport concerns and call application functions for business workflows.
- Keep domain code independent of `Request`, `Response`, `Depends`, and other FastAPI objects where practical.
- Use `Depends()` for authentication, authorization, database sessions, shared policy, and resource lifetime. [F2]
- Prefer `Annotated` dependency declarations so type information remains visible to editors and checkers. [F2]
- Avoid import-time database calls, network calls, and mutable global request state.
- Do not create controller, service, repository, and mapper layers by habit.
- Add an application service only when a use case spans entities, requires one transaction, or coordinates external effects.
