# Choose NestJS deliberately

Choose NestJS when module ownership, DI conventions, guards, pipes, and filters reduce team coordination cost.
Use plain Node, Express, or Fastify when a smaller explicit pipeline is easier to explain and operate.
Do not add dynamic modules, global providers, request scope, or custom decorators without a current use.
Keep domain logic free of Nest metadata so a provider can be tested or reused directly.
Use the official cats sample as a concrete reference for a controller, DTO, guard, parse pipe, and service delegation. [Nst11]
