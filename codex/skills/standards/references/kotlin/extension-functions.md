# Extension functions

Use an extension when behavior naturally belongs to a receiver but the receiver's source cannot or should not be changed.
An extension does not add a member, state, or override point to the receiver type.
Remember that extension dispatch is static and uses the receiver's declared type; a real member takes precedence over an extension with the same signature.
Do not use an extension to imply dynamic polymorphism or access private receiver state.
Use an extension for a pure conversion, query, adapter, or small domain operation with an obvious receiver.
Keep side effects visible in the name and call site instead of hiding I/O in a generic extension.
Define a nullable-receiver extension only when its null behavior is useful and unsurprising.
Place broadly useful extensions with the type they serve, and client-specific extensions next to that client.
Avoid a catch-all `Utils.kt` file and avoid making dozens of unrelated types appear to share one API.
Use a member or a dedicated service when the operation needs injected dependencies, mutable state, or a lifecycle.
