// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/// @notice A deliberately small, owner-controlled state exercise for local tests.
contract Counter {
    address public immutable owner;
    uint256 public count;

    error Unauthorized(address caller);

    event CountChanged(address indexed caller, uint256 previousValue, uint256 newValue);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized(msg.sender);
        _;
    }

    function increment() external onlyOwner returns (uint256) {
        uint256 previous = count;
        count = previous + 1;
        emit CountChanged(msg.sender, previous, count);
        return count;
    }

    function reset() external onlyOwner {
        uint256 previous = count;
        count = 0;
        emit CountChanged(msg.sender, previous, 0);
    }
}
