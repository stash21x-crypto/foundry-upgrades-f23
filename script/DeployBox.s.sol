// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

/// @title DeployBox
/// @notice Deploys a BoxV1 implementation behind an ERC1967 proxy.
contract DeployBox is Script {
    /// @notice Deploys an implementation and initializes its proxy.
    /// @return proxyAddress Address of the deployed ERC1967 proxy.
    function run() external returns (address proxyAddress) {
        return deployBox();
    }

    /// @notice Deploys and initializes the V1 proxy.
    /// @return proxyAddress Address of the deployed ERC1967 proxy.
    function deployBox() public returns (address proxyAddress) {
        vm.startBroadcast();
        BoxV1 box = new BoxV1(); // implementation logic
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), abi.encodeWithSelector(BoxV1.initialize.selector));
        vm.stopBroadcast();
        return address(proxy);
    }
}
