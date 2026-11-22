# solidity-sandbox

A local workspace for learning Solidity through small contracts, regression tests,
and security-focused exercises.

> **Current state: Counter and Vault exercises.** The repository uses Foundry and a
> pinned Solidity compiler configuration. These contracts are teaching examples,
> not production financial software.

## Exercise 1: Counter

The Counter stores a single integer. Only the deploying address can increment or
reset it. Each operation emits the previous and new values. The tests cover owner
behavior, unauthorized custom-error data, state preservation after rejected calls,
and the event payloads for increment and reset.

## Exercise 2: Vault and checks-effects-interactions

The Vault records each depositor's balance and aggregate deposits. Withdrawals
validate the caller's balance, update accounting before making the external ether
transfer, and revert if the receiver rejects payment.

The tests cover zero amounts, insufficient balances, payout failures, emitted
events, and a malicious receiver that attempts a nested withdrawal from its
receive callback. The nested call must observe the already-reduced balance and
cannot withdraw the same funds twice.

The vulnerable companion example is intentionally not included yet. The current
Vault demonstrates the corrected checks-effects-interactions pattern; it is not
a complete reentrancy audit or a production-ready vault.

## Toolchain and local checks

The project uses Solidity 0.8.24, optimizer settings in `foundry.toml`, and
Foundry v1.10.0 in CI. No third-party Solidity test dependency is required.

Run the checks from the repository root:

```sh
forge fmt --check
forge build
forge test -vvv
```

No RPC endpoint, funded account, private key, or mainnet deployment is required
for the current exercises.

## Security boundaries

- Keep all exercises on a local development chain.
- Never commit private keys, seed phrases, or populated environment files.
- Keep generated build output and broadcast records out of version control.
- A passing test suite is evidence only for the cases tested, not a production
  security certification.
- Keep intentionally vulnerable examples separate from corrected examples and
  label unsafe code clearly.

## Planned exercises

- [ ] Add a clearly labelled vulnerable reentrancy example for local comparison
      with the corrected Vault.
- [ ] Add fuzz and invariant tests for multi-user deposit and withdrawal sequences.
- [ ] Add optional static analysis as the exercise set expands.

## License

MIT. See [LICENSE](LICENSE).
