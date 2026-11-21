# solidity-sandbox

A local workspace for learning Solidity through small contracts, regression tests,
and security-focused exercises.

> **Current state: first Foundry exercise.** The repository includes a pinned
> Solidity compiler configuration and an owner-controlled Counter contract. It is
> a teaching exercise, not production contract code.

## First exercise: Counter

The Counter stores a single integer. Only the deploying address can increment or
reset it. Each operation emits the previous and new values. The tests cover owner
behavior, unauthorized custom-error data, state preservation after rejected calls,
and the event payloads for increment and reset.

The project uses Foundry, Solidity 0.8.24, and no third-party test dependency. Run
the local checks from the repository root:

```sh
forge fmt --check
forge build
forge test -vvv
```

CI pins Foundry v1.10.0 and runs the same formatting, build, and test checks. No
network endpoint, funded account, private key, or mainnet deployment is required
for this exercise.

## Security boundaries

- Keep all exercises on a local development chain.
- Never commit private keys, seed phrases, or populated environment files.
- Keep generated build output and broadcast records out of version control.
- A passing test suite is evidence only for the cases tested, not a production
  security certification.
- Keep intentionally vulnerable examples separate from corrected examples and
  label unsafe code clearly.

## Planned exercises

- [ ] Add paired vulnerable and corrected reentrancy examples.
- [ ] Add failed-external-call and ownership-recovery regression scenarios.
- [ ] Add optional static analysis as more exercises are introduced.

## License

MIT. See [LICENSE](LICENSE).
