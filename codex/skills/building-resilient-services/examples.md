# Resilience examples

These pairs are illustrative. Copy the reasoning, not the exact shape. Every number the code needs comes from configuration, never from a literal invented in the code.

## Contents

- Timeout on an HTTP call (Python)
- Retry loop replaced by a policy (TypeScript)
- Resilient HttpClient (C#)
- Idempotent message handler (Python and SQL)
- Graceful shutdown on SIGTERM (Go)

## Timeout on an HTTP call (Python)

Before

```python
import requests


def rate_for(currency):
    return requests.get(f"https://rates.example.com/rates/{currency}").json()
```

After

```python
import os
from dataclasses import dataclass

import requests


@dataclass(frozen=True)
class RatesSettings:
    base_url: str
    connect_timeout_seconds: float
    read_timeout_seconds: float

    @classmethod
    def from_environment(cls) -> "RatesSettings":
        return cls(
            base_url=os.environ["RATES_API_URL"],
            connect_timeout_seconds=float(os.environ["RATES_API_CONNECT_TIMEOUT_SECONDS"]),
            read_timeout_seconds=float(os.environ["RATES_API_READ_TIMEOUT_SECONDS"]),
        )


class RatesClient:
    def __init__(self, session: requests.Session, settings: RatesSettings):
        self._session = session
        self._settings = settings

    def rate_for(self, currency: str) -> dict:
        response = self._session.get(
            f"{self._settings.base_url}/rates/{currency}",
            timeout=(
                self._settings.connect_timeout_seconds,
                self._settings.read_timeout_seconds,
            ),
        )
        response.raise_for_status()
        return response.json()
```

Requests never times out unless a timeout is passed, so one hung server could block the worker forever. The connect and read timeouts and the URL now come from the environment, and the error status surfaces instead of being parsed as data.

## Retry loop replaced by a policy (TypeScript)

Before

```typescript
export async function fetchInventory(sku: string): Promise<Inventory> {
  while (true) {
    try {
      const response = await fetch(`${process.env.INVENTORY_URL}/items/${sku}`);
      return (await response.json()) as Inventory;
    } catch {
      await new Promise((resolve) => setTimeout(resolve, 1000));
    }
  }
}
```

After

```typescript
import {
  ConsecutiveBreaker,
  ExponentialBackoff,
  TaskCancelledError,
  TimeoutStrategy,
  circuitBreaker,
  handleWhen,
  retry,
  timeout,
  wrap,
} from "cockatiel";

export interface Inventory {
  sku: string;
  available: number;
}

export interface InventoryConfig {
  baseUrl: string;
  attemptTimeoutMs: number;
  retryMaxAttempts: number;
  breakerConsecutiveFailures: number;
  breakerHalfOpenAfterMs: number;
}

const TRANSIENT_STATUSES = new Set([408, 429, 502, 503, 504]);

class TransientHttpError extends Error {
  readonly status: number;

  constructor(status: number) {
    super(`Inventory service answered ${status}`);
    this.status = status;
  }
}

const isTransient = (error: unknown) =>
  error instanceof TransientHttpError ||
  error instanceof TaskCancelledError ||
  error instanceof TypeError;

export function createInventoryClient(config: InventoryConfig) {
  const policy = wrap(
    retry(handleWhen(isTransient), {
      maxAttempts: config.retryMaxAttempts,
      backoff: new ExponentialBackoff(),
    }),
    circuitBreaker(handleWhen(isTransient), {
      halfOpenAfter: config.breakerHalfOpenAfterMs,
      breaker: new ConsecutiveBreaker(config.breakerConsecutiveFailures),
    }),
    timeout(config.attemptTimeoutMs, TimeoutStrategy.Aggressive),
  );

  async function fetchInventory(sku: string): Promise<Inventory> {
    return policy.execute(async ({ signal }) => {
      const response = await fetch(
        `${config.baseUrl}/items/${encodeURIComponent(sku)}`,
        { signal },
      );
      if (TRANSIENT_STATUSES.has(response.status)) {
        throw new TransientHttpError(response.status);
      }
      if (!response.ok) {
        throw new Error(`Inventory service rejected ${sku} with ${response.status}`);
      }
      return (await response.json()) as Inventory;
    });
  }

  return { fetchInventory };
}
```

The loop retried every error forever at a fixed interval with no timeout, and treated an error page as inventory. Now each attempt is cancelled through the signal, only transient failures are retried with exponential backoff and jitter, the retry stops as soon as the breaker opens because `BrokenCircuitError` is not transient, and the read is a GET, so repeating it is safe.

## Resilient HttpClient (C#)

Before

```csharp
public sealed class PaymentsClient
{
    public async Task<PaymentStatus?> GetStatusAsync(string paymentId)
    {
        using var client = new HttpClient { BaseAddress = new Uri("https://payments.example.com/") };
        return await client.GetFromJsonAsync<PaymentStatus>($"payments/{paymentId}");
    }
}
```

After

```csharp
using System.Net.Http.Json;

public sealed record PaymentStatus(string Id, string State);

public sealed class PaymentsClient(HttpClient client)
{
    public async Task<PaymentStatus> GetStatusAsync(string paymentId, CancellationToken cancellationToken) =>
        await client.GetFromJsonAsync<PaymentStatus>(
            $"payments/{Uri.EscapeDataString(paymentId)}", cancellationToken)
        ?? throw new InvalidOperationException($"Payment {paymentId} returned an empty body");
}
```

```csharp
using Microsoft.Extensions.Http.Resilience;

var builder = WebApplication.CreateBuilder(args);

builder.Services
    .AddHttpClient<PaymentsClient>(client =>
        client.BaseAddress = new Uri(builder.Configuration["Payments:BaseUrl"]
            ?? throw new InvalidOperationException("Payments:BaseUrl is not configured")))
    .AddStandardResilienceHandler(builder.Configuration.GetSection("Payments:Resilience"))
    .Configure(options => options.Retry.DisableForUnsafeHttpMethods());

var app = builder.Build();
app.Run();
```

The standard handler adds a total timeout, retries with exponential backoff and jitter, a circuit breaker, and a per-attempt timeout, with documented defaults until the `Payments:Resilience` section overrides them. Disabling retries for unsafe methods keeps a future POST on this client from being sent twice, and the caller's cancellation token now reaches the request.

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

A broker that redelivers the message, for example after a crash between commit and acknowledgement, used to credit the account twice. The producer's message identifier is now claimed in the same transaction as the credit, the primary key makes a concurrent duplicate lose, and a redelivered message is acknowledged without a second credit.

## Graceful shutdown on SIGTERM (Go)

Before

```go
func main() {
	http.HandleFunc("/orders", handleOrders)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
```

After

```go
package main

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

type config struct {
	addr              string
	readHeaderTimeout time.Duration
	shutdownTimeout   time.Duration
}

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	if err := run(logger); err != nil {
		logger.Error("server stopped", "error", err)
		os.Exit(1)
	}
}

func run(logger *slog.Logger) error {
	cfg, err := loadConfig()
	if err != nil {
		return err
	}

	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGTERM, os.Interrupt)
	defer stop()

	srv := &http.Server{
		Addr:              cfg.addr,
		Handler:           routes(),
		ReadHeaderTimeout: cfg.readHeaderTimeout,
	}

	serveErr := make(chan error, 1)
	go func() {
		serveErr <- srv.ListenAndServe()
	}()

	select {
	case err := <-serveErr:
		return fmt.Errorf("serve http: %w", err)
	case <-ctx.Done():
	}

	logger.Info("shutting down", "timeout", cfg.shutdownTimeout)
	shutdownCtx, cancel := context.WithTimeout(context.Background(), cfg.shutdownTimeout)
	defer cancel()
	if err := srv.Shutdown(shutdownCtx); err != nil {
		return fmt.Errorf("shut down http server: %w", err)
	}
	if err := <-serveErr; !errors.Is(err, http.ErrServerClosed) {
		return fmt.Errorf("serve http: %w", err)
	}
	return nil
}

func routes() http.Handler {
	mux := http.NewServeMux()
	mux.HandleFunc("/orders", handleOrders)
	return mux
}

func loadConfig() (config, error) {
	addr, ok := os.LookupEnv("LISTEN_ADDR")
	if !ok {
		return config{}, errors.New("environment variable LISTEN_ADDR is required")
	}
	readHeaderTimeout, err := durationFromEnv("READ_HEADER_TIMEOUT")
	if err != nil {
		return config{}, err
	}
	shutdownTimeout, err := durationFromEnv("SHUTDOWN_TIMEOUT")
	if err != nil {
		return config{}, err
	}
	return config{addr: addr, readHeaderTimeout: readHeaderTimeout, shutdownTimeout: shutdownTimeout}, nil
}

func durationFromEnv(name string) (time.Duration, error) {
	value, ok := os.LookupEnv(name)
	if !ok {
		return 0, fmt.Errorf("environment variable %s is required", name)
	}
	duration, err := time.ParseDuration(value)
	if err != nil {
		return 0, fmt.Errorf("parse %s=%q: %w", name, value, err)
	}
	return duration, nil
}
```

The old process died in the middle of requests when the platform sent SIGTERM, and its server had no header timeout. Now SIGTERM closes the listener, in-flight requests finish within the configured grace period, configuration comes from the environment and stops startup when missing, and the process logs to stdout. `handleOrders` stands for the existing handler.
