# reproducible lab workflow

Use a local chain and pinned toolchain for exercises. Keep each example small and include tests for expected behavior and adversarial cases. Record compiler version and optimizer settings because they affect reproducibility. Never put real keys or funded accounts in example configuration. Pair vulnerable examples with corrected versions, and label teaching vulnerabilities clearly so snippets are not mistaken for production-ready contracts.

## Test run record

For each exercise, record the compiler version, optimizer and EVM settings, test framework version, chain configuration, command invoked, exit status, and any fuzz seed that reproduces a failure. Keep generated build artifacts out of the teaching source unless they are intentionally versioned fixtures. A result is reproducible only when another contributor can rerun the documented command in a clean local environment and obtain the same asserted behavior.

## Key and environment isolation

Generate disposable local keys for every exercise and keep them outside committed fixtures. Before running a deployment script, verify its RPC endpoint is a local development chain and that the selected account is a test account with no real funds. A test should fail closed when the endpoint is missing or unexpectedly points at a public network. Remove temporary keystores and environment files during teardown, and never print private key material in test output.
