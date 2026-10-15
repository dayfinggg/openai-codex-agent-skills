# Database examples

These examples are illustrative.

## Contents

- Repository with parameterized SQL (Python)
- Allow-listed sorting
- Expand and contract migration (PostgreSQL)
- MongoDB collection with validation and a safe filter

## Repository with parameterized SQL (Python)

The use case owns the interface, the adapter owns the SQL.

```python
import sqlite3
from dataclasses import dataclass
from datetime import datetime
from typing import Protocol


@dataclass(frozen=True)
class Order:
    id: str
    customer_id: str
    total_minor: int
    created_at: datetime


@dataclass(frozen=True)
class OrderPage:
    orders: list[Order]
    next_cursor: tuple[str, str] | None


class OrderRepository(Protocol):
    def recent_for_customer(
        self, customer_id: str, limit: int, after: tuple[str, str] | None = None
    ) -> OrderPage: ...


class SqliteOrderRepository:
    def __init__(self, connection: sqlite3.Connection):
        self._connection = connection

    def recent_for_customer(self, customer_id, limit, after=None):
        query = (
            "SELECT id, customer_id, total_minor, created_at FROM orders "
            "WHERE customer_id = ? "
        )
        params = [customer_id]
        if after is not None:
            query += "AND (created_at, id) < (?, ?) "
            params.extend(after)
        query += "ORDER BY created_at DESC, id DESC LIMIT ?"
        params.append(limit)
        rows = self._connection.execute(query, params).fetchall()
        orders = [self._to_order(row) for row in rows]
        next_cursor = (rows[-1][3], rows[-1][0]) if len(rows) == limit else None
        return OrderPage(orders, next_cursor)

    @staticmethod
    def _to_order(row) -> Order:
        order_id, customer_id, total_minor, created_at = row
        return Order(order_id, customer_id, total_minor, datetime.fromisoformat(created_at))
```

User input reaches the database only as bound parameters, and the domain receives `Order` objects, never rows.

## Allow-listed sorting

Column names cannot be bound parameters, so map them.

```python
SORT_COLUMNS = {
    "newest": "created_at DESC, id DESC",
    "oldest": "created_at ASC, id ASC",
    "largest": "total_minor DESC, id DESC",
}


def order_by_clause(sort_key: str) -> str:
    try:
        return SORT_COLUMNS[sort_key]
    except KeyError:
        raise ValueError(f"Unsupported sort: {sort_key}") from None
```

## Expand and contract migration (PostgreSQL)

Goal. Replace the free text `customers.full_name` with `first_name` and `last_name` without downtime.

Release 1, expand.

```sql
ALTER TABLE customers ADD COLUMN first_name text;
ALTER TABLE customers ADD COLUMN last_name text;
```

Release 1 code writes all three columns and reads the new ones, falling back to `full_name` when they are empty.

Backfill in batches, repeated until no rows change.

```sql
UPDATE customers
SET first_name = split_part(full_name, ' ', 1),
    last_name = substr(full_name, length(split_part(full_name, ' ', 1)) + 2)
WHERE id IN (
    SELECT id FROM customers
    WHERE first_name IS NULL
    LIMIT 1000
);
```

Release 2 code reads and writes only the new columns, then the constraint is added.

```sql
ALTER TABLE customers ALTER COLUMN first_name SET NOT NULL;
```

Release 3, contract.

```sql
ALTER TABLE customers DROP COLUMN full_name;
```

## MongoDB collection with validation and a safe filter

```javascript
db.createCollection("orders", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["customerId", "status", "items", "createdAt", "schemaVersion"],
      properties: {
        customerId: { bsonType: "string" },
        status: { enum: ["pending", "paid", "shipped", "cancelled"] },
        items: {
          bsonType: "array",
          maxItems: 200,
          items: {
            bsonType: "object",
            required: ["productId", "quantity", "priceMinor"],
            properties: {
              productId: { bsonType: "string" },
              quantity: { bsonType: "int", minimum: 1 },
              priceMinor: { bsonType: "long" }
            }
          }
        },
        createdAt: { bsonType: "date" },
        schemaVersion: { bsonType: "int" }
      }
    }
  }
});

db.orders.createIndex({ customerId: 1, status: 1, createdAt: -1 });
```

Line items are embedded because they are read and written with the order and their number is bounded. The index follows the equality, sort, range rule for the common query.

```typescript
const ORDER_STATUSES = ["pending", "paid", "shipped", "cancelled"] as const;
type OrderStatus = (typeof ORDER_STATUSES)[number];

function parseStatus(value: unknown): OrderStatus {
  if (typeof value === "string" && (ORDER_STATUSES as readonly string[]).includes(value)) {
    return value as OrderStatus;
  }
  throw new Error(`Invalid order status: ${String(value)}`);
}

async function findOrders(customerId: string, rawStatus: unknown) {
  return orders
    .find(
      { customerId, status: parseStatus(rawStatus) },
      { projection: { items: 0 } },
    )
    .sort({ createdAt: -1 })
    .limit(50)
    .toArray();
}
```

The filter is built from validated values, so a request body such as `{"status": {"$ne": null}}` cannot change the query.
