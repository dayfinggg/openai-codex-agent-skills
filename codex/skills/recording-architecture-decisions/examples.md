# Architecture decision examples

Illustrative pairs.

## Contents

- A minimal ADR
- A C4 container diagram

## A minimal ADR

The shop is one TypeScript service with one PostgreSQL database. The user approved a plan that moves email and invoice work out of the checkout request into background jobs.

Before, in `docs/decisions/0007-queue.md`

```markdown
# Queue

We will use Postgres for the queue because it is simpler and scalable.
```

After, in `docs/decisions/0007-use-postgresql-table-for-background-jobs.md`

```markdown
---
status: "accepted"
date: 2026-03-04
---

# Use a PostgreSQL table for background jobs

## Context and Problem Statement

Checkout sends the order confirmation email and renders the invoice PDF inside the HTTP request, so a slow email provider makes checkout slow and a provider outage fails the order. The shop runs as one service with one PostgreSQL database and is operated by a team of three. Where should work that can happen after the response be queued and run?

## Decision Drivers

* Functional suitability, functional correctness. A job exists only when its order has committed.
* Reliability, recoverability. A queued job survives a crash or a deploy and runs afterwards.
* Maintainability. The team runs no infrastructure beyond the service and its database.
* Performance efficiency, capacity. The queue handles the current peak of about 20,000 jobs a day, an estimate from last quarter's order volume.

## Considered Options

* Job table in the existing PostgreSQL database, claimed with `FOR UPDATE SKIP LOCKED`
* Redis with a job queue library
* RabbitMQ

## Decision Outcome

Chosen option: "Job table in the existing PostgreSQL database", because it is the only option that writes the job in the same transaction as the order, and it adds no infrastructure to run.

### Consequences

* Good, because a job exists if and only if its order committed.
* Good, because the existing database backups and monitoring cover the jobs.
* Bad, because polling workers add load to the database that serves checkout.
* Bad, because another service could only consume these jobs by reading this service's tables.

### Confirmation

An integration test rolls back an order and asserts that no job row exists, and code review rejects any job that is enqueued outside the order transaction.
```

The status is `accepted` because the user approved the plan that contained the decision.

## A C4 container diagram

Before

```mermaid
flowchart LR
    User --> Shop
    Shop --> DB
    Shop --> Queue
    Queue --> Billing
```

After

```mermaid
C4Container
    title Container diagram for the online store

    Person(customer, "Customer", "Buys products online")

    System_Boundary(store, "Online store") {
        Container(web, "Shop web application", "TypeScript, Node.js", "Serves the storefront and the order API")
        ContainerDb(shopdb, "Shop database", "PostgreSQL", "Stores products, orders, and the outbox")
        Container(relay, "Outbox relay", "TypeScript, Node.js", "Publishes committed outbox rows")
        ContainerQueue(broker, "Message broker", "RabbitMQ", "Carries background jobs and order events")
        Container(mailer, "Email worker", "TypeScript, Node.js", "Sends order confirmation emails")
        Container(billing, "Billing service", "Go", "Creates an invoice for every placed order")
        ContainerDb(billingdb, "Billing database", "PostgreSQL", "Stores invoices")
    }

    System_Ext(payments, "Payment provider", "Charges cards and issues refunds")
    System_Ext(email, "Email service", "Delivers transactional email")

    Rel(customer, web, "Places orders using", "HTTPS")
    Rel(web, payments, "Charges payments through", "JSON/HTTPS")
    Rel(web, shopdb, "Writes orders and outbox rows to", "SQL")
    Rel(relay, shopdb, "Reads unsent outbox rows from", "SQL")
    Rel(relay, broker, "Publishes jobs and order events to", "AMQP")
    Rel(mailer, broker, "Consumes email jobs from", "AMQP")
    Rel(mailer, email, "Sends order confirmations through", "JSON/HTTPS")
    Rel(billing, broker, "Consumes order events from", "AMQP")
    Rel(billing, billingdb, "Reads from and writes to", "SQL")
```

Key. Each box shows its type and technology in brackets, grey boxes are systems outside the online store, upright cylinders are databases, the horizontal cylinder is a queue, and each arrow points from the element that starts the interaction.
