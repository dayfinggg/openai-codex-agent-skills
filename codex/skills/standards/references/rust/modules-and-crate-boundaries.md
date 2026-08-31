# Modules and crate boundaries

Treat a package as a build unit, a crate as a module tree producing a library or executable, and a module as a privacy boundary.
Organize modules around domain concepts, invariants, and ownership, not around arbitrary line counts.
Keep items private by default and expose only the smallest stable interface required by callers.
Remember that `pub mod` exposes the module path but does not make its contents public.
Use a root-level facade and targeted `pub use` re-exports when a stable path is more valuable than internal layout.
Keep implementation modules private so refactoring does not become a public API change.
Place unit tests beside the module they explain, and let those tests exercise private behavior when that improves diagnosis.
Use separate crates when an independent dependency boundary, compile unit, or ownership boundary is valuable.
Avoid deep module paths, wildcard re-exports, and names that force callers to understand implementation details.
Keep feature names additive, meaningful, and free of placeholder words such as `use-` or `with-`.
Make `main` small when possible, and put reusable behavior in a library crate that integration tests can call.
