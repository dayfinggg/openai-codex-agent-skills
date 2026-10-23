# Over-engineering (Python)

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

Add the strategy pattern when a second tax type actually exists.
