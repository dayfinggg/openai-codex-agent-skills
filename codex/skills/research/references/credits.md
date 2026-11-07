This skill merges three sources. Each one is under the MIT License, and `credits.md` holds the license text with all three copyright lines.

The base is the [`source-driven-development`](https://github.com/addyosmani/agent-skills/tree/main/skills/source-driven-development) skill by Addy Osmani, at revision `301b02b12bff98e4688e6984af6556802322bbde`. It gives the version detection, the docs fetching, the source ranking, the untrusted content rules, and the citation rules. The rationalizations table, the verification checklist, and the link to `security-and-hardening` were removed. The advice to cite sources in code comments was removed too. The text was rewritten to the plugin's style.

The evidence rules and the final report come from the [`research`](https://github.com/taecontrol/skills/tree/main/skills/engineering/research) skill by Taecontrol, at revision `3f079b0eca9f4adc0707fdfce2ee1c8803226a93`. Its two-researcher and judge process was left out. The method note now covers searches and single-source claims instead of agent roles.

The delegation pattern comes from the [`research`](https://github.com/mattpocock/skills/tree/main/skills/engineering/research) skill by Matt Pocock, at revision `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d`. A report file is written only when the user asks for one, as the plugin's coding instructions require.

The `queries_and_cross_checks` section is original to this plugin.

Upstream redistribution terms follow.

```text
MIT License

Copyright (c) 2025 Addy Osmani
Copyright (c) Taecontrol
Copyright (c) 2026 Matt Pocock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
