# Bootstrap and module graph

Create the application from one root module and keep bootstrap responsible for process wiring.
Use feature modules to group related controllers, providers, ports, adapters, and policies.
Nest builds its dependency graph from modules and uses the root module as the application entry point. [Nst1]
Treat a module's exported providers as its public API.
Import the module that owns a capability instead of reaching into its private providers. [Nst1]
Avoid making every module global; global modules reduce visible coupling only when used sparingly. [Nst1]
Keep configuration, database clients, queues, and external SDKs in providers with explicit lifecycle ownership.
Prefer constructor injection so required dependencies are visible and replaceable in tests. [Nst2]
Do not create providers manually inside controllers when Nest can resolve them.
Use request scope only when request identity or isolation requires it.
Remember that request-scoped classes do not receive application lifecycle hooks. [Nst3]
