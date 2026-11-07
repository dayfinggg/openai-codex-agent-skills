<overview>
Narrowing refines a type through control flow analysis. After a check, TypeScript uses the narrower type inside the guarded code.
</overview>

<built_in_narrowing>
`typeof` narrows primitives. After the check, `value` is `string` inside the `if` and `number` after it.

```typescript
function processValue(value: string | number) {
  if (typeof value === "string") {
    return value.toUpperCase();
  }
  return value.toFixed(2);
}
```

`instanceof` narrows class instances. Here `error` is `Error` in the first branch and `string` in the second.

```typescript
function logError(error: Error | string) {
  if (error instanceof Error) {
    console.log(error.stack);
  } else {
    console.log(error);
  }
}
```

A truthiness check removes `null`, `undefined`, and other falsy values. Inside the `if`, `name` is `string`.

```typescript
function printName(name: string | null | undefined) {
  if (name) {
    console.log(name.toUpperCase());
  }
}
```

Equality narrows both sides to their common type. Inside the `if`, `x` and `y` are both `string`.

```typescript
function example(x: string | number, y: string | boolean) {
  if (x === y) {
    console.log(x.toUpperCase());
    console.log(y.toUpperCase());
  }
}
```

The `in` operator narrows by property existence. Here `animal` is `Fish` in the first branch and `Bird` in the second.

```typescript
interface Fish {
  swim: () => void;
}

interface Bird {
  fly: () => void;
}

function move(animal: Fish | Bird) {
  if ("swim" in animal) {
    animal.swim();
  } else {
    animal.fly();
  }
}
```
</built_in_narrowing>

<discriminated_unions>
A shared literal property discriminates between union members. In each `case`, `shape` has the matching member type.

```typescript
interface Circle {
  kind: "circle";
  radius: number;
}

interface Rectangle {
  kind: "rectangle";
  width: number;
  height: number;
}

interface Triangle {
  kind: "triangle";
  base: number;
  height: number;
}

type Shape = Circle | Rectangle | Triangle;

function getArea(shape: Shape): number {
  switch (shape.kind) {
    case "circle":
      return Math.PI * shape.radius ** 2;
    case "rectangle":
      return shape.width * shape.height;
    case "triangle":
      return (shape.base * shape.height) / 2;
  }
}
```

An assignment to `never` checks that every case is handled. When someone adds a new shape, the `default` branch fails to compile.

```typescript
function getArea(shape: Shape): number {
  switch (shape.kind) {
    case "circle":
      return Math.PI * shape.radius ** 2;
    case "rectangle":
      return shape.width * shape.height;
    case "triangle":
      return (shape.base * shape.height) / 2;
    default: {
      const exhaustiveCheck: never = shape;
      throw new Error(`Unhandled shape: ${exhaustiveCheck}`);
    }
  }
}
```
</discriminated_unions>

<type_predicates>
A function with the return type `value is Type` is a custom type guard. Here `pet` is `Fish` in the first branch and `Bird` in the second.

```typescript
function isFish(pet: Fish | Bird): pet is Fish {
  return (pet as Fish).swim !== undefined;
}

function move(pet: Fish | Bird) {
  if (isFish(pet)) {
    pet.swim();
  } else {
    pet.fly();
  }
}
```

TypeScript infers a type predicate for a simple function without a return type annotation. The function must return a boolean expression that narrows its parameter and must not change the parameter. So `(v) => v !== null` already works as a guard in `filter`.

A generic guard works for any type. Here `filtered` is `number[]`.

```typescript
function isNotNull<T>(value: T | null | undefined): value is T {
  return value !== null && value !== undefined;
}

const values = [1, null, 2, undefined, 3];
const filtered = values.filter(isNotNull);
```

A guard can add a property to the type of an object. After `hasProperty(data, "name")`, the code can read `data.name`.

```typescript
function hasProperty<T extends object, K extends string>(
  obj: T,
  key: K
): obj is T & Record<K, unknown> {
  return key in obj;
}

const data: unknown = { name: "Alice" };

if (typeof data === "object" && data !== null && hasProperty(data, "name")) {
  console.log(data.name);
}
```
</type_predicates>

<assertion_functions>
An assertion function throws on invalid input and narrows the type after the call. After `assertIsString(input)`, `input` is `string`.

```typescript
function assertIsString(value: unknown): asserts value is string {
  if (typeof value !== "string") {
    throw new Error(`Expected string, got ${typeof value}`);
  }
}

function processInput(input: unknown) {
  assertIsString(input);
  console.log(input.toUpperCase());
}
```

Assertions work on objects too. After `assertIsUser(data)`, `data` is `User`.

