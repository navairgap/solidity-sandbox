# Reentrancy learning exercise

The repository now includes a corrected, local-only vault exercise in
`src/Vault.sol`. It demonstrates checks-effects-interactions (CEI): the
withdrawal function validates the caller's recorded balance, reduces the balance
and aggregate deposits, and only then transfers ether to the caller.

This is a teaching exercise, not deployable financial software. A deliberately
vulnerable companion contract is not included yet; do not treat the corrected
example as a side-by-side exploit demonstration.

## Learning objective

Understand how an external value transfer hands control to an untrusted receiver.
The receiver may execute arbitrary code, including a callback into the original
contract. The corrected example makes the callback observe the already-updated
accounting state.

## Implemented scenario

1. A user deposits ether through `deposit()`; the vault records the user's balance
   and increments `totalDeposits`.
2. A user calls `withdraw(amount)`; the vault rejects zero or excessive amounts.
3. Before transferring ether, the vault subtracts the withdrawal from the user's
   balance and from `totalDeposits`.
4. The vault sends ether with a low-level call and reverts with
   `TransferFailed` if the receiver rejects the payment.
5. If the receiver calls `withdraw` again during its receive callback, the nested
   call sees the reduced balance and cannot withdraw the same amount a second time.

A revert from the payout call reverts the entire transaction, including the
accounting effects, so the user's recorded balance remains available for a later
withdrawal.

## Test expectations

`test/Vault.t.sol` covers:

- Deposits and withdrawals updating the user balance, aggregate deposits, and
  contract ether balance.
- Rejection of zero-value deposits and zero-amount withdrawals.
- Exact insufficient-balance error data and unchanged accounting on rejected
  withdrawals.
- A receiver that rejects ether, proving the failed payout restores accounting.
- A malicious receiver callback, proving a nested withdrawal sees zero remaining
  balance after the original withdrawal's effects.
- Deposit and withdrawal event signatures, indexed account, and data payloads.

Run the tests only on Foundry's local test environment. No RPC endpoint, funded
wallet, or mainnet deployment is necessary.

## Review questions

- Which state changes happen before the external call?
- Why does a low-level call still require an explicit success check?
- What state is visible to the receiver during its callback?
- Why does a failed payout restore the balance even though effects ran first?
- Why is CEI a useful invariant-preserving pattern but not a complete audit?

A future lesson may add a clearly labelled vulnerable implementation for
comparison. Any such example must remain isolated from the corrected vault and
must only use synthetic local funds.
