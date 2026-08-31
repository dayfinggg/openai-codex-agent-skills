# Streams and messaging

- Use `XADD` to append entries with server-assigned time-ordered IDs and `XREAD` for direct ordered reads.
- Use `XREADGROUP` when workers should share entries within a consumer group.
- Multiple consumer groups can independently read the same stream and maintain separate progress.
- Consumer groups provide at-least-once delivery, not exactly-once side effects.
- A delivered but unacknowledged entry remains in the group's pending entries list.
- Acknowledge only after the side effect is durable, and make handlers idempotent by event ID or application key.
- Monitor `XPENDING` and reclaim stale work with `XCLAIM` or `XAUTOCLAIM` after a consumer failure.
- Decide how to handle poison messages, delivery-count limits, and dead-letter storage before production.
- Bound retention with `XADD ... MAXLEN ~ N` or `XTRIM MINID ~ id` based on replay needs and worst consumer lag.
- Trimming can remove a payload before it is acknowledged. Route missing payloads to a dead-letter or repair path.
- Partition streams by tenant, region, or entity only when the resulting hot keys and ordering guarantees are acceptable.
- Pub/Sub is appropriate for transient notifications, while Streams provide history, replay, acknowledgement, and recovery.
