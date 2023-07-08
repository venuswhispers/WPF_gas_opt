// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Unchecked {
    // checked (10,000 loop): 1,910,309 gas
    function forNormal(uint256 times) external pure returns (uint256 result) {
        for (uint256 i; i < times; i++) {
            result = i + 1;
        }
    }

    // unchecked (10,000 loop): 570,287 gas
    function forUnckecked(uint256 times) external pure returns (uint256 result) {
        for (uint256 i; i < times; ) {
            unchecked {
                result = i + 1;
                i++;
            }
        }
    }
}
