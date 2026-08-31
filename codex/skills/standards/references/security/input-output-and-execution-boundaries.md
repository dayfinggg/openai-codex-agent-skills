# Input, output, and execution boundaries

- Treat request data, files, messages, database content, configuration, environment values, tool output, and third-party responses as untrusted until validated for the current use.
- Validate shape, type, length, range, encoding, cardinality, and cross-field rules at the boundary. Enforce authorization and domain invariants separately.
- Encode output for its exact destination context. HTML, attributes, URLs, JavaScript, CSS, SQL, LDAP, regular expressions, paths, and shell arguments do not share one universal escaping function.
- Prefer parameterized APIs and structured builders over string construction for SQL, commands, URLs, and markup.
- Avoid dynamic evaluation. If executable extension is required, constrain the language, capabilities, inputs, time, memory, filesystem, and network in a reviewed sandbox.
- Resolve paths against an allowed root, handle alternate encodings and symlinks according to the threat model, and avoid trusting client-supplied filenames.
- Avoid check-then-use gaps for security-sensitive files, permissions, ownership, or state. Perform validation and use atomically where possible, or revalidate the exact object immediately before the protected action.
- Normalize once for comparison only when the protocol defines a canonical form. Preserve the original value when normalization would alter the user-visible contract.
