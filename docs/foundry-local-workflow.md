# Reproducible local Foundry workflow (proposed)

Solidity exercises should be reproducible and local by default. This document proposes a workflow for a future Foundry-based version of the repository; no contracts or toolchain are implemented by this document.

## Toolchain policy

Choose and pin a Solidity compiler version for each exercise. Pin the Foundry toolchain or document the exact stable release used for verification. Keep dependency versions explicit and review dependency updates separately from contract changes.

A future project configuration should specify the source, test, and output directories and enable compiler settings consistently. Avoid relying on a globally installed, unpinned compiler.

## Local-only development

- Run unit tests against a local development environment.
- Do not add scripts that deploy exercises to mainnet or use funded accounts.
- Use deterministic test fixtures and local accounts with no real value.
- Keep private keys and populated environment files out of version control.
- Make any forked-network test opt-in and require an explicit RPC endpoint.

## Review commands

Once Foundry files exist, the expected verification sequence should include formatting checks, compilation, unit tests, and static analysis where supported. Record the exact command and tool version in the pull request or exercise notes. A successful test run is evidence for the tested cases, not a production security certification.

## Expected test structure

Separate normal behavior tests, authorization failures, boundary inputs, external-call failures, and adversarial reentrancy scenarios. Verify both expected reverts and that state remains unchanged after rejected operations. Keep each teaching exercise isolated so learners can understand the threat model.