This file covers how to deepen a cluster of shallow modules safely, given its dependencies. It uses the vocabulary of [SKILL.md](../SKILL.md), such as module, interface, seam, and adapter.

<dependency_categories>
Classify the dependencies of a candidate before you deepen it. The category decides how the deepened module is tested across its seam.

<in_process>
In-process dependencies are pure computation and in-memory state with no I/O. They can always be deepened. Merge the modules and test through the new interface directly, with no adapter.
</in_process>

<local_substitutable>
Local-substitutable dependencies have local test stand-ins, such as PGlite for Postgres or an in-memory file system. The module can be deepened if the stand-in exists. Its tests run the stand-in inside the test suite. The seam stays internal, with no port at the module's external interface.
</local_substitutable>

<remote_but_owned>
Remote but owned dependencies are your own services across a network, such as microservices or internal APIs. Following ports and adapters, define a port at the seam. A port is an interface. The deep module owns the logic, and the transport is injected as an adapter. Tests use an in-memory adapter, and production uses an HTTP, gRPC, or queue adapter.

A typical recommendation defines a port at the seam. Production gets an HTTP adapter, and tests get an in-memory adapter. The logic then sits in one deep module, even when it is deployed across a network.
</remote_but_owned>

<true_external>
True external dependencies are third-party services you do not control, such as Stripe or Twilio. The deepened module takes the external dependency as an injected port, and tests provide a mock adapter.
</true_external>
</dependency_categories>

<seam_discipline>
- One adapter means a hypothetical seam, and two adapters mean a real one. Do not add a port unless at least two adapters are justified, typically production and test. A seam with one adapter is just indirection.
- A deep module can have internal seams as well as the external seam at its interface. Internal seams stay private to the implementation and serve its own tests. Do not expose them through the interface just because tests use them.
</seam_discipline>

<testing_strategy>
New tests replace the old ones instead of adding a layer on top.
- Once tests at the deepened module's interface cover the behavior, the old unit tests on the shallow modules become waste. Delete them.
- Write the new tests at the deepened module's interface, because the interface is the test surface.
- Assert on observable outcomes through the interface, not on internal state.
- Tests should survive internal refactors, because they describe behavior and not implementation. A test that must change with the implementation is testing past the interface.
</testing_strategy>
