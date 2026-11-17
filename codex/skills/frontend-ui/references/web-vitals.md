# Core Web Vitals diagnosis

Check current metric definitions and thresholds in the official web.dev documentation before reporting a pass.

## Measure first

- Use field data at the required percentile and segment, when available, to establish whether a problem affects real users. Use a lab trace to reproduce a specific bottleneck.
- Record the page, device class, metric, percentile, and method. Do not claim a field improvement from one Lighthouse run.
- Use attribution or a browser performance trace to identify the largest contributor before changing code.

## Largest Contentful Paint

- Ensure the likely largest content is discoverable early in the document. Do not lazy-load the image that is actually the largest-content element.
- Set explicit dimensions or an aspect ratio to reserve space. Use responsive source sizes and inspect the chosen resource in a browser trace.
- Preload a resource only when measurement shows it is important and the browser cannot discover it promptly. Excessive high priority competes with other critical work.

## Interaction to Next Paint

- Capture a trace for the slow interaction and locate its script, event handler, and rendering work instead of guessing.
- Break up long main-thread work, reduce unnecessary work inside handlers, and batch layout reads before style writes.
- Measure third-party scripts separately. Defer or delay them only when their function and consent behavior allow it.

## Cumulative Layout Shift

- Identify the element introduced or resized at the time of the shift. Fix the cause rather than the element that merely moved.
- Reserve space for images, video, ads, and embeds. Inspect font loading and fallback metrics when text causes the shift.
- Use intrinsic sizing with content-visibility only when it prevents skipped content from changing the scrollbar unexpectedly.

## Other navigations

Caching and back/forward behavior depend on the data's privacy and freshness requirements. Use `no-store` only where the response must not be stored, and verify navigation behavior in a browser.
