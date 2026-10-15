# Test examples (Python, pytest)

These examples are illustrative.

## Contents

- Unclear test versus clean tests
- Table of cases
- Hand-written spy at a boundary
- Bug fix starting from a failing test

## Unclear test versus clean tests

Before

```python
def test_cart():
    c = Cart()
    c.add(Item("pen", 10), 2)
    assert c.total() == 20
    c.add(Item("book", 50), 1)
    assert c.total() == 70
    c.remove("pen")
    assert c.total() == 50
    assert len(c.items) == 1
```

After

```python
def test_total_multiplies_price_by_quantity():
    cart = Cart()

    cart.add(Item("pen", price=10), quantity=2)

    assert cart.total() == 20


def test_removing_item_excludes_it_from_total():
    cart = Cart()
    cart.add(Item("pen", price=10), quantity=2)
    cart.add(Item("book", price=50), quantity=1)

    cart.remove("pen")

    assert cart.total() == 50
```

Each test checks one behavior through the public interface and its name says what it proves.

## Table of cases

```python
import pytest


@pytest.mark.parametrize(
    "text, expected_seconds",
    [
        ("45s", 45),
        ("2m", 120),
        ("1h30m", 5400),
        ("0s", 0),
    ],
)
def test_parses_duration(text, expected_seconds):
    assert parse_duration(text) == expected_seconds


@pytest.mark.parametrize("text", ["", "10", "5x", "-1m"])
def test_rejects_malformed_duration(text):
    with pytest.raises(ValueError, match="duration"):
        parse_duration(text)
```

## Hand-written spy at a boundary

```python
class EmailSenderSpy:
    def __init__(self):
        self.sent = []

    def send(self, to, subject):
        self.sent.append((to, subject))


def test_sends_welcome_email_after_registration():
    emails = EmailSenderSpy()
    service = RegistrationService(emails)

    service.register("ann@example.com")

    assert emails.sent == [("ann@example.com", "Welcome")]
```

The spy replaces only the external email service. The registration logic runs for real.

## Bug fix starting from a failing test

Reported bug. A discount above 100 percent makes the total negative.

1. Reproduce it.

```python
def test_discount_above_100_percent_never_makes_total_negative():
    assert apply_discount(total=80, percent=120) == 0
```

2. Run it and see it fail with the negative value.
3. Fix `apply_discount`, run the whole suite, and keep the test as a regression guard.
