# Observability examples

Illustrative pairs. Copy the reasoning, not the exact shape.

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

No backend understands `dbType` or `table`, the customer ID was personal data, and the error text had unbounded cardinality. The context manager records the exception and sets the Error status. When the driver has an instrumentation library, delete this span and let the library emit it.

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

A user name holding a line break and a fake success entry used to forge a second log line. The message is now constant, CR and LF are replaced so plain text appenders stay safe too, and the event carries the OWASP vocabulary type and a security flag.
