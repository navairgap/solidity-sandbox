# solidity-sandbox

Practice smart contracts with full test coverage

> 🚧 **Status: planning** — architecture and README first, code next.

## Why

Learning Solidity properly means writing contracts AND attacking them. This repo collects practice contracts with Hardhat tests, plus deliberately-vulnerable examples and the fixes.

## Planned features

- Basic contracts: token, vault, multisig
- Test suite with Hardhat + chai, targeting 100% coverage
- Deliberately vulnerable contracts with exploit tests, then fixed versions
- Gas-optimization comparisons for each contract

## Stack

`solidity` `hardhat` `javascript`

## Notes

Never deploy these to mainnet; local fork only.

## License

MIT, see [LICENSE](LICENSE).

---
maintained · verified 2026-09-30

## Security

- never point this at mainnet; the sandbox exists so you never have to
- testnet keys are throwaway — treat any key that touched a funded wallet as compromised
- no `PRIVATE_KEY` in the repo, ever; `.env` is gitignored and that's load-bearing

## Security

- never point this at mainnet; the sandbox exists so you never have to
- testnet keys are throwaway — treat any key that touched a funded wallet as compromised
- no `PRIVATE_KEY` in the repo, ever; `.env` is gitignored and that's load-bearing

## Testnets

sepolia is the default — stable, cheap, faucets alive. keep deploy keys in `.env` (gitignored), never commit them, treat any key that touched a funded wallet as burned.

## Common tasks

compile: `forge build` (or `solc --bin`). deploy to sepolia: `forge script script/Deploy.s.sol --broadcast --verify`. verify on explorer: `forge verify-contract`. the sandbox scripts mirror these one-to-one.

## Layout

contracts/, script/, test/ — if a file doesn't fit one of the three, it's grown up and needs its own repo.

## Telemetry

none. the sandbox makes no outbound calls at runtime beyond the rpc endpoint you configure. compile, deploy, verify — all between you and the chain.
