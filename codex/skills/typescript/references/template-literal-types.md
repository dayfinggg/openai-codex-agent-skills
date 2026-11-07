<overview>
Template literal types build and match string types with the syntax of JavaScript template literals. With `infer`, they parse and transform strings at the type level.
</overview>

<syntax>
A template literal type describes a string pattern. The first assignment compiles, and the second fails, because `"Hi, World"` does not match the pattern.

```typescript
type Greeting = `Hello, ${string}`;

const valid: Greeting = "Hello, World";
const invalid: Greeting = "Hi, World";
```
</syntax>

<union_expansion>
A union inside a template expands to every combination. Here `SizedColor` is the union of nine strings, from `"small-red"` to `"large-green"`.

```typescript
type Size = "small" | "medium" | "large";
type Color = "red" | "blue" | "green";

type SizedColor = `${Size}-${Color}`;
```
</union_expansion>

<pattern_matching>
`infer` in a template captures part of a string. `RemoveMaps<"maps:longitude">` is `"longitude"`, and `RemoveMaps<"other">` is `"other"`. `RemovePostSuffix<"attribute:post">` is `"attribute"`.

```typescript
type RemoveMaps<T> = T extends `maps:${infer Rest}` ? Rest : T;

type RemovePostSuffix<T> = T extends `${infer Prefix}:post` ? Prefix : T;
```

Recursion splits a string on a delimiter. Here `Parts` is `["a", "b", "c"]`.

```typescript
type Split<S extends string, D extends string> =
  S extends `${infer Head}${D}${infer Tail}`
    ? [Head, ...Split<Tail, D>]
    : S extends ""
    ? []
    : [S];

type Parts = Split<"a-b-c", "-">;
```
</pattern_matching>

<case_utilities>
Four built-in types change the case of a string type. In this block, the types are `"HELLO"`, `"hello"`, `"Hello"`, and `"hello"`.

```typescript
type Upper = Uppercase<"hello">;
type Lower = Lowercase<"HELLO">;
type Cap = Capitalize<"hello">;
type Uncap = Uncapitalize<"Hello">;
```
</case_utilities>

<name_generation>
Templates generate related names from a base name. `CamelCase<"background-color">` is `"backgroundColor"`, and `CamelCase<"border-top-width">` is `"borderTopWidth"`.

```typescript
type CamelCase<S extends string> =
  S extends `${infer P1}-${infer P2}${infer P3}`
    ? `${Lowercase<P1>}${Uppercase<P2>}${CamelCase<P3>}`
    : Lowercase<S>;
```

Event and accessor names follow the same idea. `MouseHandlers` is `"onClick" | "onMousedown" | "onMouseup"`. `Getters` is `"getName" | "getAge"`, and `Setters` is `"setName" | "setAge"`.

```typescript
type EventName<T extends string> = `on${Capitalize<T>}`;

type MouseEvents = "click" | "mousedown" | "mouseup";
type MouseHandlers = EventName<MouseEvents>;

type Getter<T extends string> = `get${Capitalize<T>}`;
type Setter<T extends string> = `set${Capitalize<T>}`;

type PropName = "name" | "age";
type Getters = Getter<PropName>;
type Setters = Setter<PropName>;
```
</name_generation>

<key_transformation>
Key remapping with `as` applies a template to every key. `PrefixedUser` is `{ user_name: string; user_age: number }`, and `NewData` is `{ a_new: number; b_new: number }`.

```typescript
type AddPrefix<T, P extends string> = {
  [K in keyof T as K extends string ? `${P}${K}` : K]: T[K];
};

interface User {
  name: string;
  age: number;
}

type PrefixedUser = AddPrefix<User, "user_">;

type AddSuffix<T, S extends string> = {
  [K in keyof T as K extends string ? `${K}${S}` : never]: T[K];
};

interface Data {
  a: number;
  b: number;
}

type NewData = AddSuffix<Data, "_new">;
```

A recursive template converts snake case keys to camel case. Here `CamelResponse` is `{ userId: string; firstName: string; lastName: string }`.

