# Observability examples

These pairs are illustrative. Copy the reasoning, not the exact shape.

## Contents

- String-built log message (C#)
- Concatenated log with personal data (Python)
- Token in a log line (TypeScript)
- Invented span attributes (Python)
- User ID in a metric attribute (Go)
- Log forging (Java)
- Logged and rethrown (TypeScript)
- Health endpoint that leaks (C#)

## String-built log message (C#)

Before

```csharp
public sealed class OrderService(IOrderRepository orders, ILogger<OrderService> logger)
{
    public async Task PlaceAsync(Order order, CancellationToken cancellationToken)
    {
        await orders.AddAsync(order, cancellationToken);
        logger.LogInformation($"Order {order.Id} placed by {order.CustomerEmail} with {order.Lines.Count} lines");
    }
}
```

After

```csharp
public sealed partial class OrderService(IOrderRepository orders, ILogger<OrderService> logger)
{
    public async Task PlaceAsync(Order order, CancellationToken cancellationToken)
    {
        await orders.AddAsync(order, cancellationToken);
        LogOrderPlaced(logger, order.Id, order.Lines.Count);
    }

    [LoggerMessage(Level = LogLevel.Information, Message = "Order {OrderId} placed with {LineCount} lines")]
    private static partial void LogOrderPlaced(ILogger logger, string orderId, int lineCount);
}
```

The interpolated string reached the logger as opaque text that analyzer rule CA2254 flags, while the source generated method keeps the template constant and `OrderId` a searchable field. The email address is gone because no operational question needs it.

## Concatenated log with personal data (Python)

Before

```python
import logging

logger = logging.getLogger(__name__)


def record_refund(refund):
    logger.info(
        "Refund " + refund.id + " of " + str(refund.amount_minor)
        + " issued to " + refund.customer_email
    )
```

After

```python
import logging

logger = logging.getLogger(__name__)


def record_refund(refund):
    logger.info(
        "Refund issued",
        extra={
            "refund_id": refund.id,
            "amount_minor": refund.amount_minor,
            "customer_email_domain": refund.customer_email.rpartition("@")[2],
        },
    )
```

The message is constant and each value is a field that the project's JSON formatter writes to stdout with the trace context attached. The email address is generalized to its domain, which still answers questions about mail providers without identifying anyone.

## Token in a log line (TypeScript)

Before

```typescript
export async function fetchInvoices(customerId: string, token: string): Promise<Invoice[]> {
  const url = `${BILLING_URL}/customers/${customerId}/invoices`;
  const headers = { Authorization: `Bearer ${token}` };
  logger.debug(`GET ${url} headers=${JSON.stringify(headers)}`);
  const response = await fetch(url, { headers });
  if (!response.ok) {
    throw new BillingError(response.status);
  }
  return response.json();
}
```

After

```typescript
export async function fetchInvoices(customerId: string, token: string): Promise<Invoice[]> {
  const response = await fetch(`${BILLING_URL}/customers/${customerId}/invoices`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  if (!response.ok) {
    throw new BillingError(response.status);
  }
  return response.json();
}
```

```typescript
import pino from "pino";

export const logger = pino({
  redact: ["req.headers.authorization", "req.headers.cookie"],
});
```

Serializing the header map put a live bearer token into every debug log, and the HTTP client instrumentation already records the call as a span with the stable `http.*` and `url.*` attributes, so the line goes. The redaction paths stay as a safety net for request logging elsewhere, not as the fix.

## Invented span attributes (Python)

Before

```python
from opentelemetry import trace

tracer = trace.get_tracer(__name__)

FIND_ORDERS_SQL = "SELECT id, total_minor FROM orders WHERE customer_id = %s"


def find_orders(cursor, customer_id):
    with tracer.start_as_current_span("db query") as span:
        span.set_attribute("dbType", "postgres")
        span.set_attribute("table", "orders")
        span.set_attribute("customer", customer_id)
        try:
            cursor.execute(FIND_ORDERS_SQL, (customer_id,))
            return cursor.fetchall()
        except Exception as error:
            span.set_attribute("error", str(error))
            raise
```

After

```python
from opentelemetry import trace
from opentelemetry.semconv.attributes.db_attributes import (
    DB_COLLECTION_NAME,
    DB_OPERATION_NAME,
    DB_SYSTEM_NAME,
    DbSystemNameValues,
)
from opentelemetry.semconv.attributes.error_attributes import ERROR_TYPE
from opentelemetry.trace import SpanKind

tracer = trace.get_tracer(__name__)

FIND_ORDERS_SQL = "SELECT id, total_minor FROM orders WHERE customer_id = %s"


def find_orders(cursor, customer_id):
    with tracer.start_as_current_span("SELECT orders", kind=SpanKind.CLIENT) as span:
        span.set_attribute(DB_SYSTEM_NAME, DbSystemNameValues.POSTGRESQL.value)
        span.set_attribute(DB_OPERATION_NAME, "SELECT")
        span.set_attribute(DB_COLLECTION_NAME, "orders")
        try:
            cursor.execute(FIND_ORDERS_SQL, (customer_id,))
            return cursor.fetchall()
        except Exception as error:
            span.set_attribute(ERROR_TYPE, type(error).__qualname__)
            raise
```

No backend understands `dbType` or `table`, the customer ID was personal data, and the error text had unbounded cardinality, so the span now uses stable names from the semantic conventions package and lets the context manager record the exception and set the Error status. When the driver has an instrumentation library, delete this span and let the library emit it.

## User ID in a metric attribute (Go)

Before

```go
func (m *Metrics) RecordCompleted(ctx context.Context, userID string, cartURL string) {
	m.completed.Add(ctx, 1, metric.WithAttributes(
		attribute.String("user_id", userID),
		attribute.String("cart_url", cartURL),
	))
}
```

After

```go
package checkout

import (
	"context"

	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/metric"
)

type PaymentMethod string

const (
	PaymentMethodCard    PaymentMethod = "card"
	PaymentMethodWallet  PaymentMethod = "wallet"
	PaymentMethodInvoice PaymentMethod = "invoice"
)

var meter = otel.Meter("acme.com/shop/checkout")

type Metrics struct {
	completed metric.Int64Counter
}

func NewMetrics() (*Metrics, error) {
	completed, err := meter.Int64Counter(
		"com.acme.checkout.completed",
		metric.WithDescription("Completed checkouts."),
		metric.WithUnit("{checkout}"),
	)
	if err != nil {
		return nil, err
	}
	return &Metrics{completed: completed}, nil
}

func (m *Metrics) RecordCompleted(ctx context.Context, method PaymentMethod) {
	m.completed.Add(ctx, 1, metric.WithAttributes(
		attribute.String("com.acme.checkout.payment_method", string(method)),
	))
}
```

Every user and every cart URL started a new time series, which soon passes the default limit of 2000 combinations and folds later data into an overflow point. Payment method has three values, and a question about one user's checkouts belongs to traces and logs.

## Log forging (Java)

Before

```java
public void onLoginFailed(String username, String remoteAddress) {
    log.warn("Login failed for user " + username + " from " + remoteAddress);
}
```

After

```java
import java.util.regex.Pattern;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public final class LoginAudit {
    private static final Logger log = LoggerFactory.getLogger(LoginAudit.class);
    private static final Pattern LINE_BREAKS = Pattern.compile("[\\r\\n]");

    public void onLoginFailed(String username, String remoteAddress) {
        log.atWarn()
            .setMessage("Login failed")
            .addKeyValue("event", "authn_login_fail")
            .addKeyValue("security", true)
            .addKeyValue("username", neutralize(username))
            .addKeyValue("source_address", remoteAddress)
            .log();
    }

    private static String neutralize(String value) {
        return LINE_BREAKS.matcher(value).replaceAll("_");
    }
}
```

A user name holding a line break and a fake success entry used to forge a second log line. Now the message is constant, the user name is a field with CR and LF replaced so plain text appenders stay safe too, and the event carries the type and security flag the OWASP cheat sheets ask for.

## Logged and rethrown (TypeScript)

Before

```typescript
export async function chargeOrder(order: Order): Promise<Receipt> {
  try {
    return await payments.charge(order.paymentMethodId, order.totalMinor);
  } catch (error) {
    logger.error(`Charge failed for order ${order.id}: ${error}`);
    throw error;
  }
}

app.use((error: Error, request: Request, response: Response, next: NextFunction) => {
  logger.error(`Request failed: ${error.message}`);
  response.status(500).json({ error: error.message });
});
```

After

```typescript
export class ChargeFailedError extends Error {
  constructor(readonly orderId: string, options?: ErrorOptions) {
    super(`Charging order ${orderId} failed`, options);
    this.name = "ChargeFailedError";
  }
}

export async function chargeOrder(order: Order): Promise<Receipt> {
  try {
    return await payments.charge(order.paymentMethodId, order.totalMinor);
  } catch (error) {
    throw new ChargeFailedError(order.id, { cause: error });
  }
}

app.use((error: Error, request: Request, response: Response, _next: NextFunction) => {
  logger.error({ err: error, route: request.route?.path }, "Request failed");
  response.status(500).type("application/problem+json").json({
    type: "about:blank",
    title: "Internal Server Error",
    status: 500,
  });
});
```

One failure produced two error lines that doubled alert counts and split the context. The service now adds context and rethrows, the boundary logs once with pino's `err` serializer writing type, message, and stack as fields, and the client no longer sees internal error text, as the designing-http-apis skill requires.

## Health endpoint that leaks (C#)

Before

```csharp
app.MapGet("/health", async (OrdersDbContext db) =>
{
    try
    {
        await db.Database.ExecuteSqlRawAsync("SELECT 1");
        return Results.Ok(new { status = "Healthy", database = db.Database.GetConnectionString() });
    }
    catch (Exception ex)
    {
        return Results.Json(new { status = "Unhealthy", error = ex.ToString() }, statusCode: 503);
    }
});
```

After

```csharp
builder.Services.AddHealthChecks()
    .AddCheck<DatabaseHealthCheck>("database", tags: new[] { "ready" });

app.MapHealthChecks("/healthz/live", new HealthCheckOptions { Predicate = _ => false });
app.MapHealthChecks("/healthz/ready", new HealthCheckOptions
{
    Predicate = check => check.Tags.Contains("ready")
});
```

```csharp
public sealed partial class DatabaseHealthCheck(OrdersDbContext db, ILogger<DatabaseHealthCheck> logger) : IHealthCheck
{
    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context, CancellationToken cancellationToken = default)
    {
        if (await db.Database.CanConnectAsync(cancellationToken))
        {
            return HealthCheckResult.Healthy();
        }
        LogDatabaseUnreachable(logger);
        return HealthCheckResult.Unhealthy();
    }

    [LoggerMessage(Level = LogLevel.Warning, Message = "Readiness check could not reach the orders database")]
    private static partial void LogDatabaseUnreachable(ILogger logger);
}
```

The old endpoint handed the connection string and a full stack trace to anyone who could reach it. The default response writer now returns only the overall status as plain text, the failure reason goes to the log, and liveness no longer touches the database, as the building-resilient-services skill describes.
