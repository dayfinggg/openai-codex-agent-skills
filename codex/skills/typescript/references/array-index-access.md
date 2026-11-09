<overview>
An indexed access type gets the element types of an array or tuple. The index `[number]` gives the union of all element types.
</overview>
<contents>
This file has these sections, in order.
- basic concept
- element types
- tuple versus array
- parameter types
- when to use
- access control example
- pitfalls
- conditional access
</contents>


<basic_concept>
A numeric index works like a string key on an object. In this example, `FirstRole` is `"user"`, `SecondRole` is `"admin"`, and `AnyRole` is `"user" | "admin" | "anonymous"`.

```typescript
const roles = ["user", "admin", "anonymous"] as const;

type FirstRole = typeof roles[0];
type SecondRole = typeof roles[1];

type AnyRole = typeof roles[number];
```

As an index, `number` stands for every numeric index at once. The type `typeof roles[0 | 1 | 2]` gives the same union, but `[number]` works for any length.
</basic_concept>

<element_types>
Two indexed accesses in a row collect values across a nested structure. Here `Role` is the union of the keys, and `UserAccessModelValues` is the union of the three readonly tuples. `Action` is the union of every action in every role, `"update-self" | "view" | "create" | "update-any" | "delete"`.

```typescript
const userAccessModel = {
  user: ["update-self", "view"],
  admin: ["create", "update-self", "update-any", "delete", "view"],
  anonymous: ["view"],
} as const;

type Role = keyof typeof userAccessModel;

type UserAccessModelValues = typeof userAccessModel[Role];

type Action = typeof userAccessModel[Role][number];
```
</element_types>

<tuple_versus_array>
A tuple keeps a type for each position, and an array has one element type. Here `TupleElements` is `"hello" | 42 | true`, and `ArrayElement` is `string`.

```typescript
const tuple = ["hello", 42, true] as const;
type TupleElements = typeof tuple[number];

const array: string[] = ["a", "b", "c"];
type ArrayElement = typeof array[number];
```
</tuple_versus_array>

<parameter_types>
`Parameters` returns a tuple, so `[number]` turns it into a union of the parameter types. Here `ParamsTuple` is `[a: string, b: string, c: number, d: boolean]`, and `ParamsUnion` is `string | number | boolean`.

```typescript
const funcWithManyParameters = (
  a: string,
  b: string,
  c: number,
  d: boolean,
) => {
  return [a, b, c, d].join(" ");
};

type ParamsTuple = Parameters<typeof funcWithManyParameters>;

type ParamsUnion = Parameters<typeof funcWithManyParameters>[number];
```
</parameter_types>

<when_to_use>
The pattern fits four kinds of data.

- Role-based access control, to collect every action or permission.
- Configuration, to collect every allowed value.
- Event systems, to collect event names from an array.
- Forms, to collect field names from a list of fields.
</when_to_use>

<access_control_example>
This example checks access with types derived from one object. The cast to `ReadonlyArray<Action>` is needed, because TypeScript cannot narrow the tuple by the role. The call with `"user"` and `"delete"` compiles and returns `false` at runtime. The call with `"invalid"` fails to compile.

```typescript
const userAccessModel = {
  user: ["update-self", "view"],
  admin: ["create", "update-self", "update-any", "delete", "view"],
  anonymous: ["view"],
} as const;

type Role = keyof typeof userAccessModel;
type Action = typeof userAccessModel[Role][number];

const canUserAccess = (role: Role, action: Action): boolean => {
  return (userAccessModel[role] as ReadonlyArray<Action>).includes(action);
};

canUserAccess("admin", "delete");
canUserAccess("user", "delete");
canUserAccess("admin", "invalid");
```
</access_control_example>

<pitfalls>
A missing `as const` on an array widens the elements. In this example, `Action` is only `string`.

```typescript
const actions = ["view", "edit", "delete"];
type Action = typeof actions[number];
```

With `as const`, `Action` is `"view" | "edit" | "delete"`.

```typescript
const actions = ["view", "edit", "delete"] as const;
type Action = typeof actions[number];
```

The method `.includes()` on a readonly tuple accepts only its element type. The first call reports "Argument of type 'string' is not assignable to parameter of type '"a" | "b" | "c"'". Widening the array type in the call fixes it.

```typescript
const items = ["a", "b", "c"] as const;
declare const someString: string;

items.includes(someString);

(items as readonly string[]).includes(someString);
```
</pitfalls>

<conditional_access>
A conditional type with `infer` extracts the element type too. Here `Permission` is `"read" | "write" | "admin"`.

```typescript
type ExtractArrayElements<T> = T extends readonly (infer U)[] ? U : never;

const permissions = ["read", "write", "admin"] as const;
type Permission = ExtractArrayElements<typeof permissions>;
```
</conditional_access>
