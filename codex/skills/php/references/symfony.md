<overview>
This file covers everyday Symfony work on 7.4 LTS and 8.x. It holds version facts, services, controllers, voters, forms, validation, DTOs, Messenger, console commands, and quality checks. Read [symfony-doctrine.md](symfony-doctrine.md) when the task touches Doctrine entities, relations, queries, or transactions.
</overview>
<contents>
This file has these sections, in order.
- version facts
- services
- controllers
- voters
- forms and validation
- dtos and value objects
- messenger
- console commands
- quality checks
</contents>


<version_facts>
Symfony 8.1 is the current stable release in November 2026, and 8.2 is due in November 2026. Symfony 7.4 is the LTS, with bug fixes until November 2028 and security fixes until November 2029. Symfony 8.x requires PHP 8.4 or later, and 7.4 requires PHP 8.2. Check `composer.lock` for the installed `symfony/*` version before you use a feature from the list below.

These changes are the ones models most often miss.
- Symfony 8.0 removed the XML configuration format and the fluent PHP format for bundle configuration. Write config in YAML, in PHP arrays, or in attributes.
- Symfony 8.0 removed the class aliases in the `Annotation` namespaces. Import attributes such as `Symfony\Component\Routing\Attribute\Route` and `Symfony\Component\Serializer\Attribute\Groups`.
- Symfony 8.0 removed `#[TaggedIterator]` and `#[TaggedLocator]`. Use `#[AutowireIterator]` and `#[AutowireLocator]`.
- Symfony 8.0 removed automatic entity mapping of controller arguments by any route wildcard. The `{id}` wildcard still finds by primary key, and other fields need `{slug:post}` or `#[MapEntity]`.
- Symfony 8.1 deprecates named autowiring aliases that you select by argument name alone. Select them with `#[Target]`.
- Constraint options passed as an array, as in `new Assert\Length(['max' => 255])`, are deprecated since 7.3. Pass named arguments, as in `new Assert\Length(max: 255)`.
- Console commands can be invokable classes with `#[AsCommand]`, `#[Argument]`, and `#[Option]` since 7.3. Symfony 7.4 adds `#[MapInput]` for DTO input.
- `FormFlow` for multistep forms exists since 7.4.
</version_facts>

<services>
<autowiring_and_interfaces>
Symfony injects constructor dependencies by type with the default `services.yaml`, so most services need no config. Depend on an interface when you need to swap the implementation or replace it in tests. With one implementation of an interface in `src/`, autowiring binds the interface to it automatically. Make services `final` with `private readonly` constructor dependencies, and decorate them instead of extending them.

With several implementations, mark the default with `#[AsAlias]` and pick another one per consumer with `#[Target]`. This code makes the Stripe gateway the default and injects the PayPal gateway into one service by its alias name.

```php
use Symfony\Component\DependencyInjection\Attribute\AsAlias;

#[AsAlias(PaymentGatewayInterface::class)]
final class StripePaymentGateway implements PaymentGatewayInterface
{
}
```

```yaml
services:
    App\Payment\PaymentGatewayInterface $paypalGateway: '@App\Payment\PaypalPaymentGateway'
```

```php
use Symfony\Component\DependencyInjection\Attribute\Target;

final class RefundService
{
    public function __construct(
        #[Target('paypalGateway')]
        private readonly PaymentGatewayInterface $gateway,
    ) {
    }
}
```

Run `php bin/console debug:autowiring PaymentGateway` to list the aliases that autowiring can inject for a type.
</autowiring_and_interfaces>

<autowire_attribute>
The `#[Autowire]` attribute injects scalars, parameters, env vars, specific service ids, and expressions. Env vars arrive as strings unless an env processor such as `bool:` or `int:` casts them.

```php
use Symfony\Component\DependencyInjection\Attribute\Autowire;

public function __construct(
    #[Autowire(service: 'monolog.logger.request')] private readonly LoggerInterface $logger,
    #[Autowire('%kernel.project_dir%/data')] private readonly string $dataDir,
    #[Autowire(param: 'kernel.debug')] private readonly bool $debug,
    #[Autowire(env: 'bool:ALLOW_ATTACHMENTS')] private readonly bool $allowAttachments,
) {
}
```

Since Symfony 8.1, `#[Autowire(env: 'DB_URL')]` on a `\Closure` argument injects a closure that reads the current value. Long-running workers use it so an env var is not frozen at boot. A `#[AutowireServiceClosure('mailer.default')]` argument injects a closure that builds the service on first call. Mark a class `#[Lazy]` only when its construction is expensive and some code paths skip it.
</autowire_attribute>

<decoration>
A decorator adds behavior such as logging, caching, or retries around a service without editing it. Symfony 7.4 allows several `#[AsDecorator]` attributes on one class.

