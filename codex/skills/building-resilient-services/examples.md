# Resilience examples

Illustrative. Copy the reasoning, not the exact shape.

## Idempotent message handler (Python and SQL)

Before

```python
import json


def handle_payment_captured(conn, message):
    payment = json.loads(message.body)
    conn.execute(
        "UPDATE accounts SET balance_minor = balance_minor + %s WHERE id = %s",
        (payment["amount_minor"], payment["account_id"]),
    )
    conn.commit()
    message.ack()
```

After

```sql
CREATE TABLE processed_messages (
    consumer text NOT NULL,
    message_id text NOT NULL,
    processed_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (consumer, message_id)
);
```

```python
import json
from typing import Protocol

import psycopg

CONSUMER_NAME = "ledger.payment-captured"


class Message(Protocol):
    message_id: str
    body: bytes

    def ack(self) -> None: ...


def handle_payment_captured(conn: psycopg.Connection, message: Message) -> None:
    payment = json.loads(message.body)
    with conn.transaction():
        claimed = conn.execute(
            "INSERT INTO processed_messages (consumer, message_id) "
            "VALUES (%s, %s) ON CONFLICT DO NOTHING",
            (CONSUMER_NAME, message.message_id),
        ).rowcount
        if claimed:
            conn.execute(
                "UPDATE accounts SET balance_minor = balance_minor + %s WHERE id = %s",
                (payment["amount_minor"], payment["account_id"]),
            )
    message.ack()
```

A redelivery after a crash between commit and acknowledgement used to credit the account twice. The producer's message ID is now claimed in the same transaction as the credit, the primary key makes a concurrent duplicate lose, and a redelivered message is acknowledged without a second credit.
