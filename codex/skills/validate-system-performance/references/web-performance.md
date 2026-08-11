# Web performance validation

**Reviewed:** 2026-08-11
**Scope:** Core Web Vitals and current browser performance APIs. Project browser support and product budgets remain authoritative.

## Conditions

- Record browser and version, device or CPU class, viewport, network and latency, cache state, navigation type, geographic path, content and account state, extensions, and build artifact.
- Distinguish lab data from field data. Lab tools control conditions while field data represents real users with aggregation and sampling limitations.
- Test cold and repeat navigation only when both matter. Preserve authentication, consent, service worker, and CDN behavior representative of users.

## Signals

- Measure LCP, INP, and CLS using current definitions and supported tooling. Also inspect server response, resource waterfalls, JavaScript execution, long tasks, rendering, memory, bundle transfer and parse cost, image behavior, and third-party work as applicable.
- Attribute regressions to route, component, resource, interaction, or backend behavior with traces and profiles rather than guessing.
- Verify visual, functional, and accessibility equivalence. Deferring required content or interaction is not a valid performance improvement.
- Use field percentiles and segment by meaningful bounded dimensions when data exists. Do not compare different populations as if they were the same experiment.

## Official sources

- [Core Web Vitals](https://web.dev/articles/vitals)
- [Web Vitals measurement](https://web.dev/articles/vitals-measurement-getting-started)
- [MDN Web performance](https://developer.mozilla.org/en-US/docs/Web/Performance)
- [Performance Timeline](https://www.w3.org/TR/performance-timeline/)