```php
use Symfony\Component\DependencyInjection\Attribute\AsDecorator;
use Symfony\Component\DependencyInjection\Attribute\AutowireDecorated;

#[AsDecorator(decorates: StripePaymentGateway::class)]
final class LoggingPaymentGateway implements PaymentGatewayInterface
{
    public function __construct(
        #[AutowireDecorated] private readonly PaymentGatewayInterface $inner,
        private readonly LoggerInterface $logger,
    ) {
    }

    public function charge(int $amount, string $currency): PaymentResult
    {
        $this->logger->info('Charging payment', ['amount' => $amount, 'currency' => $currency]);

        return $this->inner->charge($amount, $currency);
    }
}
```
</decoration>

<tagged_services>
Tagged services replace a hand-written registry or a `switch` over implementations. `#[AutoconfigureTag]` on the interface tags every implementation. `#[AutowireIterator]` injects all of them, and `#[AutowireLocator]` injects a lazy map keyed by index.

```php
use Symfony\Component\DependencyInjection\Attribute\AutoconfigureTag;

#[AutoconfigureTag('app.exporter')]
interface ExporterInterface
{
    public function export(array $rows): string;
}
```

```php
use Symfony\Component\DependencyInjection\Attribute\AsTaggedItem;

#[AsTaggedItem('json')]
final class JsonExporter implements ExporterInterface
{
    public function export(array $rows): string
    {
        return json_encode($rows, JSON_THROW_ON_ERROR);
    }
}
```

```php
use Psr\Container\ContainerInterface;
use Symfony\Component\DependencyInjection\Attribute\AutowireIterator;
use Symfony\Component\DependencyInjection\Attribute\AutowireLocator;

final class ExportService
{
    /** @param iterable<ExporterInterface> $exporters */
    public function __construct(
        #[AutowireIterator('app.exporter')] private readonly iterable $exporters,
        #[AutowireLocator('app.exporter')] private readonly ContainerInterface $exportersByFormat,
    ) {
    }

    public function export(array $rows, string $format): string
    {
        return $this->exportersByFormat->get($format)->export($rows);
    }
}
```

`#[AsTaggedItem(priority: 10)]` orders the services in the iterator, and a higher priority comes first.
</tagged_services>
</services>

<controllers>
<entity_arguments>
A controller argument typed with an entity is fetched by primary key when the route has an `{id}` wildcard. For any other field, map the wildcard to the argument explicitly. Do not rely on `doctrine.orm.controller_resolver.auto_mapping`, because the Symfony docs no longer recommend it.

```php
#[Route('/product/{slug:product}')]
public function show(Product $product): Response
{
}

#[Route('/product/{product_id}')]
public function edit(#[MapEntity(id: 'product_id')] Product $product): Response
{
}
```
</entity_arguments>

<request_payload>
`#[MapRequestPayload]` deserializes the request body into a DTO and validates it. `#[MapQueryString]` does the same for the query string. A failed payload validation returns 422, and a failed query string validation returns 404 by default.

```php
#[Route('/api/orders', methods: ['POST'], format: 'json')]
public function create(#[MapRequestPayload] CreateOrderInput $input): JsonResponse
{
}

#[Route('/api/orders', methods: ['GET'], format: 'json')]
public function list(#[MapQueryString] OrderFilter $filter = new OrderFilter()): JsonResponse
{
}
```

Set `format: 'json'` on the route so validation errors come back as JSON instead of HTML. Without `acceptFormat`, `#[MapRequestPayload]` accepts form data, JSON, and XML, and other formats get a 415. For a list body, use `#[MapRequestPayload(type: OrderLine::class)] array $lines`. `#[MapUploadedFile]` injects an `UploadedFile` and validates it with the constraints you pass.
</request_payload>
</controllers>

<voters>
A voter holds one authorization decision for one kind of subject, so controllers and templates do not repeat permission logic. Extend `Voter` and implement `supports()` and `voteOnAttribute()`. Since Symfony 7.3, the optional `?Vote $vote` argument lets the voter record reasons that appear in logs and on exception pages.

```php
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;
use Symfony\Component\Security\Core\Authorization\Voter\Vote;
use Symfony\Component\Security\Core\Authorization\Voter\Voter;

final class PostVoter extends Voter
{
    public const VIEW = 'POST_VIEW';
    public const EDIT = 'POST_EDIT';

    protected function supports(string $attribute, mixed $subject): bool
    {
        return in_array($attribute, [self::VIEW, self::EDIT], true) && $subject instanceof Post;
    }

    protected function voteOnAttribute(string $attribute, mixed $subject, TokenInterface $token, ?Vote $vote = null): bool
    {
        $user = $token->getUser();
        if (!$user instanceof User) {
            $vote?->addReason('The user is not logged in.');

            return false;
        }

        return match ($attribute) {
            self::VIEW => $subject->isPublished() || $subject->getAuthor() === $user,
            self::EDIT => $subject->getAuthor() === $user,
            default => false,
        };
    }
}
```

