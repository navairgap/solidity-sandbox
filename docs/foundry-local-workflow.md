# Reproducible local Foundry workflow

This repository is an active Foundry project. The first exercise is an owner-controlled
`Counter` contract with a small, dependency-free regression suite.

## Pinned toolchain

- Solidity compiler: `0.8.24`, configured in `foundry.toml`.
- Optimizer: enabled with 200 runs, configured in `foundry.toml`.
- Foundry CLI: `v1.10.0`, pinned in `.github/workflows/ci.yml`.
- The first exercise does not require third-party Solidity libraries.

Keep compiler and Foundry version changes explicit in reviewable commits. When changing
either version, rerun the complete local verification sequence and record the version
used in the change description.

## Local-only development

- Run unit tests with Foundry's local test runner.
- No RPC endpoint, funded account, private key, or mainnet deployment is needed for
  the current exercise.
- Do not add deployment scripts that default to a public network.
- Keep private keys, seed phrases, and populated environment files out of version
  control.
- Keep generated build output and broadcast records out of commits.

## Verification

Run these commands from the repository root:

```sh
forge --version
forge fmt --check
forge build
forge test -vvv
```

CI runs the same formatting, build, and test checks. Foundry may download the pinned
Solidity compiler the first time it is needed; this is a compiler download, not a
connection to an Ethereum RPC endpoint.

## Test structure

Separate normal behavior, authorization failures, boundary inputs, external-call
failures, and adversarial reentrancy scenarios. Assert both expected revert data and
that relevant state remains unchanged after rejected operations. Keep each exercise
isolated so learners can identify its threat model.

A passing test suite is evidence for the properties and inputs it checks. It is not
a production security certification.
