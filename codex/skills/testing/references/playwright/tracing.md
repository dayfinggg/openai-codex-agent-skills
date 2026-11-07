<overview>
A trace records a browser session in detail for debugging and analysis. It holds DOM snapshots, screenshots, network activity, and console logs. Tracing needs an open browser, so open it before you start the trace. Then use `goto`, so the trace records the navigation.

Traces can retain cookies, authorization headers, and personal data. Record an isolated test profile with synthetic data. Keep traces outside version control and review them before sharing. Delete temporary traces after the task. Do not trace the user's real authenticated session without explicit authorization.

```bash
playwright-cli open
playwright-cli tracing-start
playwright-cli goto https://example.com
playwright-cli click e1
playwright-cli fill e2 "test"
playwright-cli tracing-stop
```
</overview>

<output_files>
Tracing writes its files to the `.playwright-cli/traces/` directory.
- `trace-{timestamp}.trace` is the action log. It holds every action, with the DOM before and after it and a screenshot. It also holds timing, console messages, and source locations.
- `trace-{timestamp}.network` is the network log. It holds all requests and responses with headers, bodies, timing, sizes, and failures.
- `resources/` holds cached images, fonts, stylesheets, scripts, and response bodies, so the trace can rebuild the page state.
</output_files>

<trace_video_screenshot>
Each capture type fits a different purpose.

| Feature | Trace | Video | Screenshot |
|---|---|---|---|
| Format | `.trace` file | `.webm` video | `.png` or `.jpeg` image |
| DOM inspection | Yes | No | No |
| Network details | Yes | No | No |
| Replay | Step by step | Continuous | Single frame |
| File size | Medium | Large | Small |
| Best for | Debugging | Demos | Quick capture |
</trace_video_screenshot>

<use_cases>
Trace a failing action to see the DOM state at the moment of the click.

```bash
playwright-cli open
playwright-cli tracing-start
playwright-cli goto https://app.example.com
playwright-cli click e5
playwright-cli tracing-stop
```

Trace a page load and read the network waterfall to find slow resources.

```bash
playwright-cli open
playwright-cli tracing-start
playwright-cli goto https://slow-site.com
playwright-cli tracing-stop
```

Trace a complete user flow as evidence of the exact sequence of events.

```bash
playwright-cli open
playwright-cli tracing-start
playwright-cli goto https://app.example.com/checkout
playwright-cli fill e1 "4111111111111111"
playwright-cli fill e2 "12/25"
playwright-cli fill e3 "123"
playwright-cli click e4
playwright-cli tracing-stop
```
</use_cases>

<practices>
Start the trace before the problem, and trace the whole flow instead of only the failing step. Traces can use a lot of disk space. This command removes traces older than 7 days.

```bash
find .playwright-cli/traces -mtime +7 -delete
```

Traces slow the automation down. Some dynamic content may not replay exactly.
</practices>
