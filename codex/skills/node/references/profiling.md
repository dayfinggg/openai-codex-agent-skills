<flame_graphs>
Use [@platformatic/flame](https://github.com/platformatic/flame) for CPU and heap profiles with flame graphs. `flame run` starts the application with profiling on. On exit, flame writes a `.pb` profile, an `.html` flame graph, and a `.md` analysis. It does so for both CPU and heap.

Use an existing installation first. Installing the tool requires the user's request under `code_rules`. Without that authorization, use Node's built-in `--cpu-prof` instead. The installation command below applies only after authorization.

```bash
npm install -g @platformatic/flame
flame run server.js
```

The markdown analysis lists the hotspots in text, so you can read it directly instead of opening the HTML. `flame generate` rebuilds it from a saved profile with the `summary`, `detailed`, or `adaptive` format.

```bash
flame generate --md-format=detailed profile.pb
```

`--manual` starts and stops profiling on `SIGUSR2` or `flame toggle`, so you profile only the slow phase.

```bash
flame run --manual server.js
```

The package also exports `startProfiling`, `generateFlamegraph`, `generateMarkdown`, and `parseProfile` for use from code.

```javascript
const { startProfiling, generateMarkdown } = require('@platformatic/flame')

const { pid, toggleProfiler } = startProfiling('server.js', ['--port', '3000'], { autoStart: true })
await generateMarkdown('profile.pb', 'analysis.md', { format: 'summary' })
```
</flame_graphs>

<load_testing>
<autocannon>
Use [autocannon](https://github.com/mcollina/autocannon) for HTTP benchmarks. The three commands run a default benchmark, a heavier one, and a POST with a JSON body.

```bash
npx autocannon http://localhost:3000
npx autocannon -c 100 -d 30 -p 10 http://localhost:3000
npx autocannon -m POST -H "Content-Type: application/json" -b '{"name":"test"}' http://localhost:3000/users
```

The main options are these.

- `-c` sets the number of concurrent connections, with a default of 10.
- `-d` sets the duration in seconds, with a default of 10.
- `-p` sets the number of pipelined requests, with a default of 1.
- `-m` sets the HTTP method.
- `-b` sets the request body.

autocannon also runs from code.

```typescript
import autocannon from 'autocannon';

const result = await autocannon({
  url: 'http://localhost:3000',
  connections: 100,
  duration: 30,
  pipelining: 10,
});

console.log(autocannon.printResult(result));
```
</autocannon>

<wrk>
[wrk](https://github.com/wg/wrk) is a high-throughput HTTP benchmark tool. `-t` sets threads, `-c` connections, and `-d` the duration. `-s` runs a Lua script for custom requests.

```bash
wrk -t12 -c400 -d30s http://localhost:3000
wrk -t12 -c400 -d30s -s post.lua http://localhost:3000
```
</wrk>

<k6>
[k6](https://k6.io/) fits complex, scripted load tests. This script runs 100 virtual users for 30 seconds and checks status and latency.

```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 100,
  duration: '30s',
};

export default function () {
  const res = http.get('http://localhost:3000');
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 200ms': (r) => r.timings.duration < 200,
  });
  sleep(1);
}
```

```bash
k6 run load-test.js
```
</k6>
</load_testing>

<built_in_profiling>
<cpu>
`--cpu-prof` writes a `.cpuprofile` file on exit, which Chrome DevTools opens. `--prof` writes a V8 log that `--prof-process` turns into text. Both `--cpu-prof` and `--heap-prof` also work inside `NODE_OPTIONS`, so you can profile without changing the start command.

```bash
node --cpu-prof app.js
NODE_OPTIONS=--cpu-prof npm start
node --prof app.js
node --prof-process isolate-*.log > profile.txt
```
</cpu>

<heap>
Start the process with the inspector to take heap snapshots. In Chrome DevTools at `chrome://inspect`, take snapshots, record allocation timelines, and compare them to find leaks.

```bash
node --inspect app.js
```
</heap>

<diagnostic_reports>
Diagnostic reports capture the JavaScript and native stacks, the heap statistics, the libuv handles, and the environment. `--report-on-signal` writes one on `SIGUSR2`. `--report-uncaught-exception` writes one on an uncaught exception, and `--report-on-fatalerror` writes one on a fatal error.

```bash
node --report-on-signal app.js
kill -SIGUSR2 <pid>
node --report-uncaught-exception app.js
```
</diagnostic_reports>
</built_in_profiling>

<workflow>
Profile in a loop until the goal is met.

1. Measure a baseline with autocannon.
2. Profile with flame to find the hotspots.
3. Fix the bottleneck that the profile shows.
4. Run autocannon again and compare with the baseline.
5. Repeat until the performance goal is met.
</workflow>

<tool_comparison>
Each tool fits a different job.

| Tool | Best for |
|------|----------|
| @platformatic/flame | CPU and heap profiles, flame graphs, and a markdown hotspot report |
| autocannon | Quick HTTP benchmarks written in Node.js |
| wrk | Maximum throughput tests |
| k6 | Complex scripted scenarios and CI load tests |
</tool_comparison>
