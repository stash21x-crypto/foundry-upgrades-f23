# Foundry UUPS Upgradeable Box

![Smart Contract Development](https://img.shields.io/badge/Focus-Smart%20Contract%20Development-blue)
![Education](https://img.shields.io/badge/Learning-Cyfrin%20Updraft-orange)
![License](https://img.shields.io/badge/License-MIT%20License-yellow)

A small Foundry project demonstrating how to deploy, initialize, interact with,
and upgrade a UUPS (Universal Upgradeable Proxy Standard) smart contract. It
uses OpenZeppelin's `ERC1967Proxy` and UUPS implementation, with a simple
two-version `Box` contract as the example.

> **Learning example:** `BoxV2.setNumber` is intentionally unrestricted so the
> upgrade flow stays easy to demonstrate. Do not deploy this example with real
> value or use it as-is in production.

## How the upgrade works

An ERC1967 proxy keeps the contract address and persistent state. Calls to that
address are delegated to its current implementation, so users continue to
interact with the same proxy address after an upgrade.

1. `DeployBox` deploys a `BoxV1` implementation.
2. The script deploys an `ERC1967Proxy` pointing to that implementation and
   calls `initialize` as part of proxy construction. The broadcasting account
   becomes the proxy owner.
3. `UpgradeBox` locates the latest proxy deployment recorded for the current
   chain, deploys `BoxV2`, and calls `upgradeToAndCall` through the proxy.
4. The proxy now delegates to V2. Existing proxy state is retained, and V2 adds
   the `setNumber` function.

## Project structure

| Path | Description |
| --- | --- |
| `src/BoxV1.sol` | Initial UUPS implementation, one-time initializer, owner-gated upgrade authorization, and reserved storage gap |
| `src/BoxV2.sol` | V2 implementation; adds `setNumber` and returns version `2` |
| `script/DeployBox.s.sol` | Deploys the V1 implementation and initialized ERC1967 proxy |
| `script/UpgradeBox.s.sol` | Deploys V2 and upgrades the most recently recorded proxy for the chain |
| `test/DeployAndUpgradeTest.t.sol` | Covers V1 behavior, successful upgrade, and rejection of a zero implementation address |
| `foundry.toml` | Foundry project paths and OpenZeppelin remappings |

## Requirements and setup

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Git

Clone the repository with its dependencies:

```shell
git clone --recurse-submodules https://github.com/stash21x-crypto/foundry-upgrades-f23.git
cd foundry-upgrades-f23
```

If you already cloned without submodules, initialize them with:

```shell
git submodule update --init --recursive
```

## Build, format, and test

```shell
forge build
forge test -vvv
```

Format Solidity files and check formatting in CI:

```shell
forge fmt
forge fmt --check
```

## Run locally with Anvil

In one terminal, start a local Ethereum node:

```shell
anvil
```

In another terminal, set a private key from an Anvil account. Anvil's printed
accounts and keys are for local development only; never use them on a public
network or with real funds.

```shell
export PRIVATE_KEY='0xYOUR_ANVIL_PRIVATE_KEY'
export RPC_URL=http://127.0.0.1:8545
```

Replace the placeholder with a private key printed by Anvil.

Deploy V1 and its proxy:

```shell
forge script script/DeployBox.s.sol:DeployBox \
  --rpc-url "$RPC_URL" \
  --broadcast \
  --private-key "$PRIVATE_KEY"
```

The script's return value is the proxy address. Forge also writes deployment
records under `broadcast/`. Keep these records available: the upgrade script
uses the recorded `ERC1967Proxy` deployment for the chain ID it is run against.

Deploy V2 and upgrade that proxy:

```shell
forge script script/UpgradeBox.s.sol:UpgradeBox \
  --rpc-url "$RPC_URL" \
  --broadcast \
  --private-key "$PRIVATE_KEY"
```

Use the same account that initialized the proxy, since only its owner can
authorize the UUPS upgrade. Run the upgrade against the same chain, and keep the
deployment records for that chain available.

### Interact with the upgraded proxy

Set `PROXY_ADDRESS` to the address returned by the deployment script:

```shell
export PROXY_ADDRESS=0xYOUR_PROXY_ADDRESS
```

Replace the placeholder with the address returned by the deployment script.

Read the implementation version, write a number, and read it back:

```shell
cast call "$PROXY_ADDRESS" "version()(uint256)" --rpc-url "$RPC_URL"
cast send "$PROXY_ADDRESS" "setNumber(uint256)" 42 \
  --rpc-url "$RPC_URL" \
  --private-key "$PRIVATE_KEY"
cast call "$PROXY_ADDRESS" "getNumber()(uint256)" --rpc-url "$RPC_URL"
```

After upgrading, `version()` returns `2`, and `getNumber()` returns the value
written through V2. The `setNumber` call can be made by any account in this
demonstration; add suitable access control before adapting the example.

## Upgrade and security considerations

- **Protect the owner key.** The proxy owner controls implementation upgrades.
  For networks beyond local development, use a protected keystore or multisig
  rather than putting a raw key in shell history or scripts.
- **Preserve storage layout.** New implementations must retain the order and
  types of existing state variables and compatible inheritance. `BoxV1`
  reserves a storage gap for future extension; do not casually reorder or
  repurpose existing storage.
- **Initialize through the proxy.** The implementation constructor disables
  initialization on the implementation itself; the proxy is initialized during
  deployment.
- **Review new implementation code.** This project is an educational example,
  not a production-ready upgrade framework. Validate upgrade compatibility,
  access control, and deployment records before using these patterns elsewhere.

## Acknowledgements

Built while following the [Cyfrin Updraft](https://updraft.cyfrin.io/) Foundry
DeFi course by Patrick Collins.

## License

[MIT](LICENSE)
