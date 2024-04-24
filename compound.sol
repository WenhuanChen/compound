// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Compound {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public borrowBalance;
    mapping(address => uint256) public borrowRate;
    uint256 public totalSupply;

    event Supply(address indexed supplier, uint256 amount);
    event Borrow(address indexed borrower, uint256 amount);
    event Repay(address indexed borrower, uint256 amount);

    function supply(uint256 amount) external {
        balances[msg.sender] += amount;
        totalSupply += amount;
        emit Supply(msg.sender, amount);
    }

    function borrow(uint256 amount) external {
        require(amount <= totalSupply, "Insufficient liquidity");
        borrowBalance[msg.sender][address(this)] += amount;
        borrowRate[msg.sender] = 0.1 * amount; // Simplified interest rate calculation
        emit Borrow(msg.sender, amount);
    }

    function repay(uint256 amount) external {
        require(amount <= balances[msg.sender], "Insufficient balance");
        require(amount <= borrowBalance[msg.sender][address(this)], "Nothing to repay");
        balances[msg.sender] -= amount;
        borrowBalance[msg.sender][address(this)] -= amount;
        totalSupply -= amount;
        emit Repay(msg.sender, amount);
    }
}
