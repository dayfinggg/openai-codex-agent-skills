# Design checkpoint

Start with direct functions and one composition root.
Add a module boundary when ownership, lifecycle, or testing becomes clearer through separation.
Add an abstraction only after real callers reveal stable variation.
Keep duplicate test setup when sharing it would hide the behavior under test.
Measure before optimizing unless a hard safety or capacity limit already proves the constraint.
Use Matteo Collina's event-loop resource guidance to measure saturation and queueing, not only throughput. [T1]
