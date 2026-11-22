// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/// @notice A local-only teaching vault that demonstrates checks-effects-interactions.
contract Vault {
    mapping(address => uint256) public balances;
    uint256 public totalDeposits;

    error ZeroAmount();
    error InsufficientBalance(address account, uint256 requested, uint256 available);
    error TransferFailed();

    event Deposited(address indexed account, uint256 amount, uint256 newBalance);
    event Withdrawn(address indexed account, uint256 amount, uint256 newBalance);

    function deposit() external payable {
        if (msg.value == 0) revert ZeroAmount();

        balances[msg.sender] += msg.value;
        totalDeposits += msg.value;

        emit Deposited(msg.sender, msg.value, balances[msg.sender]);
    }

    function withdraw(uint256 amount) external {
        if (amount == 0) revert ZeroAmount();

        uint256 available = balances[msg.sender];
        if (amount > available) {
            revert InsufficientBalance(msg.sender, amount, available);
        }

        // Effects happen before the external call so a callback sees the reduced balance.
        balances[msg.sender] = available - amount;
        totalDeposits -= amount;
        emit Withdrawn(msg.sender, amount, balances[msg.sender]);

        (bool success,) = payable(msg.sender).call{value: amount}("");
        if (!success) revert TransferFailed();
    }
}
