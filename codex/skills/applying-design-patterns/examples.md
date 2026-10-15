# Design pattern examples

These pairs are illustrative. Copy the reasoning, not the exact shape.

## Contents

- Repeated type switch to a map of functions (Python)
- Repeated type switch to polymorphism (Java)
- Premature factory and interface to a function (TypeScript)
- Singleton to an injected dependency (Go)
- Repeated null checks to a Null Object (C#)
- Command executed in place to a function (Python)

## Repeated type switch to a map of functions (Python)

Before

```python
def export(report, fmt):
    if fmt == "csv":
        return to_csv(report)
    if fmt == "json":
        return to_json(report)
    raise ValueError(f"Unknown export format {fmt!r}")


def content_type(fmt):
    if fmt == "csv":
        return "text/csv"
    if fmt == "json":
        return "application/json"
    raise ValueError(f"Unknown export format {fmt!r}")
```

After

```python
from dataclasses import dataclass
from typing import Callable


@dataclass(frozen=True)
class ExportFormat:
    content_type: str
    serialize: Callable[[Report], str]


EXPORT_FORMATS = {
    "csv": ExportFormat("text/csv", to_csv),
    "json": ExportFormat("application/json", to_json),
}


def export_format(name: str) -> ExportFormat:
    try:
        return EXPORT_FORMATS[name]
    except KeyError:
        raise ValueError(f"Unknown export format {name!r}") from None
```

The same switch lived in two functions, so every new format meant two edits. Each variant is one function and one value, so a map of small records is the simplest form of Strategy here, and no class hierarchy is needed.

## Repeated type switch to polymorphism (Java)

Before

```java
public final class Notifier {
    public void send(Channel channel, String address, String message) {
        switch (channel) {
            case EMAIL -> mailer.send(address, message);
            case SMS -> smsGateway.send(address, message);
            case PUSH -> pushService.notify(address, message);
        }
    }

    public boolean isValidAddress(Channel channel, String address) {
        return switch (channel) {
            case EMAIL -> address.contains("@");
            case SMS -> address.matches("\\+[0-9]{8,15}");
            case PUSH -> !address.isBlank();
        };
    }
}
```

After

```java
public sealed interface Channel permits EmailChannel, SmsChannel, PushChannel {
    void send(String address, String message);

    boolean isValidAddress(String address);
}

public record EmailChannel(Mailer mailer) implements Channel {
    public void send(String address, String message) {
        mailer.send(address, message);
    }

    public boolean isValidAddress(String address) {
        return address.contains("@");
    }
}

public record SmsChannel(SmsGateway gateway) implements Channel {
    public void send(String address, String message) {
        gateway.send(address, message);
    }

    public boolean isValidAddress(String address) {
        return address.matches("\\+[0-9]{8,15}");
    }
}

public record PushChannel(PushService pushService) implements Channel {
    public void send(String address, String message) {
        pushService.notify(address, message);
    }

    public boolean isValidAddress(String address) {
        return !address.isBlank();
    }
}
```

Each channel carries its own collaborator and several operations, so one type per channel fits better than a map of functions. This is Replace Conditional with Polymorphism, and a new channel is now one new type the compiler checks instead of edits in every switch.

## Premature factory and interface to a function (TypeScript)

Before

```typescript
interface SlugGenerator {
  generate(title: string): string;
}

class DefaultSlugGenerator implements SlugGenerator {
  generate(title: string): string {
    return title
      .trim()
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-|-$/g, "");
  }
}

class SlugGeneratorFactory {
  static create(): SlugGenerator {
    return new DefaultSlugGenerator();
  }
}

const slug = SlugGeneratorFactory.create().generate(post.title);
```

After

```typescript
export function slugify(title: string): string {
  return title
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}

const slug = slugify(post.title);
```

There was one implementation, no second variant in sight, and no I/O to replace in tests, and the factory only called a constructor. Inline Function on the factory and Inline Class on the generator leave a pure function that callers and tests use directly.

## Singleton to an injected dependency (Go)

Before

```go
var (
	dbOnce sync.Once
	dbConn *sql.DB
)

func DB() *sql.DB {
	dbOnce.Do(func() {
		conn, err := sql.Open("postgres", os.Getenv("DATABASE_URL"))
		if err != nil {
			log.Fatal(err)
		}
		dbConn = conn
	})
	return dbConn
}

func FindUserEmail(ctx context.Context, id string) (string, error) {
	var email string
	err := DB().QueryRowContext(ctx, "SELECT email FROM users WHERE id = $1", id).Scan(&email)
	return email, err
}
```

After

```go
type UserStore struct {
	db *sql.DB
}

func NewUserStore(db *sql.DB) *UserStore {
	return &UserStore{db: db}
}

func (s *UserStore) FindEmail(ctx context.Context, id string) (string, error) {
	var email string
	err := s.db.QueryRowContext(ctx, "SELECT email FROM users WHERE id = $1", id).Scan(&email)
	if err != nil {
		return "", fmt.Errorf("find email of user %s: %w", id, err)
	}
	return email, nil
}

func main() {
	db, err := sql.Open("postgres", os.Getenv("DATABASE_URL"))
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	users := NewUserStore(db)
	log.Fatal(http.ListenAndServe(":8080", newRouter(users)))
}
```

The global accessor hid the dependency, read the environment from deep inside the code, and made every test share one connection. Replace Query with Parameter moves the connection into the constructor, and `main` opens it once, owns its lifetime, and passes it in.

## Repeated null checks to a Null Object (C#)

Before

```csharp
public sealed class Checkout(IDiscountRepository discounts)
{
    public decimal Total(Order order)
    {
        var discount = discounts.FindFor(order.CustomerId);
        return discount is null ? order.Subtotal : discount.ApplyTo(order.Subtotal);
    }

    public string Summary(Order order)
    {
        var discount = discounts.FindFor(order.CustomerId);
        var label = discount is null ? "No discount" : discount.Label;
        return $"{label}, total {Total(order):C}";
    }
}
```

After

```csharp
public interface IDiscount
{
    string Label { get; }

    decimal ApplyTo(decimal amount);
}

public sealed class NoDiscount : IDiscount
{
    public string Label => "No discount";

    public decimal ApplyTo(decimal amount) => amount;
}

public sealed class Checkout(IDiscountRepository discounts)
{
    public decimal Total(Order order) => DiscountFor(order).ApplyTo(order.Subtotal);

    public string Summary(Order order) => $"{DiscountFor(order).Label}, total {Total(order):C}";

    private IDiscount DiscountFor(Order order) =>
        discounts.FindFor(order.CustomerId) ?? new NoDiscount();
}
```

Every caller reacted to a missing discount in the same way, so Introduce Special Case removes the checks. The repository still returns null, so code that must treat a missing discount differently can still tell.

## Command executed in place to a function (Python)

Before

```python
class SendWelcomeEmailCommand:
    def __init__(self, mailer, user):
        self.mailer = mailer
        self.user = user

    def execute(self):
        self.mailer.send(self.user.email, "Welcome", render_welcome(self.user))


def register(user, users, mailer):
    users.add(user)
    SendWelcomeEmailCommand(mailer, user).execute()
```

After

```python
def send_welcome_email(mailer, user):
    mailer.send(user.email, "Welcome", render_welcome(user))


def register(user, users, mailer):
    users.add(user)
    send_welcome_email(mailer, user)
```

The command was created and executed on the same line and never queued, logged, or undone, so it was not pulling its weight. Replace Command with Function brings back a plain call, and a command record is worth adding only when the email moves to a queue.
