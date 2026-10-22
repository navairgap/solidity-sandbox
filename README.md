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

## Contract review checklist

Use this checklist for each exercise before calling it complete:

- [ ] **Authorization:** every privileged state change checks the intended caller.
- [ ] **External calls:** checks-effects-interactions ordering is deliberate; external calls are treated as failure points.
- [ ] **Reentrancy:** tests attempt nested calls where an external call can re-enter state-changing code.
- [ ] **Arithmetic and units:** token amounts, timestamps, and percentages have documented units and boundary tests.
- [ ] **Input bounds:** zero addresses, empty values, maximum values, and invalid enum values are covered.
- [ ] **Events:** successful state changes emit events with enough context for off-chain consumers.
- [ ] **Failure paths:** tests verify reverts and confirm state remains unchanged after rejected operations.
- [ ] **Dependencies:** compiler version and third-party dependencies are pinned for reproducible builds.

For a deliberately vulnerable teaching contract, list the exact vulnerability beside the example and link it to a test that demonstrates the failure. Keep the corrected contract and regression test separate so learners can compare them.

## Security note

These exercises are for education. Passing tests or static analysis does not establish that a contract is safe for production. Real deployments require independent review and a threat model appropriate to the value at risk.

## License

MIT. See [LICENSE](LICENSE).


## Maintenance notes

Use a local chain and pinned compiler settings for reproducible exercises. Test both authorized and unauthorized callers, boundary values, external-call failures, and reentrancy where applicable. Never place real keys or funded accounts in examples.
