# JavaScript

Check the runtime and its version first: the `engines` field and `type` in `package.json`, or `node --version`. Use the module system the project uses and do not mix `import` with `require`.

## Pitfalls

Declare with `const`, and with `let` only when the name is reassigned. Do not use `var`.

Compare with `===` and `!==`. The one useful loose comparison is `value == null`, which is true for both `null` and `undefined`.

`||` replaces every falsy value, including `0` and `""`. Use `??` when only `null` and `undefined` should fall back. Use `?.` to read through a value that may be missing.

Iterate over arrays with `for...of` or the array methods. `for...in` walks the keys of an object, including inherited ones.

Throw `Error` objects and nothing else. A thrown string has no stack trace.

Every promise is awaited, returned or given a `catch`. Start independent operations together and await them with `Promise.all`. An `await` inside a loop runs them one after another.

Do not change the arguments you were given, and do not change built-in prototypes. Copy with spread syntax or with `structuredClone` for nested data.

Do not use `eval`, `with` or `new Function` on strings.

Parse numbers with `Number()` or with `Number.parseInt(text, 10)`, and check the result with `Number.isNaN`.

Use named exports. A default export lets every importer pick a different name.

## Tools

When the project defines none, lint with `eslint` and format with `prettier`. Check that a file parses with `node --check`. Run the tests with the runner in the `scripts` of `package.json`.
