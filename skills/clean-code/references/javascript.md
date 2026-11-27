# JavaScript

Read the runtime and its version from the `engines` field and `type` in `package.json`, or from `node --version`. Use the project's module system throughout, either `import` or `require`.

## Pitfalls

- Declare with `const`, or with `let` when the name is reassigned, in place of `var`.
- Compare with `===` and `!==`. The one useful loose comparison is `value == null`, which is true for both `null` and `undefined`.
- `||` replaces every falsy value, including `0` and `""`. Use `??` when only `null` and `undefined` should fall back, and `?.` to read through a value that may be missing.
- `for...in` walks the keys of an object, inherited ones included. Iterate arrays with `for...of` or the array methods.
- Throw `Error` objects, because a thrown string has no stack trace.
- Await, return or `catch` every promise. Start independent operations together and await them with `Promise.all`, since an `await` inside a loop runs them one after another.
- Leave built-in prototypes unchanged. Copy with spread syntax, or with `structuredClone` for nested data.
- Call functions directly in place of `eval`, `with` or `new Function` on strings.
- Parse numbers with `Number()` or `Number.parseInt(text, 10)`, and check the result with `Number.isNaN`.
- Use named exports, so every importer uses the same name.

## Tools

When the project defines none, lint with `eslint`, format with `prettier`, check that a file parses with `node --check`, and run the tests with the runner in the `scripts` of `package.json`.
