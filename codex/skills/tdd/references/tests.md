<good_tests>
A good test is integration-style. It tests through real interfaces, not through mocks of internal parts. This good test checks observable behavior.

```typescript
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

A good test has these characteristics.
- It tests the behavior that users and callers care about.
- It uses the public API only.
- It survives internal refactors.
- It describes what the code does, not how.
- It makes one logical assertion.
</good_tests>

<bad_tests>
An implementation-detail test is coupled to internal structure. This bad test checks an implementation detail.

```typescript
test("checkout calls paymentService.process", async () => {
  const processSpy = jest.spyOn(paymentService, "process");
  await checkout(cart, payment);
  expect(processSpy).toHaveBeenCalledWith(cart.total);
});
```

These signs mark an implementation-detail test.
- It mocks internal collaborators.
- It tests private methods.
- It asserts on call counts or call order.
- It breaks on a refactor that leaves behavior unchanged.
- Its name describes how the code works, not what it does.
- It verifies through external means instead of the interface.

This bad test bypasses the interface to verify a write.

```typescript
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});
```

This good test verifies the same write through the interface.

```typescript
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

In a tautological test, the expected value restates the implementation, so the test passes by construction. This bad test recomputes the expected value the way the code computes it.

```typescript
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});
```

This good test uses an independent, known literal as the expected value.

```typescript
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
</bad_tests>
