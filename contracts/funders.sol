// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./proposals.sol";

abstract contract DapaFunders is DapaProposals {
    mapping(address => uint256) public mintedByFunder;
    address[] public funders;

    function mintFromProposal(uint256 amount) external {
        Proposal storage proposal = proposals[msg.sender];
        require(proposal.exists, "No proposal submitted");
        require(proposal.status == ProposalStatus.Working, "Proposal not approved");
        require(mintedByFunder[msg.sender] + amount <= proposal.maxMintAmount, "Exceeds max allowed");

        if (mintedByFunder[msg.sender] == 0) {
            funders.push(msg.sender);
        }

        mintedByFunder[msg.sender] += amount;
        _mint(msg.sender, amount);
    }

    function getFunders() external view returns (address[] memory) {
        return funders;
    }
}