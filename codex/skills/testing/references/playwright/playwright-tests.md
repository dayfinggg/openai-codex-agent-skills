<running_tests>
Run Playwright tests with `npx playwright test` or with the project's package script. Set `PLAYWRIGHT_HTML_OPEN=never`, so the interactive HTML report does not open. These commands run all tests, directly or through a custom script.

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test
PLAYWRIGHT_HTML_OPEN=never npm run special-test-command
```
</running_tests>

<debugging_tests>
Debug a failing test with the `--debug=cli` option. The test pauses at the start and prints debugging instructions with a session name.

Run the command in the background, and read its output until "Debugging Instructions" appears. Then attach `playwright-cli` to the session and explore the page. Stop the command when you finish. The session name in this example is `tw-abcdef`.

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test --debug=cli
playwright-cli attach tw-abcdef
```

Keep the test running in the background while you explore and look for a fix. The test is paused at the start, so move it to where the problem most likely is. `resume` runs the test on, `step-over` runs the next call, and `pause-at` runs to a file and line.

```bash
playwright-cli resume
playwright-cli step-over
playwright-cli pause-at example.spec.ts:42
```

Every action you perform with `playwright-cli` prints the matching Playwright TypeScript code. You can copy that code into the test. Most often a locator or an expectation needs an update. The cause can also be a bug in the app. Decide which one it is from the evidence.

After you fix the test, stop the background test run. Run the test again to check that it passes.
</debugging_tests>
