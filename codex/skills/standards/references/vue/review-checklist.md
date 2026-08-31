# Review checklist

- Can a reader identify the rendering, state, data, and test owner for every changed behavior?
- Does the code behave correctly in setup, lifecycle cleanup, SSR, hydration, and client navigation?
- Are state mutations, asynchronous failures, cancellation, and cleanup explicit?
- Does the rendered output preserve semantic native behavior and stable relationships?
- Did the change preserve a small public surface and avoid an abstraction that profiling or reuse does not justify?
