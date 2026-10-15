# Before and after examples

These pairs are illustrative. Copy the reasoning, not the exact shape.

## Contents

- Names and magic values (Python)
- Nesting and guard clauses (TypeScript)
- Error handling (Go)
- Flag argument (Java)
- Over-engineering (Python)

## Names and magic values (Python)

Before

```python
def chk(u, t):
    if t - u.last > 2592000:
        return True
    return False
```

After

```python
SECONDS_PER_DAY = 86_400
INACTIVITY_LIMIT_SECONDS = 30 * SECONDS_PER_DAY


def is_inactive(user, now):
    return now - user.last_login_at > INACTIVITY_LIMIT_SECONDS
```

The name states the question being answered, the constant explains the number, and the boolean is returned directly.

## Nesting and guard clauses (TypeScript)

Before

```typescript
function shippingCost(order: Order): number {
  if (order) {
    if (order.items.length > 0) {
      if (order.country === "US") {
        return order.total > 100 ? 0 : 10;
      } else {
        return 25;
      }
    } else {
      throw new Error("empty");
    }
  } else {
    throw new Error("no order");
  }
}
```

After

```typescript
const FREE_SHIPPING_THRESHOLD = 100;
const DOMESTIC_RATE = 10;
const INTERNATIONAL_RATE = 25;

function shippingCost(order: Order): number {
  if (order.items.length === 0) {
    throw new Error(`Order ${order.id} has no items`);
  }
  if (order.country !== "US") {
    return INTERNATIONAL_RATE;
  }
  return order.total > FREE_SHIPPING_THRESHOLD ? 0 : DOMESTIC_RATE;
}
```

The type already rules out a missing order, so that check goes away, and each remaining rule is one flat line.

## Error handling (Go)

Before

```go
func LoadConfig(path string) *Config {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil
	}
	var cfg Config
	json.Unmarshal(data, &cfg)
	return &cfg
}
```

After

```go
func LoadConfig(path string) (*Config, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("read config %s: %w", path, err)
	}
	var cfg Config
	if err := json.Unmarshal(data, &cfg); err != nil {
		return nil, fmt.Errorf("parse config %s: %w", path, err)
	}
	return &cfg, nil
}
```

Errors are no longer lost, and each one names the operation and the file.

## Flag argument (Java)

Before

```java
public String render(Report report, boolean forPrint) {
    if (forPrint) {
        return renderWithoutNavigation(report);
    }
    return renderWithNavigation(report);
}

render(report, true);
```

After

```java
public String renderForScreen(Report report) {
    return renderWithNavigation(report);
}

public String renderForPrint(Report report) {
    return renderWithoutNavigation(report);
}

renderForPrint(report);
```

The call site now says what it does without looking up the parameter.

## Over-engineering (Python)

The task was "add a function that returns the VAT for a price at 20 percent".

Too much

```python
from abc import ABC, abstractmethod


class TaxStrategy(ABC):
    @abstractmethod
    def compute(self, amount): ...


class VatStrategy(TaxStrategy):
    def __init__(self, rate):
        self.rate = rate

    def compute(self, amount):
        return amount * self.rate


class TaxCalculatorFactory:
    @staticmethod
    def create(kind="vat", rate=0.2):
        if kind == "vat":
            return VatStrategy(rate)
        raise ValueError(kind)
```

Enough

```python
from decimal import Decimal

VAT_RATE = Decimal("0.20")


def vat_for(price: Decimal) -> Decimal:
    return price * VAT_RATE
```

Clean code is the simplest design that solves today's task clearly. Add the strategy pattern when a second tax type actually exists.
