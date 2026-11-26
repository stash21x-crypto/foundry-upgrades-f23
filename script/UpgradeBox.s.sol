// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";

/// @title UpgradeBox
/// @notice Deploys BoxV2 and upgrades the most recently deployed ERC1967 proxy.
contract UpgradeBox is Script {
    /// @notice Finds the latest proxy for this chain, deploys V2, and upgrades it.
    /// @return proxyAddress Address of the upgraded proxy.
    function run() external returns (address proxyAddress) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        BoxV2 newBox = new BoxV2();
        vm.stopBroadcast();
        return upgradeBox(mostRecentlyDeployed, address(newBox));
    }

    /// @notice Upgrades a proxy to a new implementation.
    /// @dev The caller must be the proxy owner.
    /// @param proxyAddress Address of the ERC1967 proxy.
    /// @param newImplementation Address of the V2 implementation.
    /// @return proxyAddress Address of the upgraded proxy.
    function upgradeBox(address proxyAddress, address newImplementation) public returns (address) {
        require(proxyAddress != address(0), "UpgradeBox: zero proxy");
        require(newImplementation != address(0), "UpgradeBox: zero implementation");

        vm.startBroadcast();
        BoxV1 proxy = BoxV1(proxyAddress);
        proxy.upgradeToAndCall(newImplementation, "");
        vm.stopBroadcast();
        return address(proxy);
    }
}