```typescript
type SnakeToCamel<S extends string> =
  S extends `${infer P1}_${infer P2}${infer P3}`
    ? `${Lowercase<P1>}${Uppercase<P2>}${SnakeToCamel<P3>}`
    : S;

type CamelizeKeys<T> = {
  [K in keyof T as K extends string ? SnakeToCamel<K> : K]: T[K];
};

interface ApiResponse {
  user_id: string;
  first_name: string;
  last_name: string;
}

type CamelResponse = CamelizeKeys<ApiResponse>;
```
</key_transformation>

<route_parameters>
A recursive template collects route parameters, and a mapped type turns them into an object. Here `Params` is `"userId" | "postId"`, and `UserPostParams` is `{ userId: string; postId: string }`.

```typescript
type ExtractRouteParams<T extends string> =
  T extends `${string}:${infer Param}/${infer Rest}`
    ? Param | ExtractRouteParams<`/${Rest}`>
    : T extends `${string}:${infer Param}`
    ? Param
    : never;

type Params = ExtractRouteParams<"/users/:userId/posts/:postId">;

type RouteParams<T extends string> = {
  [K in ExtractRouteParams<T>]: string;
};

type UserPostParams = RouteParams<"/users/:userId/posts/:postId">;
```
</route_parameters>

<validation_patterns>
A template can reject literal strings with the wrong shape at compile time. In this block, both first calls compile. The calls with `"invalid"` and the `ftp` URL fail. This check sees only literal types, so validate runtime input as well.

```typescript
type ValidEmail = `${string}@${string}.${string}`;

function validateEmail<T extends string>(
  email: T extends ValidEmail ? T : never
): T {
  return email;
}

validateEmail("user@example.com");
validateEmail("invalid");

type Protocol = "http" | "https";
type ValidUrl = `${Protocol}://${string}`;

function fetchUrl(url: ValidUrl): Promise<Response> {
  return fetch(url);
}

fetchUrl("https://api.example.com");
fetchUrl("ftp://files.example.com");
```
</validation_patterns>

<complex_parsing>
Recursive templates parse structured strings. `QueryParams` is `{ name: "John" } & { age: "30" } & { city: "NYC" }`, and `Path` is `["user", "address", "city"]`.

```typescript
type ParseQueryString<T extends string> =
  T extends `${infer Key}=${infer Value}&${infer Rest}`
    ? { [K in Key]: Value } & ParseQueryString<Rest>
    : T extends `${infer Key}=${infer Value}`
    ? { [K in Key]: Value }
    : {};

type QueryParams = ParseQueryString<"name=John&age=30&city=NYC">;

type ParsePath<T extends string> =
  T extends `${infer Key}.${infer Rest}`
    ? [Key, ...ParsePath<Rest>]
    : [T];

type Path = ParsePath<"user.address.city">;
```
</complex_parsing>

<when_to_use>
Template literal types fit six situations.

- Strings must match a known pattern.
- Object keys need a systematic rename.
- Routes need typed parameters.
- An event system needs generated handler names.
- Code builds strings from typed parts.
- An API contract fixes the shape of URLs or paths.
</when_to_use>

<pitfalls>
Recursive template types have a depth limit. A recursion that is not in tail position, as in this type, fails on long strings.

```typescript
type DeepSplit<S extends string> = S extends `${infer H}${infer T}`
  ? [H, ...DeepSplit<T>]
  : [];
```

Literal text at the end of a pattern must match the end of the string. So `GetPath<"folder/file.backup.json">` is `"folder/file.backup"`, including `.backup`.

```typescript
type GetPath<T> = T extends `${infer Path}.json` ? Path : never;

type Test = GetPath<"folder/file.backup.json">;
```

Templates accept only string, number, and similar keys, not symbols. The check `K extends string` in a key remap filters symbol keys out.

```typescript
type AddPrefix<T, P extends string> = {
  [K in keyof T as K extends string ? `${P}${K}` : never]: T[K];
};
```

Keep patterns simple, because complex recursive patterns are hard to debug and slow down type checking. Check empty strings, single characters, and strings that do not match. Prefer `Uppercase`, `Lowercase`, and the other built-in types over your own versions.
</pitfalls>
