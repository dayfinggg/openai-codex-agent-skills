# Pattern catalog

One entry per pattern, in the order of the smell table in SKILL.md, with Singleton last. Refactoring names come from the refactoring.com catalog, which supports Refactoring 2nd Edition. Where the catalog names no refactoring for a pattern, the entry says so and gives the closest steps.

## Contents

- Strategy
- State
- Null Object
- Factory
- Builder
- Adapter
- Decorator
- Observer
- Command
- Template Method
- Facade
- Composite
- Singleton

## Strategy

- **Signal.** The same switch or if chain on a type code appears in several places, or an algorithm is chosen at run time from variants that exist today.
- **Simplest form.** A function passed as a parameter, or a map from key to function. One class per variant when variants hold state or share several operations.
- **Cost.** One more function or type per variant, and the reader must find which variant runs at a call site.
- **Introduced by.** Replace Conditional with Polymorphism, or Replace Type Code with Subclasses, which the catalog also lists as Replace Type Code with State/Strategy.
- **Removed by.** Inline Function or Inline Class for a lone variant, Collapse Hierarchy or Remove Subclass when the variants have converged.
- **Not when.** The conditional is short and appears once, or the variants differ only by a value that belongs in a parameter or a table.

## State

- **Signal.** An object's behavior depends on its current state, the same state checks repeat across many methods, and transitions follow rules.
- **Simplest form.** An enum with one transition table or one switch in one place. One type per state when each state has substantial behavior of its own.
- **Cost.** The transitions spread across state types, so the whole state machine is harder to see at once.
- **Introduced by.** Replace Type Code with Subclasses, then Replace Conditional with Polymorphism.
- **Removed by.** Remove Subclass or Collapse Hierarchy when the states no longer differ in behavior.
- **Not when.** There are a few states with little behavior each. An enum and guard clauses are enough.

## Null Object

- **Signal.** Callers check for a missing object before each use and then do the same default thing.
- **Simplest form.** One object of the same type whose members return the default behavior.
- **Cost.** It hides absence, so code that must treat a missing object differently can no longer tell, and a bug caused by a missing value surfaces later.
- **Introduced by.** Introduce Special Case, which the catalog also lists as Introduce Null Object.
- **Removed by.** The catalog lists no inverse. Restore explicit checks at the callers that need them, then Remove Subclass or Inline Class for the special case.
- **Not when.** Callers react to absence in different ways, or absence is an error. Use an optional type, a result type, or an error instead.

## Factory

- **Signal.** The type to create depends on input, creation needs a descriptive name, or the same construction steps repeat at several call sites.
- **Simplest form.** A factory function next to the type. A factory object only when whole families of related objects must be swapped together.
- **Cost.** One more hop between the caller and the constructor, and a second place to change when construction changes.
- **Introduced by.** Replace Constructor with Factory Function, which the catalog also lists as Replace Constructor with Factory Method.
- **Removed by.** Inline Function, so callers use the constructor again.
- **Not when.** The factory only forwards to one constructor with the same arguments.

## Builder

- **Signal.** Many optional parameters, telescoping constructors, or an object assembled in steps that is valid only when complete.
- **Simplest form.** Named or keyword arguments with defaults, or a parameter object. A builder class mainly in languages without named arguments, such as Java and Go.
- **Cost.** A second type that mirrors the fields of the product and must stay in sync with it.
- **Introduced by.** The catalog names no refactoring for it. Start with Introduce Parameter Object and grow the object into a builder only when stepwise assembly is really needed.
- **Removed by.** Inline Class into a constructor with named arguments or a parameter object.
- **Not when.** The object has a few fields and the language has named arguments.

## Adapter

- **Signal.** A third-party, legacy, or external interface does not match the shape callers need, or its types spread through the codebase.
- **Simplest form.** A small module or class you own that exposes only the operations callers use, in your own types.
- **Cost.** One more layer to update whenever the wrapped interface changes.
- **Introduced by.** The catalog names no refactoring for it. Extract Function around each foreign call, then Combine Functions into Class.
- **Removed by.** Remove Middle Man or Inline Class when the wrapper only renames calls one to one.
- **Not when.** The interface already fits and is your own code. For adapters at architecture boundaries, follow the applying-clean-architecture skill.

## Decorator

