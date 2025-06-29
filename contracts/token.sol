// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./withdrawals.sol";

contract Dapa is DapaWithdrawals {
    constructor() ERC20("Dapa", "DPA") {}
}