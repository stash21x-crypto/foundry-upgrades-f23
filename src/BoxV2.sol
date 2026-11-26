// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {BoxV1} from "./BoxV1.sol";

/// @title BoxV2
/// @notice Upgradeable box implementation that adds number setters.
contract BoxV2 is BoxV1 {
    /// @notice Sets the stored number.
    /// @param newNumber The value to store.
    function setNumber(uint256 newNumber) external {
        number = newNumber;
    }

    /// @notice Returns the stored number.
    /// @return The current stored value.
    function getNumber() external view override returns (uint256) {
        return number;
    }

    /// @notice Returns the implementation version.
    /// @return The V2 implementation version.
    function version() external pure virtual override returns (uint256) {
        return 2;
    }
}
