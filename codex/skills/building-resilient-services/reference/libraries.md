# Resilience libraries

The default library per language. The project's library comes first, a new one goes through the managing-dependencies-and-ci skill, and the current docs give the exact API.

## C# and .NET

- **Library.** Polly 8, package `Polly.Core`, with Retry, Circuit Breaker, Timeout, Rate Limiter, Fallback, and Hedging combined in a `ResiliencePipelineBuilder`. Docs at [pollydocs.org](https://www.pollydocs.org/).
- **For `HttpClient`.** `Microsoft.Extensions.Http.Resilience`. `AddStandardResilienceHandler()` chains, outermost first, a rate limiter, a total timeout, a retry with exponential backoff and jitter, a circuit breaker, and a per-attempt timeout, each with documented defaults. Bind its options from configuration with the `IConfigurationSection` overload or `.Configure(...)`, and add only one resilience handler per client. Docs at [Build resilient HTTP apps](https://learn.microsoft.com/en-us/dotnet/core/resilience/http-resilience).
- **Unsafe methods.** `options.Retry.DisableForUnsafeHttpMethods()` stops retries for `POST`, `PATCH`, `PUT`, `DELETE`, and `CONNECT`.
- **Plain Polly.** `RetryStrategyOptions` defaults to constant backoff without jitter, so set `BackoffType = DelayBackoffType.Exponential` and `UseJitter = true`. An open breaker throws `BrokenCircuitException`, and a Polly timeout throws `TimeoutRejectedException`, not `TimeoutException`.

## Java

- **Library.** Resilience4j 2, which requires Java 17, with the modules `resilience4j-circuitbreaker`, `resilience4j-retry`, `resilience4j-bulkhead`, `resilience4j-ratelimiter`, `resilience4j-timelimiter`, and `resilience4j-cache`. Docs at [resilience4j.readme.io](https://resilience4j.readme.io/docs/getting-started).
- **Composition.** `Decorators.ofSupplier(...).withCircuitBreaker(...).withRetry(...).decorate()` needs `resilience4j-all`. The Spring Boot annotations fix the order with Retry outermost around CircuitBreaker, RateLimiter, TimeLimiter, and Bulkhead.
- **Defaults to change.** `RetryConfig` waits a fixed `waitDuration`. Set `intervalFunction(IntervalFunction.ofExponentialRandomBackoff(...))`, and list transient exceptions in `retryExceptions` and permanent ones in `ignoreExceptions`.

## Python

- **Retry.** Tenacity, with `@retry(stop=stop_after_attempt(...), wait=wait_random_exponential(...), retry=retry_if_exception_type(...), reraise=True)`. Without `reraise=True` the last failure surfaces as `RetryError`. Docs at [tenacity.readthedocs.io](https://tenacity.readthedocs.io/).
- **Circuit breaker.** Tenacity has none. Use pybreaker, `CircuitBreaker(fail_max=..., reset_timeout=...)` as a decorator or through `breaker.call(...)`. An open breaker raises `CircuitBreakerError`, `exclude=[...]` keeps business exceptions from counting, and `CircuitRedisStorage` shares state across processes. Its async support targets Tornado, so check the event loop before using it with asyncio. Docs at [github.com/danielfm/pybreaker](https://github.com/danielfm/pybreaker).
- **Timeouts.** Requests never times out unless `timeout` is passed, one value or a `(connect, read)` tuple, and neither is a wall-clock limit on the whole call. Docs at [Requests timeouts](https://requests.readthedocs.io/en/latest/user/advanced/#timeouts).

## TypeScript and JavaScript

- **Library.** Cockatiel 4, which needs Node 22 or later and ships as an ES module, with `retry`, `circuitBreaker`, `timeout`, `bulkhead`, and `fallback` combined by `wrap`, outermost first. Docs at [github.com/connor4312/cockatiel](https://github.com/connor4312/cockatiel).
- **Calls.** `retry(handleWhen(isTransient), { maxAttempts, backoff: new ExponentialBackoff() })`, `circuitBreaker(handleWhen(isTransient), { halfOpenAfter, breaker: new ConsecutiveBreaker(n) })`, and `timeout(ms, TimeoutStrategy.Aggressive)`. `ExponentialBackoff` uses decorrelated jitter by default. `execute` passes `{ signal }`, which must reach `fetch` or the client so a timeout cancels the request.
- **Errors.** An open breaker throws `BrokenCircuitError`, an aggressive timeout `TaskCancelledError`, and a full bulkhead `BulkheadRejectedError`.
- **Plain `fetch`.** Pass `signal: AbortSignal.timeout(ms)`, which aborts with a `TimeoutError` `DOMException`, and combine signals with `AbortSignal.any()`.

## Go

- **Library.** failsafe-go, module `github.com/failsafe-go/failsafe-go`, with Retry, Circuit Breaker, Rate Limiter, Timeout, Fallback, Hedge, Bulkhead, Cache, and adaptive limiter policies. It is before version 1.0, so pin it and read the release notes on upgrade. Docs at [failsafe-go.dev](https://failsafe-go.dev/).
- **Calls.** `retrypolicy.NewBuilder[T]()` with `HandleErrors(...)`, `WithBackoff(delay, maxDelay)`, `WithJitterFactor(...)`, and `WithMaxRetries(...)`, then `failsafe.With(retryPolicy, circuitBreaker, timeout).Get(fn)`, retry first as in the official example.
- **Defaults to change.** A retry policy defaults to 3 attempts with no delay, so always set a backoff. A circuit breaker without thresholds opens after a single failure and waits 1 minute before half-opening, so set `WithFailureThreshold` or `WithFailureThresholdRatio`, `WithDelay`, and `WithSuccessThreshold` from configuration. An open breaker returns `circuitbreaker.ErrOpen`.
- **Standard library.** An `http.Client` with a zero `Timeout` never times out, and `Timeout` covers connecting, redirects, and reading the body. On `http.Server` a zero `ReadTimeout` or `WriteTimeout` means none, and `ReadHeaderTimeout` falls back to `ReadTimeout`. `Server.Shutdown(ctx)` closes listeners, waits for active connections to go idle, and does not wait for hijacked connections such as WebSockets. Docs at [pkg.go.dev/net/http](https://pkg.go.dev/net/http).
