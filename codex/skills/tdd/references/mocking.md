<when_to_mock>
Mock only at system boundaries. These boundaries qualify.
- External APIs, such as payment or email.
- Databases, sometimes, though a test database is better.
- Time and randomness.
- The file system, sometimes.

Do not mock these things.
- Your own classes and modules.
- Internal collaborators.
- Anything you control.
</when_to_mock>

<designing_for_mockability>
At system boundaries, design interfaces that are easy to mock. Two techniques help.

The first technique is dependency injection. Pass external dependencies in instead of creating them internally. This version is easy to mock.

```typescript
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}
```

This version is hard to mock.

```typescript
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

The second technique prefers SDK-style interfaces over generic fetchers. Create a specific function for each external operation, instead of one generic function with conditional logic. In this good version, each function can be mocked independently.

```typescript
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: JSON.stringify(data) }),
};
```

In this bad version, the mock needs conditional logic inside it.

```typescript
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

The SDK approach has four benefits.
- Each mock returns one specific shape.
- Test setup has no conditional logic.
- It is easier to see which endpoints a test exercises.
- Each endpoint gets its own type safety.
</designing_for_mockability>
