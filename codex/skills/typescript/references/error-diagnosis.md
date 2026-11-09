<overview>
TypeScript errors can be hard to read, most of all with complex generic types. These strategies find the real cause of an error and how to fix it.
</overview>
<contents>
This file has these sections, in order.
- general strategies
- common errors
- debugging techniques
- long error messages
- wrong library types
- prevention
</contents>


<general_strategies>
<read_bottom_up>
TypeScript prints an error from the outer type down to the inner one. The real cause is usually in the last line. In this error, the cause is that `email` may be `undefined`.

```
Type '{ name: string; }' is not assignable to type 'User'.
  Types of property 'email' are incompatible.
    Type 'undefined' is not assignable to type 'string'.
```
</read_bottom_up>

<inspect_types>
Find out what TypeScript inferred before you change anything. In an editor or a language server, hover over a name to see its type. Go to its definition to see overloads. In a terminal, assign the value to a variable with the type you expect. The compiler then reports the actual type in the error.
</inspect_types>

<split_complex_types>
Split a complex type into steps and inspect each one. This breakdown shows where the result stops matching what you expect.

```typescript
type Result = SomeComplexType<Input>[keyof Input][number];

type Step1 = SomeComplexType<Input>;
type Step2 = Step1[keyof Input];
type Step3 = Step2[number];
```
</split_complex_types>
</general_strategies>

<common_errors>
<not_assignable>
"Type 'X' is not assignable to type 'Y'" is the most common error. Check for a missing property, an incompatible property type, and a literal type that widened. In this example, `let` widens `status` to `string`, so the call fails.

```typescript
let status = "active";
function setStatus(s: "active" | "inactive") {}
setStatus(status);
```

A `const` declaration keeps the literal type `"active"`, so the call compiles.

```typescript
const status = "active";
setStatus(status);
```
</not_assignable>

<property_does_not_exist>
"Property 'X' does not exist on type 'Y'" means the type lacks the property. For `unknown`, every property access fails until a guard narrows the value.

```typescript
function process(data: unknown) {
  data.name;
}

function processChecked(data: unknown) {
  if (typeof data === "object" && data !== null && "name" in data) {
    data.name;
  }
}
```
</property_does_not_exist>

<cannot_index>
"Type 'X' cannot be used to index type 'Y'" means the key may not exist on the type. A `string` key cannot index a generic `T`. A key constrained to `keyof T` can.

```typescript
function getValue<T>(obj: T, key: string) {
  return obj[key];
}

function getValueChecked<T, K extends keyof T>(obj: T, key: K) {
  return obj[key];
}
```
</cannot_index>

<argument_not_assignable>
"Argument of type 'X' is not assignable to parameter of type 'Y'" often comes from a narrow parameter type. Here `includes` on a readonly tuple accepts only `"a" | "b" | "c"`, so a `string` argument fails. Widening the array type in the call fixes it.

```typescript
const items = ["a", "b", "c"] as const;
declare const someString: string;

items.includes(someString);

(items as readonly string[]).includes(someString);
```
</argument_not_assignable>

<not_generic>
"Type 'X' is not generic" means the code passes type arguments to a type without type parameters. Either remove the arguments or add a type parameter to the type.

```typescript
type NotGeneric = string;
type Attempt = NotGeneric<number>;

type IsGeneric<T> = T;
type Works = IsGeneric<number>;
```
</not_generic>

<constraint_errors>
"Type 'T' does not satisfy the constraint" means a utility type needs a constraint that the type parameter lacks. `Parameters<T>` needs a function type, so `T` must extend one.

```typescript
function process<T>(items: Parameters<T>) {}

function processChecked<T extends (...args: any) => any>(items: Parameters<T>) {}
```
</constraint_errors>
</common_errors>

<debugging_techniques>
<simplify>
Remove complexity until the error is clear. Split a long chain into named steps, and check the type of each step.

```typescript
const step1 = complexFunction();
const step2 = step1.map(transform);
const step3 = step2.filter(predicate);
const result = step3.reduce(accumulator);
```
</simplify>

<explicit_annotations>
Explicit annotations make the compiler report the first place where a type differs. Each annotated line fails if the value has another type.

```typescript
const data: ExpectedDataType = getData();
const result: ExpectedResultType = data.process();
```
</explicit_annotations>

<expect_error_probe>
A temporary `@ts-expect-error` comment tests whether a line really errors. If the line compiles, TypeScript reports the directive as unused. Delete the probe afterward, because the `verification` block rules out hiding a type error with a comment.

```typescript
// @ts-expect-error
const x: number = "hello";
```
</expect_error_probe>

<library_definitions>
For a library type, read its declaration. Look in three places.

1. The definition that go-to-definition or the import path points to.
2. `node_modules/@types/<library>`.
3. The `.d.ts` files in `node_modules/<library>`, as named by the `types` or `exports` field of its `package.json`.

An overloaded function shows `(+N overloads)` in a hover. The first overload that matches the call wins, so read all of them.
</library_definitions>
</debugging_techniques>

<long_error_messages>
A long error usually has one core problem. In this error, the only cause is the missing `agePlus10` property.

```
Type '{ fullName: string; id: string; firstName: string; lastName: string; age: number; }'
is not assignable to type
'{ fullName: string; id: string; firstName: string; lastName: string; age: number; agePlus10: number }'.

Property 'agePlus10' is missing in type
'{ fullName: string; id: string; firstName: string; lastName: string; age: number; }'
but required in type '{ fullName: string; agePlus10: number; }'.
```

Type aliases for both sides make the comparison easier to inspect.

```typescript
type Actual = typeof problematicValue;
type Expected = ExpectedType;
```
</long_error_messages>

<wrong_library_types>
A library type can be wrong or incomplete. First check whether a newer version of the library or its `@types` package fixes it. A type assertion works when you know more than the compiler, as with an element that the page always has.

```typescript
const element = document.getElementById("root") as HTMLDivElement;
```

Declaration merging adds a missing member to a library type.

```typescript
declare module "some-library" {
  interface SomeType {
    missingProperty: string;
  }
}
```

Tell the user when the library itself has a bug, so they can decide whether to report it upstream.
</wrong_library_types>

<prevention>
Three habits prevent many type errors.

- Keep `strict` on. From TypeScript 6.0 it is the default.
- Use `unknown` instead of `any` for data of unknown shape, and narrow it with guards.
- Constrain type parameters to what the code uses, instead of a default of `any`.

These versions show the safer forms.

```typescript
const data: unknown = fetchData();

function wrap<T extends object>(value: T) {}
```

Before you finish, consider the inputs a type allows. Examples are an empty string, an empty array, and special characters.
</prevention>
