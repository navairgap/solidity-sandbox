# Paired reentrancy learning exercise (proposed)

This exercise should teach how an external call can transfer control to an untrusted contract before the caller has completed its state transition. It is a local educational exercise, not deployable financial software.

## Learning objective

Compare a deliberately vulnerable example with a corrected implementation. Learners should be able to explain the call sequence, identify the violated invariant, reproduce the issue with a local test contract, and show why the correction prevents repeated withdrawal.

## Exercise boundaries

- Use a local-only test environment with synthetic balances and no real funds.
- Clearly label the vulnerable contract as intentionally unsafe.
- Keep the vulnerable and corrected versions separate.
- Do not include mainnet deployment instructions or private keys.
- Document the intended invariant before writing either implementation.

## Required scenario

A user deposits a synthetic balance. The vulnerable withdrawal path performs an external value transfer before updating the user's recorded balance. A test receiver re-enters the withdrawal function before the original call updates state. The resulting test should demonstrate that the invariant can be violated.

The corrected path should update internal state before making the external call and should handle a failed external call according to a documented policy. A reentrancy guard may be compared as an additional defense, but it must not replace checks-effects-interactions reasoning.

## Test expectations

Verify normal deposit and withdrawal, zero balance, unauthorized access to privileged functions, failed external transfer, nested re-entry attempt, and unchanged state after rejected operations. Tests should assert balances and call counts rather than relying only on a revert string.

## Discussion

Explain why checks-effects-interactions reduces this class of reentrancy risk, why external calls remain failure points, and why a small test does not prove a contract safe against every callback path.