- **Signal.** Optional behavior such as caching, logging, or metrics wraps an operation in several combinations, and a subclass per combination would multiply.
- **Simplest form.** A higher-order function that wraps another function, or the middleware, interceptor, or decorator mechanism the language or framework already has.
- **Cost.** The order of wrappers matters and is invisible at the call site, and stack traces grow deeper.
- **Introduced by.** The catalog names no refactoring for it. Replace Subclass with Delegate or Replace Superclass with Delegate moves the behavior from inheritance to composition first.
- **Removed by.** Inline Function or Inline Class when only one combination is ever used, then Remove Middle Man for wrappers that only forward.
- **Not when.** Only one combination exists. Put the behavior in the function itself.

## Observer

- **Signal.** Several independent parts must react when something happens, and the source must not depend on them.
- **Simplest form.** A list of callbacks, or the event or signal mechanism of the language or framework.
- **Cost.** Control flow becomes implicit, the order and error handling of listeners must be decided, and listeners that are never unregistered keep objects alive.
- **Introduced by.** The catalog names no refactoring for it. Extract Function for each reaction, then register those functions instead of calling them inline.
- **Removed by.** Inline Function, so the source calls its single listener directly.
- **Not when.** There is one listener known when the code is written. A direct call is clearer. For events across processes, follow the building-resilient-services skill.

## Command

- **Signal.** Requests must be queued, scheduled, logged, undone, or replayed as values.
- **Simplest form.** A closure or function value. A plain data record plus a handler when the request must be serialized or stored.
- **Cost.** One type per operation, and the reader follows `execute` calls instead of direct calls.
- **Introduced by.** Replace Function with Command, which the catalog also lists as Replace Method with Method Object.
- **Removed by.** Replace Command with Function.
- **Not when.** The command is created and executed in the same place and is never stored, logged, or undone.

## Template Method

- **Signal.** Several algorithms share the same fixed sequence of steps and differ in one or two of them.
- **Simplest form.** One function that takes the varying steps as function parameters.
- **Cost.** Inheritance couples every subclass to the base class, and the reader jumps between them to follow one run.
- **Introduced by.** The catalog names no refactoring for it. Extract Function for the shared steps, then Extract Superclass and Pull Up Method.
- **Removed by.** Replace Superclass with Delegate or Replace Subclass with Delegate to move to composition, or Collapse Hierarchy when one subclass remains.
- **Not when.** The language has first-class functions and the varying steps share no state. Pass the step as a function.

## Facade

- **Signal.** Callers coordinate several objects of a subsystem in the same order, and the sequence repeats at many call sites.
- **Simplest form.** One function or module for the common path, with the subsystem still available for unusual cases.
- **Cost.** A central place that grows into a large class if every new need is added to it.
- **Introduced by.** The catalog names no refactoring for it. Extract Function for the repeated sequence and Move Function into a module, or Hide Delegate for chains through collaborators.
- **Removed by.** Remove Middle Man or Inline Class when it only forwards to one object.
- **Not when.** It would forward one to one to a single object.

## Composite

- **Signal.** A tree of parts and wholes, such as menus, expressions, or nested UI components, where callers treat a leaf and a group the same way.
- **Simplest form.** Recursive data, meaning a type with children of the same type, and one recursive function. In languages with sum types, a sealed hierarchy or enum with pattern matching.
- **Cost.** A shared interface can force leaves to offer child operations that make no sense for them.
- **Introduced by.** The catalog names no refactoring for it. Extract Superclass for the interface that leaves and groups share.
- **Removed by.** Collapse Hierarchy when the structure is only one level deep.
- **Not when.** The structure is flat. A list is enough.

## Singleton

- **Signal.** Code reaches a global instance through a static accessor such as `Config.instance()` or `Database.get()`.
- **Simplest form.** None to introduce. Create the one instance in the composition root and pass it in. A value that never changes can be a constant.
- **Cost.** Hidden global state, hidden dependencies, initialization order problems, and tests that leak state into each other. The C++ Core Guidelines rule I.3 calls singletons "basically complicated global objects in disguise".
- **Introduced by.** Avoid it. When one shared instance is needed, use the singleton lifetime of the project's dependency injection container, because the instance is still passed in.
- **Removed by.** Replace Query with Parameter at each function that reads the global, so callers pass the instance, then delete the static accessor.
- **Not when.** Avoid it by default. The C++ Core Guidelines allow one exception, a function-local static for initialization on first use.
