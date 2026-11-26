// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {UUPSUpgradeable} from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title BoxV1
/// @notice Initial implementation for the upgradeable UUPS box contract.
/// @dev State is stored in the ERC1967 proxy. Each implementation must preserve
/// this layout and leave storage gaps for future additions.
contract BoxV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 internal number;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @notice Initializes ownership and upgradeable contract dependencies.
    /// @dev Can only be called once by the proxy's initializer.
    function initialize() public initializer {
        __Ownable_init(msg.sender);
    }

    /// @notice Returns the stored number.
    /// @return The current stored value.
    function getNumber() external view virtual returns (uint256) {
        return number;
    }

    /// @notice Returns the implementation version.
    /// @return The V1 implementation version.
    function version() external pure virtual returns (uint256) {
        return 1;
    }

    /// @dev Restricts implementation upgrades to the contract owner.
    /// @param newImplementation Address of the proposed implementation.
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    uint256[49] private __gap;
}
