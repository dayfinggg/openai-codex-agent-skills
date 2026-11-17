# JavaScript language features and runtimes

This reference adapts selected material from Google Chrome Modern Web Guidance 1.0. The compatibility facts in the source are a snapshot dated 2026-11-17; check current runtime support and official specifications for the project's actual target.

## Syntax and built-ins

- Separate syntax support from runtime APIs. A compiler may lower syntax to an older target without supplying a built-in such as a new collection method or Temporal.
- Identify the oldest supported browser, Node.js, or other runtime from the repository's policy, CI, deployment image, and build configuration. Do not raise that target just to use a newer feature unless the user or project scope calls for it.
- For an unsupported built-in, choose a documented fallback, a suitable polyfill, or a deliberate runtime-target change. Use feature detection when support varies at runtime.
- Check stage and browser support for newer ECMAScript proposals. A proposal appearing in a draft or an implementation preview is not a production guarantee.

## Iterators and collections

- Iterator helpers are lazy and may be single-use. Materialize a result when it must be reused.
- Set methods expect a Set-like value, not necessarily an array. Convert collections where the method signature requires it.
- `Array.fromAsync` processes values in sequence. Use bounded parallel work when independent asynchronous operations may run concurrently.
- Check Unicode behavior before counting or slicing user-visible text. JavaScript string indices count UTF-16 code units, not necessarily grapheme clusters.

## Date and time

Use the type that matches the domain. A timestamp is an instant, a meeting in a location needs an IANA time zone, and a birthday or store hour is a local date or time without a time zone. Check daylight-saving ambiguity, calendar behavior, overflow, precision, and serialization requirements before choosing an API.

Use the project's supported Temporal implementation only after confirming runtime and compiler support. Otherwise use the existing date-time library or a justified polyfill. Do not convert a zone-free local date-time into a zoned event without an explicit product rule.

## Verification

Check target browsers or runtimes from authoritative compatibility data, then run the relevant tests on supported engines where practical. If the environment cannot represent the oldest supported runtime, report that limit rather than inferring support from compilation.