Check a voter with `#[IsGranted]` on the controller or the action. The second argument names the controller argument that holds the subject. Symfony 7.4 adds a `methods` argument that limits the check to some HTTP methods.

```php
#[IsGranted(PostVoter::EDIT, 'post')]
public function edit(Post $post): Response
{
}
```

Since Symfony 7.3, `#[IsGranted]` also accepts a closure that receives an `IsGrantedContext` and returns a boolean. Use it for a small rule that does not deserve its own voter. Inside a controller body, call `$this->denyAccessUnlessGranted(PostVoter::EDIT, $post)`.

To check a role inside a voter, inject `AccessDecisionManagerInterface` and call `decide($token, ['ROLE_ADMIN'])` with the token the voter received. `Security::isGranted()` inside a voter may use a different token than the one under evaluation. The default `affirmative` strategy grants access when one voter grants. The `consensus`, `unanimous`, and `priority` strategies are set under `security.access_decision_manager.strategy`.
</voters>

<forms_and_validation>
<constraints>
Put constraints that describe valid data on the entity or the DTO. Keep form-level `constraints` for fields that exist only on the form, such as a terms checkbox. A constraint declared in both places runs twice and drifts. Pass constraint options as named arguments.

```php
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;
use Symfony\Component\Validator\Constraints as Assert;

#[UniqueEntity(fields: ['email'], message: 'This email is already registered.')]
class User
{
    #[Assert\NotBlank]
    #[Assert\Length(min: 2, max: 100)]
    private string $name;

    #[Assert\NotBlank]
    #[Assert\Email]
    private string $email;
}
```

These built-in constraints often replace a custom one. `Assert\Sequentially` stops at the first failing constraint. `Assert\When` applies constraints only when an expression is true. `Assert\PasswordStrength` and `Assert\NotCompromisedPassword` replace password regexes. Use validation groups when one class has different rules per context, such as `registration` and `profile`.
</constraints>

<custom_constraint>
A custom constraint is a `Constraint` subclass with constructor arguments. Its validator class has the same name with a `Validator` suffix. Since 7.3, a custom constraint that does not support named arguments is deprecated. The validator returns early on `null` and `''`, so `NotBlank` stays the single owner of the empty check.

```php
use Symfony\Component\Validator\Constraint;

#[\Attribute(\Attribute::TARGET_PROPERTY)]
final class PhoneNumber extends Constraint
{
    public function __construct(
        public string $region = 'FR',
        public string $message = 'The phone number "{{ value }}" is not valid.',
        ?array $groups = null,
        mixed $payload = null,
    ) {
        parent::__construct(groups: $groups, payload: $payload);
    }
}
```
</custom_constraint>

<form_handling>
Pass the form object itself, not `$form->createView()`, to `render()`. Symfony then answers an invalid submit with HTTP 422, which Turbo and other clients expect.

```php
$form = $this->createForm(UserType::class, $user);
$form->handleRequest($request);

if ($form->isSubmitted() && $form->isValid()) {
    $this->entityManager->persist($user);
    $this->entityManager->flush();

    return $this->redirectToRoute('home');
}

return $this->render('user/register.html.twig', ['form' => $form]);
```

A data transformer that cannot convert a value throws `TransformationFailedException`, which turns into a form error. It never returns a guessed value. Add a field that depends on another field in both a `PRE_SET_DATA` and a `PRE_SUBMIT` listener. The first listener sees the model, and the second sees the raw submitted array. For a wizard, use `FormFlow` from Symfony 7.4 before you build step tracking by hand.
</form_handling>
</forms_and_validation>

<dtos_and_value_objects>
Do not use entities as API input or output. Map the request to an input DTO with `#[MapRequestPayload]`, and map the result to an output DTO. Input and output stay separate classes because their validation and fields differ. A DTO is a `final readonly class` with public promoted properties and no behavior.

Put `#[Assert\Valid]` on a property that holds nested DTOs, so their constraints run too. An array of nested DTOs needs a PHPDoc type such as `@var list<OrderLine>`. Without it, the serializer leaves each item a plain array.

A value object is immutable and compares by value. It validates in its constructor, and every change returns a new instance. Store money as an integer in minor units with a currency code, never as a float. Map a value object to columns with `#[ORM\Embeddable]` on the class and `#[ORM\Embedded(class: Money::class)]` on the entity property.
</dtos_and_value_objects>

