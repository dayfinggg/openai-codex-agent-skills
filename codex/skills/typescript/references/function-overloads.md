<overview>
Overloads give one function implementation several call signatures. TypeScript picks the signature that matches the arguments of each call.
</overview>
<contents>
This file has these sections, in order.
- syntax
- resolution order
- dom example
- wrapping overloaded functions
- class methods
- call signatures in types
- event handler pattern
- overloads versus unions
- pitfalls
- when to use
</contents>


<syntax>
Callers see only the overload signatures. The implementation signature comes last and must be compatible with every overload. Here `greet("Alice")` uses the first overload, and `greet("Alice", "Smith")` uses the second.

```typescript
function greet(name: string): string;
function greet(firstName: string, lastName: string): string;

function greet(nameOrFirst: string, lastName?: string): string {
  if (lastName) {
    return `Hello, ${nameOrFirst} ${lastName}!`;
  }
  return `Hello, ${nameOrFirst}!`;
}

greet("Alice");
greet("Alice", "Smith");
```
</syntax>

<resolution_order>
TypeScript tries the overloads from top to bottom and uses the first match. Put specific overloads first. Here `str` is `string` and `num` is `number`.

```typescript
function processValue(value: string): string;
function processValue(value: number): number;
function processValue(value: string | number): string | number {
  if (typeof value === "string") {
    return value.toUpperCase();
  }
  return value * 2;
}

const str = processValue("hello");
const num = processValue(42);
```
</resolution_order>

<dom_example>
The DOM declares `querySelector` with overloads, so a tag name gives a specific element type. This simplified version shows the two signatures. Here `body` is `HTMLBodyElement | null`, and `custom` is `Element | null`.

```typescript
interface Document {
  querySelector<K extends keyof HTMLElementTagNameMap>(
    selectors: K
  ): HTMLElementTagNameMap[K] | null;

  querySelector(selectors: string): Element | null;
}

const body = document.querySelector("body");
const custom = document.querySelector(".my-class");
```
</dom_example>

<wrapping_overloaded_functions>
A wrapper with one signature loses the overload behavior of the function it wraps. This wrapper returns `Element` even for `"body"`.

```typescript
export function nonNullQuerySelector(tag: string) {
  const element = document.querySelector(tag);
  if (!element) {
    throw new Error(`Element not found: ${tag}`);
  }
  return element;
}

const body = nonNullQuerySelector("body");
```

Mirroring the overloads keeps the inference. Here `body` is `HTMLBodyElement`, and `custom` is `Element`.

```typescript
export function nonNullQuerySelector<K extends keyof HTMLElementTagNameMap>(
  tag: K
): HTMLElementTagNameMap[K];
export function nonNullQuerySelector(tag: string): Element;
export function nonNullQuerySelector(tag: string): Element {
  const element = document.querySelector(tag);
  if (!element) {
    throw new Error(`Element not found: ${tag}`);
  }
  return element;
}

const body = nonNullQuerySelector("body");
const custom = nonNullQuerySelector(".custom");
```
</wrapping_overloaded_functions>

<class_methods>
Methods take overloads the same way. Here `sum` is `number` and `concat` is `string`.

```typescript
class Calculator {
  add(a: number, b: number): number;
  add(a: string, b: string): string;
  add(a: number | string, b: number | string): number | string {
    if (typeof a === "number" && typeof b === "number") {
      return a + b;
    }
    return String(a) + String(b);
  }
}

const calc = new Calculator();
const sum = calc.add(1, 2);
const concat = calc.add("hello", "world");
```
</class_methods>

<call_signatures_in_types>
An interface can declare several call signatures. An arrow function with a union return type cannot implement it. Its result `string | number` does not match the `string` result of the first signature. Implement it with an overloaded function declaration instead.

```typescript
interface StringOrNumberFunc {
  (value: string): string;
  (value: number): number;
}

function processImpl(value: string): string;
function processImpl(value: number): number;
function processImpl(value: string | number): string | number {
  if (typeof value === "string") {
    return value.toUpperCase();
  }
  return value * 2;
}

const process: StringOrNumberFunc = processImpl;
```
</call_signatures_in_types>

<event_handler_pattern>
Overloads map event names to event types. A specific overload covers known events, and a fallback covers custom ones. Here `e` is `MouseEvent` for `"click"`, `KeyboardEvent` for `"keydown"`, and `Event` for `"custom"`.

```typescript
interface EventMap {
  click: MouseEvent;
  keydown: KeyboardEvent;
  submit: SubmitEvent;
}

interface EventEmitter {
  on<K extends keyof EventMap>(
    event: K,
    handler: (e: EventMap[K]) => void
  ): void;

  on(event: string, handler: (e: Event) => void): void;
}

declare const emitter: EventEmitter;

emitter.on("click", (e) => {
  console.log(e.clientX);
});

emitter.on("keydown", (e) => {
  console.log(e.key);
});

emitter.on("custom", (e) => {
  console.log(e.type);
});
```
</event_handler_pattern>

<overloads_versus_unions>
Use overloads when the return type depends on the argument type. When the return type is always the same, a union parameter is simpler.

```typescript
function parse(input: string): object;
function parse(input: object): string;
function parse(input: string | object): string | object {
  if (typeof input === "string") {
    return JSON.parse(input);
  }
  return JSON.stringify(input);
}

function format(input: string | number): string {
  return String(input);
}
```

Overloads can combine with optional parameters. Here `"input"` returns `HTMLInputElement`, `"button"` returns `HTMLButtonElement`, and other tags return `HTMLElement`.

```typescript
function createElement(tag: "input"): HTMLInputElement;
function createElement(tag: "button", text?: string): HTMLButtonElement;
function createElement(tag: string, text?: string): HTMLElement;
function createElement(tag: string, text?: string): HTMLElement {
  const element = document.createElement(tag);
  if (text) {
    element.textContent = text;
  }
  return element;
}
```
</overloads_versus_unions>

<pitfalls>
Callers cannot see the implementation signature. The call with `true` reports "No overload matches this call", although the implementation could accept it at runtime.

```typescript
function example(a: string): string;
function example(a: number): number;
function example(a: string | number): string | number {
  return typeof a === "string" ? a.toUpperCase() : a * 2;
}

example(true);
```

A general overload before a specific one hides it. In `bad`, the `string` overload is never reached. In `good`, the specific overload comes first.

```typescript
function bad(x: any): any;
function bad(x: string): string;
function bad(x: any): any {
  return x;
}

function good(x: string): string;
function good(x: any): any;
function good(x: any): any {
  return x;
}
```

The implementation must handle every overload. Suppose the implementation accepts only `string`. Then the `number` overload reports "This overload signature is not compatible with its implementation signature". The fix accepts `string | number`.

```typescript
function process(x: string): string;
function process(x: number): number;
function process(x: string | number): string | number {
  if (typeof x === "string") {
    return x.toUpperCase();
  }
  return x * 2;
}
```
</pitfalls>

<when_to_use>
Overloads fit five situations.

- The return type depends on the argument type.
- A wrapper must mirror the overloads of the function it wraps.
- An event system maps event names to event types.
- A factory returns different types for different configurations.
- One operation needs several call shapes for compatibility.

Skip overloads when a union, an optional parameter, or one generic signature expresses the same contract.
</when_to_use>
