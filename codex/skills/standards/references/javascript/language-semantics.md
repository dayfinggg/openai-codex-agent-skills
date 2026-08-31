# Language semantics

- Declare locals with `const` by default and use `let` only when the binding is reassigned. Do not use `var` in new code. [J5][J7]
- Initialize variables close to first use and keep their scope no wider than necessary. [J5]
- Remember that modules are strict mode code. Do not rely on sloppy-mode coercion, silent assignment failure, or accidental globals. [J1][J2]
- Compare with `===` by default. Use `Object.is` when `NaN` or signed zero semantics matter, and use `== null` only when deliberately matching both `null` and `undefined`. [J8]
- Do not use truthiness when `0`, `false`, or an empty string is valid domain data.
- Make coercion explicit at boundaries with validation and parsing rather than relying on implicit conversions.
- Use `??` when only nullish values should default, and use `||` only when every falsy value should default.
- Keep optional chaining local to a known optional boundary. Do not let `?.` hide a broken required invariant.
- Prefer primitive values over boxed `String`, `Number`, and `Boolean` objects. Never modify built-in constructors or prototypes. [J5]
- Remember that `typeof null` is `"object"`; use an explicit null check, and use `Array.isArray()` rather than `typeof` or `instanceof Array` when identifying arrays across realms. [J30]
- Use `Number.isNaN()` to test the numeric `NaN` value without coercing unrelated inputs. Validate finiteness, safe-integer range, and domain bounds separately when they matter. [J31]
- Do not compare floating-point results for exact equality when rounding is inherent in the computation. Choose a tolerance from the domain scale rather than applying one universal epsilon.
- Make a function's `this` contract explicit. Use an arrow function for lexical `this` and a method or bound function when a receiver is intentional.
- Treat `#private` class elements as enforced encapsulation and an underscore prefix as a naming convention only. Do not add a class merely to obtain private syntax. [J32]
- Prefer direct control flow, descriptive names, and ordinary data over clever coercion, metaprogramming, or hidden global state.
- Use standardized ECMAScript and host features only. Record a compatibility decision when a polyfill or transpilation step is required. [J5]
