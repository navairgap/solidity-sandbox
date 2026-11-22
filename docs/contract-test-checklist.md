# Contract test checklist

Use a local development chain and never real funds for teaching exercises. Test
authorized and unauthorized callers, boundary values, events and state changes,
malicious receiver reentrancy, failed external calls, pause and ownership recovery
paths, and accounting invariants. Review static-analysis warnings rather than
treating tools as guarantees. Pair every vulnerable teaching example with a
corrected implementation and regression test.

## Current Counter regression baseline

- The deploying address is recorded as the immutable owner.
- The initial count is zero.
- The owner can increment the count and receives the new value.
- The owner can reset a non-zero count to zero.
- A non-owner cannot increment or reset the count.
- Unauthorized reverts include the exact unauthorized caller in the custom-error
  payload, and rejected calls leave the count unchanged.
- Increment and reset each emit one `CountChanged` event from the Counter contract.
- The event includes the owner as its indexed caller and the correct previous and
  new count values.

## Current Vault regression baseline

- A non-zero deposit increases the caller's balance, `totalDeposits`, and the
  vault's ether balance by the same amount.
- A withdrawal reduces the caller's balance and `totalDeposits` before the
  receiver callback, then transfers the requested ether.
- Zero-value deposits and zero-amount withdrawals revert with `ZeroAmount`.
- A withdrawal above the caller's balance reverts with the exact
  `InsufficientBalance` payload and leaves accounting unchanged.
- A receiver that rejects ether causes `TransferFailed`; the transaction revert
  restores the caller's balance and aggregate deposits.
- A reentrant receiver cannot withdraw twice: its nested call observes the
  post-effects balance and fails with `InsufficientBalance`.
- Deposit and withdrawal events identify the caller and report the amount and
  resulting balance.

## State-integrity checks

For contracts that move value or update accounting, add invariant tests for
conservation of balances, total-supply consistency, and authorization boundaries.
Assert that a reverted external call leaves all relevant state unchanged, and test
reentrancy with a malicious receiver in a local test chain. Keep fuzz seeds and
compiler settings with the test output so a failing case can be reproduced. Never
use real funds or a production RPC endpoint for these exercises.

For the Vault, compare the sum of recorded user balances with `totalDeposits`
across deposit and withdrawal sequences. Keep forced ether transfers and other
out-of-band balance changes distinct from recorded user deposits; the contract
balance is not by itself a complete accounting ledger.

## Differential and fuzz testing

For functions with arithmetic or multiple valid inputs, use fuzz tests to check
invariants across edge values rather than relying only on hand-picked examples.
Where a simpler reference model exists, compare contract outputs against that
model over the same input set. Preserve failing fuzz seeds and compiler settings
so regressions are reproducible. A passing test suite is evidence for the tested
properties, not proof that a contract is safe for production.
