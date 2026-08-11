# Swift

Honor the Swift and platform versions, package or Xcode settings, the closest `.swift-format`, SwiftLint configuration, formatter version, concurrency checks, and test framework. Run the repository command first. With Swift 6's toolchain formatter use `swift format lint --strict path/to/File.swift`; with the separately selected executable use `swift-format lint --strict path/to/File.swift`. Use the form and version declared by the repository and do not mix formatters.

The Swift project explicitly states that `swift-format` output is one possible style, not a universal Swift default. When the repository has selected `swift-format`, its effective configuration is the mechanical gate. When no formatter or configuration is selected, use this skill's local fallback: four-space indentation, spaces rather than tabs, and the line-width row in [code shape and naming](code-shape-and-naming.md). Use that reference unchanged for function, type, file, nesting, complexity, and parameter thresholds.

Follow [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/) and project terminology so calls read clearly at the use site. Use `UpperCamelCase` for types and protocols and `lowerCamelCase` for functions, methods, properties, variables, enum cases, and parameters. For a file centered on one type, use `UpperCamelCase.swift` matching that type only when package precedent permits it. Otherwise name the file for its responsibility using the package's case convention. Preserve `Package.swift`, generated sources, Objective-C bridge names, resource lookup names, and Xcode or SwiftPM target paths.

Prefer value types unless identity or shared mutable state is required. Model absence with optionals, failures with appropriate throwing or result-based APIs, and state variants with enums. Avoid force unwraps, forced casts, implicitly unwrapped optionals, and broad mutable global state in retained code.

Use structured concurrency, propagate cancellation, isolate mutable shared state with actors or another explicit mechanism, and satisfy `Sendable` where values cross concurrency domains. Keep UI work on the required actor without masking background blocking work.

Preserve ownership and resource lifecycle across Objective-C, C, and platform-framework boundaries. Evaluate source and binary compatibility for public packages and frameworks before changing signatures, conformances, or serialized data.

Primary references: [The Swift Programming Language](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/), [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/), [`swift-format`](https://github.com/swiftlang/swift-format), and [Swift.org documentation](https://www.swift.org/documentation/).
