<overview>
The `infer` keyword captures part of a type inside a conditional type. It works like pattern matching, because you write a pattern and name the parts you want.
</overview>
<contents>
This file has these sections, in order.
- syntax
- simple extractions
- template literals
- function types
- constrained infer
- recursive extraction
- practical examples
- pitfalls
</contents>


<syntax>
Here `infer U` captures the type argument of `SomePattern` into `U`.

```typescript
type ExtractType<T> = T extends SomePattern<infer U> ? U : never;
```
</syntax>

<simple_extractions>
`infer` extracts element, promise, and property types. Here `ArrayElement` gives `string` for `string[]` and `never` for a non-array. `PromiseValue` gives the resolved type, and `GetData` gives the type of the `data` property.

```typescript
type ArrayElement<T> = T extends (infer U)[] ? U : never;

type Test1 = ArrayElement<string[]>;
type Test2 = ArrayElement<(string | number)[]>;
type Test3 = ArrayElement<string>;

type PromiseValue<T> = T extends Promise<infer U> ? U : never;

type Test4 = PromiseValue<Promise<number>>;

type GetData<T> = T extends { data: infer TData } ? TData : never;

type Test5 = GetData<{ data: number[] }>;
type Test6 = GetData<{ other: string }>;
```

In this block, `Test1` is `string`, `Test2` is `string | number`, and `Test3` is `never`. `Test4` is `number`, `Test5` is `number[]`, and `Test6` is `never`.
</simple_extractions>

<template_literals>
`infer` inside a template literal type parses strings. Here `RemoveMaps<"maps:longitude">` is `"longitude"`, and `RemoveMaps<"other">` returns `"other"` unchanged.

```typescript
type RemoveMaps<T> = T extends `maps:${infer Rest}` ? Rest : T;

type Test1 = RemoveMaps<"maps:longitude">;
type Test2 = RemoveMaps<"other">;
```

Several captures in one pattern split a string. `ParseKeyValue<"name=John">` is `{ key: "name"; value: "John" }`.

```typescript
type ParseKeyValue<T> = T extends `${infer Key}=${infer Value}`
  ? { key: Key; value: Value }
  : never;
```

An `infer` placeholder followed by literal text matches up to the first occurrence of that text. Here `Before<"prefix:suffix">` is `"prefix"`, and `After<"prefix:suffix">` is `"suffix"`.

```typescript
type Before<T> = T extends `${infer Prefix}:${string}` ? Prefix : T;

type After<T> = T extends `${string}:${infer Suffix}` ? Suffix : T;
```

Recursion parses repeated parts. This type turns a route into a nested structure of its parameters.

```typescript
type ParseRoute<T> = T extends `${infer Start}:${infer Param}/${infer Rest}`
  ? { start: Start; param: Param; rest: ParseRoute<Rest> }
  : T extends `${infer Start}:${infer Param}`
  ? { start: Start; param: Param }
  : T;

type Route = ParseRoute<"/users/:id/posts/:postId">;
```
</template_literals>

<function_types>
`infer` extracts the parts of a function type. In this block, `Test1` is `string`, and `Test2` is `[a: string, b: number]`. `Test3` is `string`, and `UserParams` is `[name: string, age: number]`.

```typescript
type MyReturnType<T> = T extends (...args: any[]) => infer R ? R : never;

type Test1 = MyReturnType<() => string>;

type MyParameters<T> = T extends (...args: infer P) => any ? P : never;

type Test2 = MyParameters<(a: string, b: number) => void>;

type FirstArg<T> = T extends (first: infer F, ...rest: any[]) => any
  ? F
  : never;

type Test3 = FirstArg<(name: string, age: number) => void>;

type ConstructorParams<T> = T extends new (...args: infer P) => any
  ? P
  : never;

class User {
  constructor(public name: string, public age: number) {}
}

type UserParams = ConstructorParams<typeof User>;
```

