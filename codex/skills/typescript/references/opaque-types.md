<overview>
Opaque types, also called branded or nominal types, create distinct types from a primitive. They stop the mix-up of values that share a primitive type but mean different things.
</overview>
<contents>
This file has these sections, in order.
- the problem
- creating opaque types
- type predicates
- assertion functions
- predicate versus assertion
- registration example
- factory functions
- when to use
- pitfalls
</contents>


<the_problem>
TypeScript compares types by structure, so two aliases of `string` are interchangeable. The last call passes a post ID where a user ID belongs, and it compiles without an error.

```typescript
type UserId = string;
type PostId = string;

declare function getUser(id: UserId): User;
declare function getPost(id: PostId): Post;

const userId: UserId = "user-123";
const postId: PostId = "post-456";

getUser(postId);
```
</the_problem>

<creating_opaque_types>
A phantom property makes each type distinct. The property exists only in the type, never at runtime.

```typescript
type Opaque<TValue, TBrand> = TValue & { __brand: TBrand };

type UserId = Opaque<string, "UserId">;
type PostId = Opaque<string, "PostId">;
type ValidEmail = Opaque<string, "ValidEmail">;
type ValidAge = Opaque<number, "ValidAge">;
```

Now the two IDs are incompatible. The last call reports "Type 'PostId' is not assignable to type 'UserId'".

```typescript
declare function getUser(id: UserId): User;
declare function getPost(id: PostId): Post;

const userId = "user-123" as UserId;
const postId = "post-456" as PostId;

getUser(userId);
getUser(postId);
```

A `unique symbol` key is a sturdier brand, because a real object can never have that property by accident.

```typescript
declare const brand: unique symbol;

type Brand<T, TBrand> = T & { [brand]: TBrand };

type UserId = Brand<string, "UserId">;
type PostId = Brand<string, "PostId">;
```
</creating_opaque_types>

<type_predicates>
A type predicate validates a value and narrows it to the branded type. After the check in `processEmail`, `email` has the type `ValidEmail`.

```typescript
type ValidEmail = Opaque<string, "ValidEmail">;

const isValidEmail = (email: string): email is ValidEmail => {
  return email.includes("@") && email.includes(".");
};

function processEmail(email: string): void {
  if (!isValidEmail(email)) {
    throw new Error("Invalid email");
  }

  sendEmail(email);
}

declare function sendEmail(email: ValidEmail): void;
```
</type_predicates>

<assertion_functions>
An assertion function throws on invalid input and narrows the type after the call. After `assertValidEmail(data.email)`, `data.email` has the type `ValidEmail`.

```typescript
type ValidEmail = Opaque<string, "ValidEmail">;

function assertValidEmail(email: string): asserts email is ValidEmail {
  if (!email.includes("@") || !email.includes(".")) {
    throw new Error("Invalid email format");
  }
}

async function createUser(data: { email: string }): Promise<User> {
  assertValidEmail(data.email);

  return await saveUser({
    email: data.email,
  });
}
```

A call to an assertion function needs an explicit type on the function name. A plain arrow function assigned to a `const` fails at the call. The error says "Assertions require every name in the call target to be declared with an explicit type annotation". Use a function declaration, or annotate the `const` with the function type.

```typescript
const assertBad = (email: string): asserts email is ValidEmail => {
  if (!email.includes("@")) throw new Error("Invalid email");
};

function assertGood(email: string): asserts email is ValidEmail {
  if (!email.includes("@")) throw new Error("Invalid email");
}

const assertTyped: (email: string) => asserts email is ValidEmail = (email) => {
  if (!email.includes("@")) throw new Error("Invalid email");
};
```
</assertion_functions>

<predicate_versus_assertion>
The two narrowing forms differ in how they report failure.

| Aspect | Type predicate | Assertion function |
|---|---|---|
| Return type | `boolean` | `void`, and it throws on failure |
| Usage | Inside an `if` condition | A standalone call |
| Failure handling | The caller handles it | The function throws |
| Declaration | Arrow function or function | Function declaration or a `const` with an explicit type |

With a predicate, the caller decides what happens on failure. With an assertion, the happy path reads straight through.

```typescript
if (!isValidEmail(email)) {
  return { error: "Invalid email" };
}
sendEmail(email);

assertValidEmail(email);
sendEmail(email);
```
</predicate_versus_assertion>

<registration_example>
In this example, `createUser` accepts only validated values. The handler must call both assertions before it calls `createUser`.

```typescript
type Opaque<TValue, TBrand> = TValue & { __brand: TBrand };

type ValidEmail = Opaque<string, "ValidEmail">;
type ValidPassword = Opaque<string, "ValidPassword">;
type UserId = Opaque<string, "UserId">;

function assertValidEmail(email: string): asserts email is ValidEmail {
  if (!email.includes("@") || email.length < 5) {
    throw new Error("Invalid email format");
  }
}

function assertValidPassword(password: string): asserts password is ValidPassword {
  if (password.length < 8) {
    throw new Error("Password must be at least 8 characters");
  }
}

async function createUser(data: {
  email: ValidEmail;
  password: ValidPassword;
}): Promise<{ id: UserId }> {
  return { id: crypto.randomUUID() as UserId };
}

async function handleRegistration(input: { email: string; password: string }) {
  assertValidEmail(input.email);
  assertValidPassword(input.password);

  return createUser({
    email: input.email,
    password: input.password,
  });
}
```
</registration_example>

<factory_functions>
A factory validates a value when it creates the branded type. `createUserId` throws on bad input, and `parseUserId` returns `null` instead.

```typescript
type UserId = Opaque<string, "UserId">;

function createUserId(id: string): UserId {
  if (!id.startsWith("user_")) {
    throw new Error("Invalid user ID format");
  }
  return id as UserId;
}

function parseUserId(id: string): UserId | null {
  if (!id.startsWith("user_")) {
    return null;
  }
  return id as UserId;
}
```
</factory_functions>

<when_to_use>
Opaque types fit four kinds of values.

- IDs such as `UserId`, `PostId`, and `OrderId`, so different entity IDs cannot mix.
- Validated strings such as an email, a URL, or a phone number.
- Validated numbers such as an age, a price, or a quantity.
- Sensitive values such as a hashed password or an API key, so they are not exposed by accident.
</when_to_use>

<pitfalls>
A cast bypasses the brand. Direct assignment of a plain string fails to compile, but `as ValidEmail` compiles without any check. Keep casts inside the validation and factory functions.

```typescript
const email1: ValidEmail = "invalid";

const email2 = "invalid" as ValidEmail;
```

A cast in place of validation defeats the purpose. The first call casts unvalidated input. The second validates it with an assertion first.

```typescript
declare function processUser(userId: UserId): void;

processUser(request.body.id as UserId);

function assertUserId(id: string): asserts id is UserId {
  if (!id.startsWith("user_")) throw new Error("Invalid user ID");
}

assertUserId(request.body.id);
processUser(request.body.id);
```
</pitfalls>
