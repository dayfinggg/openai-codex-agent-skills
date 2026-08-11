# Cycle evidence

Use this record for multiple cycles, consequential behavior, or a workflow whose red and green observations could otherwise be confused. Keep it in working notes unless a repository artifact is requested.

| Field | Required evidence |
|---|---|
| Behavior | One approved observable outcome |
| Test | Stable test identifier and boundary |
| Red command | Exact focused command and relevant environment |
| Red observation | Failure status and signal proving the intended missing or incorrect behavior |
| Green command | The same command or a documented comparable command |
| Green observation | Passing status after the smallest complete implementation |
| Refactor observation | Passing focused result after each material behavior-preserving change |
| Regression | Broader gates run and any unrelated failure that limits confidence |

A valid red is not a syntax error, broken import, missing fixture, unavailable service, or unrelated baseline failure. A valid green does not come from skipping the test, weakening its oracle, updating a snapshot without contract evidence, broadening a tolerance, or branching production code on fixture data.

If behavior already passed before the change, label the result as characterization or regression evidence rather than inventing a red. If the environment prevents a comparable observation, mark the cycle blocked or inconclusive and state the consequence.
