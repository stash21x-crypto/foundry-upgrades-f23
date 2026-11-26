# Foundry UUPS Upgradeable Box

![Smart Contract Development](https://img.shields.io/badge/Focus-Smart%20Contract%20Development-blue)
![Education](https://img.shields.io/badge/Learning-Cyfrin%20Updraft-orange)
![License](https://img.shields.io/badge/License-MIT%20License-yellow)

A Foundry project demonstrating deployment and upgrading of a UUPS
(Universal Upgradeable Proxy Standard) proxy.

The proxy stores state and delegates calls to an implementation contract.
`BoxV1` is deployed behind an `ERC1967Proxy` and initialized through the proxy.
`BoxV2` inherits from `BoxV1` and adds a setter while preserving the existing
storage layout.

## Contracts

| Contract | Purpose |
| --- | --- |
| `src/BoxV1.sol` | Initial UUPS implementation with initialization, ownership, version, and storage-gap logic |
| `src/BoxV2.sol` | Upgrade implementation that adds `setNumber` and reports version 2 |
| `script/DeployBox.s.sol` | Deploys `BoxV1` and an initializing `ERC1967Proxy` |
| `script/UpgradeBox.s.sol` | Deploys `BoxV2` and upgrades the latest proxy recorded for the chain |
| `test/DeployAndUpgradeTest.t.sol` | Tests deployment and the V1-to-V2 upgrade flow |

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Git submodules initialized

```shell
forge install
```

## Build and Test

```shell
forge fmt
forge build
forge test
```

## Deploy

Start a local Anvil node:

```shell
anvil
```

In another terminal, deploy the V1 implementation and proxy:

```shell
forge script script/DeployBox.s.sol:DeployBox \
  --rpc-url http://127.0.0.1:8545 \
  --broadcast \
  --private-key <private_key>
```

After deployment, upgrade the latest proxy recorded for the connected chain:

```shell
forge script script/UpgradeBox.s.sol:UpgradeBox \
  --rpc-url http://127.0.0.1:8545 \
  --broadcast \
  --private-key <private_key>
```

Use the same private key that owns the deployed proxy. Keep private keys out of
source control and never commit real credentials.

## Security Notes

- Upgrade authorization is restricted to the proxy owner.
- Implementation constructors are disabled for initialization.
- Proxy state is separate from implementation state.
- `BoxV1` includes a storage gap for future implementation compatibility.

---

## Acknowledgements

Built following the [Cyfrin Updraft](https://updraft.cyfrin.io/) Foundry DeFi course by Patrick Collins.

---

## License

[MIT](LICENSE)