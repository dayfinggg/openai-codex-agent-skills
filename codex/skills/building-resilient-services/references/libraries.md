# Resilience libraries

The default library for each language, confirmed against its official documentation and repository. Use the library the project already has first. Before adding one, check it with the managing-dependencies-and-ci skill, and read its current documentation for the exact API, because the calls below are a starting point, not a substitute. Take numeric values from the project's configuration or from the documented defaults quoted here, and change the strategy where the default is a constant delay.

## Contents

- C# and .NET
- Java
- Python
- TypeScript and JavaScript
- Go

## C# and .NET

- **Library.** Polly 8, package `Polly.Core`, with Retry, Circuit Breaker, Timeout, Rate Limiter, Fallback, and Hedging strategies combined in a `ResiliencePipelineBuilder`. Docs at [pollydocs.org](https://www.pollydocs.org/).
- **For `HttpClient`.** Use `Microsoft.Extensions.Http.Resilience` on top of Polly. `AddStandardResilienceHandler()` on the `IHttpClientBuilder` chains, from outermost to innermost, a rate limiter, a total request timeout, a retry with exponential backoff and jitter, a circuit breaker, and a per-attempt timeout, each with documented defaults. Bind its options from configuration with the `IConfigurationSection` overload or `.Configure(...)`, and add only one resilience handler per client. Docs at [Build resilient HTTP apps](https://learn.microsoft.com/en-us/dotnet/core/resilience/http-resilience).
- **Unsafe methods.** The standard handler retries every HTTP method by default. Call `options.Retry.DisableForUnsafeHttpMethods()` to stop retries for `POST`, `PATCH`, `PUT`, `DELETE`, and `CONNECT` unless those calls carry an idempotency key.
- **Plain Polly defaults.** `RetryStrategyOptions` defaults to a constant backoff without jitter, so set `BackoffType = DelayBackoffType.Exponential` and `UseJitter = true`. An open breaker throws `BrokenCircuitException`, and a Polly timeout throws `TimeoutRejectedException`, not `TimeoutException`.

## Java

- **Library.** Resilience4j 2, which requires Java 17, with the modules `resilience4j-circuitbreaker`, `resilience4j-retry`, `resilience4j-bulkhead`, `resilience4j-ratelimiter`, `resilience4j-timelimiter`, and `resilience4j-cache`. Docs at [resilience4j.readme.io](https://resilience4j.readme.io/docs/getting-started).
- **Composition.** The getting-started example chains `Decorators.ofSupplier(...).withCircuitBreaker(...).withRetry(...).decorate()`, which needs `resilience4j-all`. With the Spring Boot annotations the order is fixed, with Retry outermost around CircuitBreaker, RateLimiter, TimeLimiter, and Bulkhead.
- **Defaults to change.** `RetryConfig` waits a fixed `waitDuration` by default. Set `intervalFunction(IntervalFunction.ofExponentialRandomBackoff(...))` for exponential backoff with jitter, and list transient exceptions in `retryExceptions` and permanent ones in `ignoreExceptions`.

## Python

- **Retry.** Tenacity, with `@retry(stop=stop_after_attempt(...), wait=wait_random_exponential(...), retry=retry_if_exception_type(...), reraise=True)`. `wait_random_exponential` is the documented exponential wait with jitter. Without `reraise=True` the last failure surfaces as `RetryError`. Docs at [tenacity.readthedocs.io](https://tenacity.readthedocs.io/).
- **Circuit breaker.** Tenacity has none. Use pybreaker, which needs Python 3.10 or later, with `CircuitBreaker(fail_max=..., reset_timeout=...)` as a decorator or through `breaker.call(...)`. An open breaker raises `CircuitBreakerError`, `exclude=[...]` keeps business exceptions from counting as failures, and `CircuitRedisStorage` shares state across processes. Its async support targets Tornado, so check the project's event loop before using it with asyncio. Docs at [github.com/danielfm/pybreaker](https://github.com/danielfm/pybreaker).
- **Timeouts.** Requests never times out unless a `timeout` is passed, either one value or a `(connect, read)` tuple. Neither value is a wall-clock limit on the whole call. Docs at [Requests timeouts](https://requests.readthedocs.io/en/latest/user/advanced/#timeouts).

## TypeScript and JavaScript

- **Library.** Cockatiel 4, which needs Node 22 or later and ships as an ES module, with `retry`, `circuitBreaker`, `timeout`, `bulkhead`, and `fallback` policies combined by `wrap`, outermost first. Docs at [github.com/connor4312/cockatiel](https://github.com/connor4312/cockatiel).
- **Calls.** `retry(handleWhen(isTransient), { maxAttempts, backoff: new ExponentialBackoff() })`, `circuitBreaker(handleWhen(isTransient), { halfOpenAfter, breaker: new ConsecutiveBreaker(n) })`, and `timeout(ms, TimeoutStrategy.Aggressive)`. `ExponentialBackoff` uses decorrelated jitter by default. `execute` passes `{ signal }`, which must reach `fetch` or the client so a timeout cancels the request.
- **Errors.** An open breaker throws `BrokenCircuitError`, an aggressive timeout throws `TaskCancelledError`, and a full bulkhead throws `BulkheadRejectedError`.
- **Plain `fetch`.** Pass `signal: AbortSignal.timeout(ms)`, which aborts with a `TimeoutError` `DOMException`. Combine it with another signal through `AbortSignal.any()`. Docs at [MDN AbortSignal.timeout](https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal/timeout_static).

## Go

- **Library.** failsafe-go, module `github.com/failsafe-go/failsafe-go`, with Retry, Circuit Breaker, Rate Limiter, Timeout, Fallback, Hedge, Bulkhead, Cache, and adaptive limiter policies. It is still before version 1.0, so pin it and read the release notes on upgrade. Docs at [failsafe-go.dev](https://failsafe-go.dev/).
- **Calls.** `retrypolicy.NewBuilder[T]()` with `HandleErrors(...)`, `WithBackoff(delay, maxDelay)`, `WithJitterFactor(...)`, and `WithMaxRetries(...)`, then `failsafe.With(retryPolicy, circuitBreaker, timeout).Get(fn)`, as in the official example that lists the retry before the breaker and the timeout.
- **Defaults to change.** A retry policy defaults to 3 attempts with no delay, so always set a backoff. A circuit breaker built without thresholds opens after a single failure and waits 1 minute before half-opening, so set `WithFailureThreshold` or `WithFailureThresholdRatio`, `WithDelay`, and `WithSuccessThreshold` from configuration. An open breaker returns `circuitbreaker.ErrOpen`, and it should not count rejections from other policies, such as a full bulkhead, as failures.
- **Standard library.** An `http.Client` with a zero `Timeout` never times out, and the `Timeout` covers connecting, redirects, and reading the body. On `http.Server`, a zero `ReadTimeout` or `WriteTimeout` means no timeout, and `ReadHeaderTimeout` falls back to `ReadTimeout`. `Server.Shutdown(ctx)` closes listeners, waits for active connections to go idle, and does not wait for hijacked connections such as WebSockets. Docs at [pkg.go.dev/net/http](https://pkg.go.dev/net/http).