The built-in `ReturnType`, `Parameters`, and `ConstructorParameters` do the same. Prefer them, and write your own only for a shape they do not cover.
</function_types>

<constrained_infer>
An `extends` clause on `infer` accepts the match only for a given type. Here `Test1` is `"hello"` and `Test2` is `never`.

```typescript
type ExtractString<T> = T extends { value: infer V extends string }
  ? V
  : never;

type Test1 = ExtractString<{ value: "hello" }>;
type Test2 = ExtractString<{ value: 123 }>;
```
</constrained_infer>

<recursive_extraction>
A recursive conditional type unwraps nested structures. Here `Test` is `string`. The built-in `Awaited` already handles nested promises.

```typescript
type DeepAwaited<T> = T extends Promise<infer U>
  ? DeepAwaited<U>
  : T;

type Test = DeepAwaited<Promise<Promise<Promise<string>>>>;
```
</recursive_extraction>

<practical_examples>
`infer` gets the event type from a handler signature. Here `ClickEvent` is `MouseEvent`.

```typescript
type EventHandler<T> = T extends (event: infer E) => void ? E : never;

interface Events {
  click: (event: MouseEvent) => void;
  keydown: (event: KeyboardEvent) => void;
}

type ClickEvent = EventHandler<Events["click"]>;
```

A recursive pattern collects route parameter names. Here `Params` is `"userId" | "postId"`.

```typescript
type ExtractParams<T extends string> =
  T extends `${string}:${infer Param}/${infer Rest}`
    ? Param | ExtractParams<`/${Rest}`>
    : T extends `${string}:${infer Param}`
    ? Param
    : never;

type Params = ExtractParams<"/users/:userId/posts/:postId">;
```

With key remapping, `infer` renames every key of an object. Here `Cleaned` is `{ longitude: string; latitude: string; city: string }`.

```typescript
type RemoveMaps<T> = T extends `maps:${infer Rest}` ? Rest : T;

type RemoveMapsPrefixFromObj<T> = {
  [K in keyof T as RemoveMaps<K>]: T[K];
};

interface ApiData {
  "maps:longitude": string;
  "maps:latitude": string;
  city: string;
}

type Cleaned = RemoveMapsPrefixFromObj<ApiData>;
```

Several branches extract type arguments from different generic types. Here `Test1` is `string`, `Test2` is `{ key: string; value: number }`, and `Test3` is `boolean`.

```typescript
type ExtractGeneric<T> = T extends Array<infer U>
  ? U
  : T extends Map<infer K, infer V>
  ? { key: K; value: V }
  : T extends Set<infer U>
  ? U
  : never;

type Test1 = ExtractGeneric<Array<string>>;
type Test2 = ExtractGeneric<Map<string, number>>;
type Test3 = ExtractGeneric<Set<boolean>>;
```
</practical_examples>

<pitfalls>
The position of `infer` decides what it captures. Here `TestFirst` is `1`, and `TestLast` is `3`.

```typescript
type First<T> = T extends [infer F, ...any[]] ? F : never;
type Last<T> = T extends [...any[], infer L] ? L : never;

type TestFirst = First<[1, 2, 3]>;
type TestLast = Last<[1, 2, 3]>;
```

Literal text at the end of a pattern must match the end of the string. So `GetPath<"folder/file.name.json">` is `"folder/file.name"`, including the inner dot.

```typescript
type GetPath<T> = T extends `${infer Path}.json` ? Path : never;

type Test = GetPath<"folder/file.name.json">;
```

A conditional type with `infer` distributes over a union too. Here `Test` is `string | number`, not `(string | number)[]`.

```typescript
type ExtractArray<T> = T extends (infer U)[] ? U : never;

type Test = ExtractArray<string[] | number[]>;
```

Choose the false branch on purpose, and give captures clear names such as `TData`, `TKey`, or `TValue`. A more specific pattern gives better inference.
</pitfalls>
