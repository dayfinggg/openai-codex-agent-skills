# Browser and Node portability

- Separate portable core logic from browser and Node bindings. Keep DOM, `window`, `document`, `process`, filesystem, and native module access at the edge. [J2]
- Do not read a host global at module initialization unless the module explicitly targets that host.
- Use capability detection such as `typeof window` or `typeof process` only when the branches provide equivalent behavior. Prefer separate bindings when they do not. [J2]
- Use `globalThis` only for an intentional cross-runtime global contract. Do not create implicit globals. [J2]
- Treat Node's browser-compatible `fetch` as a runtime capability governed by the package's supported Node versions, not as proof that all browser APIs exist. [J19]
- Declare runtime support in `engines` or the repository's equivalent and test the oldest supported runtime.
- Keep Node built-ins out of portable modules. Inject a binding or expose separate entry points for host-specific behavior.
- Test browser code through a server and test Node code in Node. Do not infer portability from one successful bundler build.