```typescript
interface User {
  id: string;
  name: string;
}

function assertIsUser(value: unknown): asserts value is User {
  if (
    typeof value !== "object" ||
    value === null ||
    !("id" in value) ||
    !("name" in value)
  ) {
    throw new Error("Invalid user object");
  }
}

function handleData(data: unknown) {
  assertIsUser(data);
  console.log(data.name);
}
```

A call to an assertion function needs an explicit type on the function name. A plain arrow function assigned to a `const` fails at the call. The error says "Assertions require every name in the call target to be declared with an explicit type annotation". Use a function declaration, as above, or annotate the `const` with the function type.
</assertion_functions>

<opaque_types>
A type predicate can narrow a plain value to a branded type. After the check in `handleSubmit`, `email` is `ValidEmail`.

```typescript
type ValidEmail = string & { __brand: "ValidEmail" };

function isValidEmail(email: string): email is ValidEmail {
  return email.includes("@") && email.includes(".");
}

declare function sendEmail(email: ValidEmail): void;

function handleSubmit(email: string) {
  if (!isValidEmail(email)) {
    throw new Error("Invalid email");
  }
  sendEmail(email);
}
```
</opaque_types>

<array_filtering>
A predicate in `filter` narrows the element type of the result. Here `typeAItems` is `{ type: "a"; value: string }[]`.

```typescript
type Item = { type: "a"; value: string } | { type: "b"; count: number };

const items: Item[] = [
  { type: "a", value: "hello" },
  { type: "b", count: 42 },
];

const typeAItems = items.filter(
  (item): item is { type: "a"; value: string } => item.type === "a"
);
```
</array_filtering>

<aliased_conditions>
A check stored in a `const` still narrows. Here `value` is `string` inside both `if` blocks. The narrowed reference must be a `const`, a `readonly` property, or a parameter that the function never reassigns.

```typescript
declare function isString(x: unknown): x is string;

function example(value: string | number) {
  const isStr = isString(value);
  if (isStr) {
    value.toUpperCase();
  }

  const isText = typeof value === "string";
  if (isText) {
    value.toUpperCase();
  }
}
```
</aliased_conditions>

<api_response_example>
A predicate on a discriminated union separates success from error responses. In the first branch, `response.data` is `User`, and in the second, `response.error` is available.

```typescript
interface SuccessResponse<T> {
  status: "success";
  data: T;
}

interface ErrorResponse {
  status: "error";
  error: {
    code: string;
    message: string;
  };
}

type ApiResponse<T> = SuccessResponse<T> | ErrorResponse;

function isSuccess<T>(response: ApiResponse<T>): response is SuccessResponse<T> {
  return response.status === "success";
}

declare function fetchUser(): Promise<ApiResponse<User>>;

async function handleUser() {
  const response = await fetchUser();

  if (isSuccess(response)) {
    console.log(response.data.name);
  } else {
    console.error(response.error.message);
  }
}
```
</api_response_example>

<which_technique>
Each narrowing technique has a typical use.

| Technique | Typical use |
|---|---|
| `typeof` | Primitive types |
| `instanceof` | Class instances |
| `in` operator | Property existence |
| Discriminated union | Related types with a shared literal property |
| Type predicate | Custom narrowing logic |
| Assertion function | Validation that throws early |
</which_technique>

<pitfalls>
Narrowing in a callback holds only when nothing reassigns the variable after the callback is created. Here `value` stays `string` inside the `setTimeout` callback, because the parameter is never reassigned. A later assignment to `value` would reset it to `string | null` inside the callback.

```typescript
function example(value: string | null) {
  if (value !== null) {
    setTimeout(() => {
      console.log(value.toUpperCase());
    }, 0);
  }
}
```

An inferred predicate needs a simple body. Some functions return only `boolean`. These have an explicit `boolean` return type, several return statements, or a check that does not narrow the parameter. Write the `pet is Fish` return type explicitly in that case.

```typescript
function isFishInferred(pet: Fish | Bird) {
  return "swim" in pet;
}

function isFishExplicit(pet: Fish | Bird): boolean {
  return "swim" in pet;
}
```

In this block, `isFishInferred` narrows like a predicate, and `isFishExplicit` does not narrow.

A check on one of several optional properties narrows none of them. Inside the first `if`, neither `a` nor `b` is known to exist. A direct check on one property narrows it.

```typescript
function example(value: { a?: string; b?: number }) {
  if (value.a || value.b) {
    console.log(value.a, value.b);
  }

  if (value.a !== undefined) {
    console.log(value.a.toUpperCase());
  }
}
```
</pitfalls>
