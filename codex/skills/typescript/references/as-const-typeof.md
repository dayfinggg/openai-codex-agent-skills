<overview>
The pair `as const` and `typeof` derives types from runtime values. One object then serves as the single source of truth at runtime and at compile time.
</overview>

<as_const>
A const assertion makes an object deeply readonly and keeps literal types instead of widened types. Without `as const`, this object has the type `{ GROUP: string; ANNOUNCEMENT: string }`.

```typescript
const config = {
  GROUP: "group",
  ANNOUNCEMENT: "announcement",
};
```

With `as const`, the type becomes `{ readonly GROUP: "group"; readonly ANNOUNCEMENT: "announcement" }`.

```typescript
const config = {
  GROUP: "group",
  ANNOUNCEMENT: "announcement",
} as const;
```

The assertion has three effects. Properties become readonly at every level. Values keep their literal types. Arrays become readonly tuples, so this array has the type `readonly ["home", "about", "contact"]` instead of `string[]`.

```typescript
const routes = ["home", "about", "contact"] as const;
```
</as_const>

<typeof>
The `typeof` operator in a type position takes the type of a runtime value. In this example, `BackendProgram` is the union of the keys, `"GROUP" | "ANNOUNCEMENT" | "ONE_ON_ONE" | "SELF_DIRECTED"`. `FrontendProgram` uses an indexed access and is the union of the values, `"group" | "announcement" | "1on1" | "selfDirected"`.

```typescript
const programModeEnumMap = {
  GROUP: "group",
  ANNOUNCEMENT: "announcement",
  ONE_ON_ONE: "1on1",
  SELF_DIRECTED: "selfDirected",
} as const;

type ProgramMap = typeof programModeEnumMap;

type BackendProgram = keyof typeof programModeEnumMap;

type FrontendProgram = typeof programModeEnumMap[keyof typeof programModeEnumMap];
```
</typeof>

<object_values>
The pattern `Obj[keyof Obj]` works like `Object.values()` for types. Here `StatusCode` is `200 | 201 | 400 | 404`.

```typescript
const statusCodes = {
  OK: 200,
  CREATED: 201,
  BAD_REQUEST: 400,
  NOT_FOUND: 404,
} as const;

type StatusCode = typeof statusCodes[keyof typeof statusCodes];
```
</object_values>

<subset_selection>
A union of keys in the index selects a subset of the values. With the `programModeEnumMap` above, `IndividualProgram` is `"1on1" | "selfDirected"`.

```typescript
type ProgramMap = typeof programModeEnumMap;

type IndividualProgram = ProgramMap["ONE_ON_ONE" | "SELF_DIRECTED"];
```
</subset_selection>

<when_to_use>
The pattern fits five kinds of data.

- Configuration objects that runtime code and types both read.
- Enum replacements with string or number values.
- Route definitions with their metadata.
- Mappings between two representations, such as backend and frontend names.
- Event names and their payloads.
</when_to_use>

<pitfalls>
A missing `as const` loses the literal types. In this object, `Color` is only `string`.

```typescript
const colors = {
  RED: "#ff0000",
  GREEN: "#00ff00",
};
type Color = typeof colors[keyof typeof colors];
```

With `as const`, `Color` is `"#ff0000" | "#00ff00"`.

```typescript
const colors = {
  RED: "#ff0000",
  GREEN: "#00ff00",
} as const;
type Color = typeof colors[keyof typeof colors];
```

An object with `as const` is readonly, so a mutation fails to compile. The assignment in this example reports "Cannot assign to 'timeout' because it is a read-only property".

```typescript
const config = {
  timeout: 5000,
} as const;

config.timeout = 10000;
```
</pitfalls>

<complete_example>
This example defines HTTP methods once and derives three types from them. `HttpMethod` is the union of all five methods, `SafeMethod` is `"GET"`, and `MutatingMethod` holds the other four. The call with `"INVALID"` fails to compile.

```typescript
const HTTP_METHODS = {
  GET: "GET",
  POST: "POST",
  PUT: "PUT",
  DELETE: "DELETE",
  PATCH: "PATCH",
} as const;

type HttpMethod = typeof HTTP_METHODS[keyof typeof HTTP_METHODS];

type SafeMethod = typeof HTTP_METHODS["GET"];

type MutatingMethod = typeof HTTP_METHODS["POST" | "PUT" | "DELETE" | "PATCH"];

function makeRequest(method: HttpMethod, url: string): void {}

makeRequest(HTTP_METHODS.GET, "/api/users");
makeRequest("INVALID", "/api/users");
```
</complete_example>
