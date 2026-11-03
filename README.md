# solidity-sandbox

A local workspace for learning Solidity through small contracts, tests, and security-focused exercises.

> **Current state: first Foundry exercise.** The repository now has a pinned Solidity compiler configuration and an owner-controlled Counter contract with local tests. It is a teaching exercise, not production contract code.

## First exercise: Counter

The Counter stores a single integer. Only the deploying address can increment or reset it. Every successful state change emits the prior and new values. The tests cover normal owner behavior and verify that unauthorized calls fail without changing state.

The project uses Foundry with Solidity 0.8.24 and no third-party test dependency. Run the local checks with a compatible Foundry installation:

    forge fmt --check
    forge build
    forge test -vv

No network endpoint, funded account, private key, or mainnet deployment is required.

## Security boundaries

- Keep all exercises on a local development chain.
- Never commit private keys, seed phrases, or populated environment files.
- A passing test suite is evidence only for the cases tested, not a production security certification.
- Keep intentionally vulnerable examples separate from corrected examples and label unsafe code clearly.

## Planned exercises

- [ ] Add paired vulnerable and corrected reentrancy examples.
- [ ] Add authorization and failed-external-call regression tests.
- [ ] Add static analysis and CI once the exercise set expands.
- [ ] Record the exact Foundry release used by each verification run.

## License

MIT. See [LICENSE](LICENSE).
