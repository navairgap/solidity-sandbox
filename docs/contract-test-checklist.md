# contract test checklist

Use a local development chain and never real funds for teaching exercises. Test authorized and unauthorized callers, boundary values, events and state changes, malicious receiver reentrancy, failed external calls, pause and ownership recovery paths, and accounting invariants. Review static-analysis warnings rather than treating tools as guarantees. Pair every vulnerable teaching example with a corrected implementation and regression test.
## State-integrity checks

For contracts that move value or update accounting, add invariant tests for conservation of balances, total-supply consistency, and authorization boundaries. Assert that a reverted external call leaves all relevant state unchanged, and test reentrancy with a malicious receiver in a local test chain. Keep fuzz seeds and compiler settings with the test output so a failing case can be reproduced. Never use real funds or a production RPC endpoint for these exercises.
