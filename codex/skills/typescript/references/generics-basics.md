<overview>
Generics let one function, type, or class work with many types and keep the type information. They are the base of most type-safe APIs.
</overview>
<contents>
This file has these sections, in order.
- generic functions
- inference dependencies
- constraints
- defaults
- inference needs usage
- multiple parameters
- keyof with generics
- generic classes
- complete example
- when to use
- pitfalls
</contents>


<generic_functions>
A function that takes and returns `any` loses the type of its input.

```typescript
function identity(value: any): any {
  return value;
}
```

A type parameter keeps it. Here `num` is `number` and `str` is `string`, both inferred. `explicit` is `boolean` from the explicit type argument.

```typescript
function identity<T>(value: T): T {
  return value;
}

const num = identity(42);
const str = identity("hello");
const explicit = identity<boolean>(true);
```
</generic_functions>

<inference_dependencies>
A generic links the type of one value to another. In this example, the keys of the config decide which variants the returned function accepts. `TConfig` is inferred from the argument, so `variant` must be `"primary"` or `"secondary"`. The call with `"tertiary"` fails to compile.

```typescript
const createComponent = <TConfig extends Record<string, string>>(
  config: TConfig,
) => {
  return (variant: keyof TConfig, ...otherClasses: string[]): string => {
    return config[variant] + " " + otherClasses.join(" ");
  };
};

const getButtonClasses = createComponent({
  primary: "bg-blue-300",
  secondary: "bg-green-300",
});

getButtonClasses("primary", "px-4");
getButtonClasses("tertiary", "px-4");
```
</inference_dependencies>

<constraints>
A constraint with `extends` says what a type parameter must support. Without a constraint, `TFunc` could be anything, and `Parameters<TFunc>` would not compile. With the constraint, `TFunc` must be a function.

```typescript
type WrapFunction<TFunc extends (...args: any) => any> = (
  ...args: Parameters<TFunc>
) => ReturnType<TFunc>;
```

Without a constraint, the body cannot use any member of `T`. The first function reports "Property 'length' does not exist on type 'T'".

```typescript
function getLength<T>(item: T): number {
  return item.length;
}
```

With `T extends { length: number }`, strings, arrays, and objects with a `length` property compile. The call with `42` fails, because a number has no `length`.

```typescript
function getLength<T extends { length: number }>(item: T): number {
  return item.length;
}

getLength("hello");
getLength([1, 2, 3]);
getLength({ length: 10 });
getLength(42);
```
</constraints>

<defaults>
A type parameter can have a default. Here `TAdditional` defaults to `{}`, so callers may leave it out.

```typescript
type WrapFunction<
  TFunc extends (...args: any) => any,
  TAdditional = {}
> = (
  ...args: Parameters<TFunc>
) => Promise<Awaited<ReturnType<TFunc>> & TAdditional>;

type BasicWrapper = WrapFunction<typeof fetchUser>;

type ExtendedWrapper = WrapFunction<typeof fetchUser, { meta: string }>;
```
</defaults>

<inference_needs_usage>
TypeScript infers a type parameter only from the values that use it. Here `TConfig` is inferred as `{ primary: string; secondary: string }`.

```typescript
const createComponent = <TConfig>(config: TConfig) => {
  return config;
};

const component = createComponent({
  primary: "bg-blue-300",
  secondary: "bg-green-300",
});
```

A type parameter that no argument uses cannot be inferred, so it becomes `unknown`. In the first function, `TConfig` is unused. In the second, `TConfig` is the type of the argument and is inferred from it.

```typescript
const createComponentBad = <TConfig>(config: Record<string, string>) => {};

const createComponentGood = <TConfig extends Record<string, string>>(
  config: TConfig,
) => {};
```
</inference_needs_usage>

<multiple_parameters>
Several type parameters describe related but separate types. Here `TInput` is `string` and `TOutput` is `number`, so `numbers` is `number[]`.

```typescript
function map<TInput, TOutput>(
  items: TInput[],
  transform: (item: TInput) => TOutput
): TOutput[] {
  return items.map(transform);
}

const numbers = map(["1", "2", "3"], (s) => parseInt(s));
```
</multiple_parameters>

<keyof_with_generics>
`keyof` with a second type parameter gives type-safe property access. Here `name` is `string` and `age` is `number`. The call with `"email"` fails, because `"email"` is not a key of `user`.

```typescript
function getProperty<TObj, TKey extends keyof TObj>(
  obj: TObj,
  key: TKey
): TObj[TKey] {
  return obj[key];
}

const user = { name: "Alice", age: 30 };
const name = getProperty(user, "name");
const age = getProperty(user, "age");
const invalid = getProperty(user, "email");
```
</keyof_with_generics>

<generic_classes>
A class can take type parameters, and its methods can add their own. Here `strContainer` is `Container<string>`.

```typescript
class Container<T> {
  private value: T;

  constructor(value: T) {
    this.value = value;
  }

  getValue(): T {
    return this.value;
  }

  map<U>(transform: (value: T) => U): Container<U> {
    return new Container(transform(this.value));
  }
}

const numContainer = new Container(42);
const strContainer = numContainer.map((n) => n.toString());
```
</generic_classes>

<complete_example>
This factory creates class-name generators that accept only the variants in their config. The variant must be `"primary"`, `"secondary"`, or `"danger"`. The first call returns `"bg-blue-500 text-white px-4 py-2"`, and the call with `"invalid"` fails to compile.

```typescript
export const createComponent = <TConfig extends Record<string, string>>(
  config: TConfig,
) => {
  return (variant: keyof TConfig, ...otherClasses: string[]): string => {
    return config[variant] + " " + otherClasses.join(" ");
  };
};

const getButtonClasses = createComponent({
  primary: "bg-blue-500 text-white",
  secondary: "bg-gray-200 text-gray-800",
  danger: "bg-red-500 text-white",
});

const classes = getButtonClasses("primary", "px-4", "py-2");

getButtonClasses("invalid");
```
</complete_example>

<when_to_use>
Generics fit five situations.

- A function must pass type information from input to output.
- One type depends on another.
- An API must work with many types.
- A type must have certain properties, which a constraint expresses.
- A factory returns typed results.
</when_to_use>

<pitfalls>
A generic that adds nothing makes the signature harder to read. This first function needs no type parameter, and the second is the better form.

```typescript
function greet<T extends string>(name: T): string {
  return `Hello, ${name}`;
}

function greet(name: string): string {
  return `Hello, ${name}`;
}
```

A constraint should require only what the body uses. The first constraint asks for three fields, and the second asks only for `id`.

```typescript
function process<T extends { id: string; name: string; email: string }>(
  obj: T
): void {}

function process<T extends { id: string }>(obj: T): void {}
```

A missing constraint blocks access to members. The first function reports "Property 'name' does not exist", and the constrained version compiles.

```typescript
function getName<T>(obj: T): string {
  return obj.name;
}

function getName<T extends { name: string }>(obj: T): string {
  return obj.name;
}
```
</pitfalls>
