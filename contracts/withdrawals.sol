// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./funders.sol";

abstract contract DapaWithdrawals is DapaFunders {
    enum WithdrawalStatus { None, Submitted, Fulfilled, Declined }

    struct Withdrawal {
        uint256 amount;
        WithdrawalStatus status;
    }

    // funder => requester => withdrawal
    mapping(address => mapping(address => Withdrawal)) public withdrawals;

    // funder => stats. "Reputation" of a funder.
    mapping(address => uint256) public fulfilledTokens;
    mapping(address => uint256) public declinedTokens;

    modifier excludeFunders() {
        require(!proposals[msg.sender].exists, "Funders can't request withdrawals");
        _;
    }

    /// @notice Request withdrawal from a funder
    function requestWithdrawal(address funder, uint256 amount) external excludeFunders {
        Withdrawal storage existing = withdrawals[funder][msg.sender];
        require(existing.status != WithdrawalStatus.Submitted, "Already requested");
        require(amount > 0, "Amount must be positive");

        withdrawals[funder][msg.sender] = Withdrawal({
            amount: amount,
            status: WithdrawalStatus.Submitted
        });
    }

    /// @notice Funder fulfills a withdrawal (must have approval from requester)
    function fulfillWithdrawal(address requester) external {
        Withdrawal storage wd = withdrawals[msg.sender][requester];
        require(wd.status == WithdrawalStatus.Submitted, "No active request");

        // Funders pull tokens from requester using allowance
        require(allowance(requester, msg.sender) >= wd.amount, "Insufficient approval");
        transferFrom(requester, msg.sender, wd.amount);

        wd.status = WithdrawalStatus.Fulfilled;
        fulfilledTokens[msg.sender] += wd.amount;
    }

    /// @notice Funder declines a withdrawal
    function declineWithdrawal(address requester) external {
        Withdrawal storage wd = withdrawals[msg.sender][requester];
        require(wd.status == WithdrawalStatus.Submitted, "No active request");

        wd.status = WithdrawalStatus.Declined;
        declinedTokens[msg.sender] += wd.amount;
    }

    function getWithdrawal(address funder, address requester) external view returns (Withdrawal memory) {
        return withdrawals[funder][requester];
    }
}