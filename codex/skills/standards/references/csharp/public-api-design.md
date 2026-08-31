# Public API design

- Design from the top caller scenarios; write the intended call-site before committing the public shape.
- Keep the public surface small, discoverable, and stable; every public member creates compatibility and documentation cost.
- Accept the least-derived input type that provides the needed operations and return a useful, appropriately specific type.
- Validate public and protected arguments, including enum values that may contain undefined underlying integers.
- Keep related overloads consistent in parameter order, names, cancellation behavior, and exception behavior.
- Prefer a single options object or cohesive record when many parameters travel together; avoid multiple Boolean switches.
- Use properties for cheap state without surprising side effects; use methods for work, conversion, expensive computation, or observable effects.
- Expose fields only for deliberate constants or immutable data; use properties to preserve implementation freedom.
- Make inheritance, virtual members, interfaces, and extension points intentional rather than accidental.
- Preserve an existing synchronous API when adding a separate asynchronous counterpart unless a breaking change is explicitly approved.
- Document ownership, threading, nullability, cancellation, disposal, ordering, and performance assumptions that callers must know.
