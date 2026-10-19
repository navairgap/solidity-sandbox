# solidity-sandbox

A planned local workspace for learning Solidity through small contracts, tests, and security-focused exercises.

> **Status: design stage.** This repository currently contains documentation only; contracts and automated tests are not implemented yet.

## Learning goals

- Understand Solidity types, storage, events, and access control.
- Write tests that cover expected behavior and important failure cases.
- Study common contract risks such as missing authorization, unsafe external calls, and reentrancy.
- Compare a vulnerable teaching example with a corrected version and a regression test.

## Proposed structure

```text
contracts/    small, isolated teaching examples
test/         unit tests and adversarial cases
script/       optional local deployment scripts
```

## Safe development workflow

1. Start with a local development chain.
2. Write tests for both valid and invalid calls before adding features.
3. Use static analysis and compiler warnings as feedback, not as a security guarantee.
4. Never commit private keys, seed phrases, or populated environment files.
5. Do not deploy exercises to mainnet or handle real funds.

## Planned milestones

- [ ] Choose and document a toolchain (Foundry or Hardhat).
- [ ] Add one minimal contract and deterministic unit tests.
- [ ] Add a deliberately vulnerable teaching example with an explicit warning.
- [ ] Add a corrected version and regression test.
- [ ] Add static analysis to CI once the project has runnable code.

## Security note

These exercises are for education. Passing tests or static analysis does not establish that a contract is safe for production. Real deployments require independent review and a threat model appropriate to the value at risk.

## License

MIT. See [LICENSE](LICENSE).