<messenger>
<messages_and_handlers>
A message is a small `final readonly class` that carries ids and scalars, never entities. Doctrine entities do not serialize cleanly, and the handler must load fresh data anyway. The handler is a service with `#[AsMessageHandler]` and a typed `__invoke()`.

```php
use Symfony\Component\Messenger\Attribute\AsMessage;

#[AsMessage('async')]
final readonly class SendWelcomeEmail
{
    public function __construct(public int $userId)
    {
    }
}
```

```php
use Symfony\Component\Messenger\Attribute\AsMessageHandler;
use Symfony\Component\Messenger\Exception\UnrecoverableMessageHandlingException;

#[AsMessageHandler]
final readonly class SendWelcomeEmailHandler
{
    public function __construct(
        private UserRepository $users,
        private MailerInterface $mailer,
    ) {
    }

    public function __invoke(SendWelcomeEmail $message): void
    {
        $user = $this->users->find($message->userId)
            ?? throw new UnrecoverableMessageHandlingException("User {$message->userId} not found.");

        if ($user->isWelcomed()) {
            return;
        }

        $this->mailer->send(new WelcomeEmail($user));
    }
}
```

Delivery is at least once, so a handler must be idempotent. A redelivered message that finds its work done returns quietly. `#[AsMessage('async')]` routes the message since Symfony 7.2. A `routing` entry in `messenger.yaml` wins over the attribute.
</messages_and_handlers>

<transports_and_retries>
Transports are declared by DSN, such as `doctrine://default`, `redis://`, `amqp://`, `sync://` for in-process handling, and `in-memory://` for tests. The Doctrine transport on PostgreSQL uses LISTEN/NOTIFY by default through `use_notify`. This config retries a message three times with exponential backoff and then moves it to the `failed` transport.

```yaml
framework:
    messenger:
        failure_transport: failed
        transports:
            async:
                dsn: '%env(MESSENGER_TRANSPORT_DSN)%'
                retry_strategy:
                    max_retries: 3
                    delay: 1000
                    multiplier: 2
                    max_delay: 60000
                    jitter: 0.1
            failed: 'doctrine://default?queue_name=failed'
        routing:
            App\Message\SendWelcomeEmail: async
```

Without a `failure_transport`, Messenger discards a message after its last retry. Throw `UnrecoverableMessageHandlingException` for work that can never succeed, such as a missing record or a declined card. `RecoverableMessageHandlingException` retries without limit and ignores `max_retries`. It takes a `retryDelay` in milliseconds, and since 8.1 `forceRetry: false` makes it respect `max_retries`. Inspect and replay failures with `messenger:failed:show <id> -vv` and `messenger:failed:retry`.
</transports_and_retries>

<workers>
Run workers with `messenger:consume async` under a process manager, bounded by `--limit`, `--memory-limit`, or `--time-limit` so they restart before memory grows. Run `messenger:stop-workers` on every deploy, because a running worker keeps the old code. That command uses the app cache, so several hosts need a shared cache adapter such as Redis. In tests, set the transport to `in-memory://` under `when@test` and assert on `$transport->getSent()`. Symfony 8.1 adds `--fetch-size` and `--no-reset=N` to `messenger:consume`.
</workers>
</messenger>

<console_commands>
A console command is an invokable class with `#[AsCommand]` since Symfony 7.3. Arguments and options are `__invoke()` parameters with `#[Argument]` and `#[Option]`. Keep the business logic in a service that a controller or a message handler can call too.

```php
use Symfony\Component\Console\Attribute\Argument;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Attribute\Option;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(name: 'app:invoice:send', description: 'Sends pending invoices')]
final class SendInvoicesCommand
{
    public function __construct(private readonly InvoiceSender $sender)
    {
    }

    public function __invoke(SymfonyStyle $io, #[Argument] string $customer, #[Option] bool $dryRun = false): int
    {
        $count = $this->sender->sendPending($customer, $dryRun);
        $io->success("Sent {$count} invoices.");

        return Command::SUCCESS;
    }
}
```
</console_commands>

<quality_checks>
Symfony projects add framework checks to the PHP tools that SKILL.md covers. These commands are cheap and catch wiring errors that tests may miss.
- `php bin/console lint:container` checks service arguments against their types.
- `php bin/console lint:yaml config` and `php bin/console lint:twig templates` check config and templates.
- `php bin/console doctrine:schema:validate` checks the mappings against each other and the database.
- `php bin/console debug:autowiring <Type>`, `debug:container <id>`, `debug:messenger`, and `debug:router` show what the container and router really hold.

PHPStan understands the container, `getRepository()`, and DQL through the `phpstan/phpstan-symfony` and `phpstan/phpstan-doctrine` extensions. Use them when the project already installs them. PHP CS Fixer has a `@Symfony` rule set that many Symfony projects use.
</quality_checks>
