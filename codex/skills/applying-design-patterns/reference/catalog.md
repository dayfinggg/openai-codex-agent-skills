# Pattern catalog

Refactoring names come from the refactoring.com catalog for Refactoring 2nd Edition. Where it names none for a pattern, the row gives the closest steps.

| Pattern | Cost | Introduce with | Remove with |
|---|---|---|---|
| Strategy | One more function or type per variant, and the reader must find which one runs | Replace Conditional with Polymorphism, or Replace Type Code with Subclasses | Inline Function or Inline Class for a lone variant, Collapse Hierarchy or Remove Subclass when variants converge |
| State | Transitions spread across state types, so the machine is hard to see at once | Replace Type Code with Subclasses, then Replace Conditional with Polymorphism | Remove Subclass or Collapse Hierarchy |
| Null Object | Hides absence, so a bug from a missing value surfaces later | Introduce Special Case | No catalog inverse. Restore explicit checks where needed, then Remove Subclass or Inline Class |
| Factory | One more hop to the constructor and a second place to change | Replace Constructor with Factory Function | Inline Function |
| Builder | A second type mirroring the product's fields | None named. Introduce Parameter Object, and grow it into a builder only for real stepwise assembly | Inline Class into a constructor with named arguments or a parameter object |
| Adapter | One more layer to update when the wrapped interface changes | None named. Extract Function around each foreign call, then Combine Functions into Class | Remove Middle Man or Inline Class |
| Decorator | Wrapper order matters and is invisible at the call site | None named. Replace Subclass with Delegate or Replace Superclass with Delegate first | Inline Function or Inline Class, then Remove Middle Man |
| Observer | Implicit control flow, listener order and errors to decide, leaks from listeners never unregistered | None named. Extract Function per reaction, then register the functions | Inline Function, calling the single listener directly |
| Command | One type per operation, and the reader follows `execute` calls | Replace Function with Command | Replace Command with Function |
| Template Method | Inheritance couples every subclass to the base | None named. Extract Function, then Extract Superclass and Pull Up Method | Replace Superclass with Delegate, or Collapse Hierarchy when one subclass remains |
| Facade | A central place that grows into a large class | None named. Extract Function and Move Function, or Hide Delegate | Remove Middle Man or Inline Class |
| Composite | Leaves may be forced to offer child operations | None named. Extract Superclass for the shared interface | Collapse Hierarchy when only one level deep |
| Singleton | Hidden global state, initialization order problems, tests that share state | Avoid it | Replace Query with Parameter at each reader, then delete the accessor |

Null Object fits only when every caller reacts to absence the same way. When callers differ or absence is an error, use an optional type, a result type, or an error. Keep the source returning null so code that must tell can still tell.

Builder as a class fits mainly languages without named arguments, such as Java and Go. The C++ Core Guidelines allow one Singleton exception, a function-local static for initialization on first use.
