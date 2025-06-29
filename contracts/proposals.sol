// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract DapaProposals is ERC20 {

// A contribution proposal from a funder that'll let mint tokens 
// when approved by holders.
    struct Proposal {
        string name;
        string text;
        uint256 maxMintAmount;
        address proposer;
        uint256 yesVotes;
        uint256 noVotes;
        ProposalStatus status;
        bool exists;
    }

    enum ProposalStatus { Submitted, Working }
    enum Decision { None, Yes, No }

    mapping(address => Proposal) public proposals;
    address[] public proposers;

// So we can quickly check which decision a holder took on a proposal.
    mapping(address => mapping(address => Decision)) public voterDecisions;

// A funder can submit a contribution proposal to mint tokens after approval.
    function submitProposal(string calldata name, string calldata text, uint256 maxMintAmount) external {
        require(!proposals[msg.sender].exists, "Proposal already submitted");

        Proposal storage newProposal = proposals[msg.sender];
        newProposal.name = name;
        newProposal.text = text;
        newProposal.maxMintAmount = maxMintAmount;
        newProposal.proposer = msg.sender;
        newProposal.status = ProposalStatus.Submitted;
        newProposal.exists = true;

        proposers.push(msg.sender);
    }

// All holders can vote for a proposal.
    function vote(address proposer, Decision decision) external {
        Proposal storage proposal = proposals[proposer];
        require(proposal.exists, "Proposal not found");
        require(proposal.status == ProposalStatus.Submitted, "Proposal is not open for voting");
        require(voterDecisions[msg.sender][proposer] == Decision.None, "Already voted");

        uint256 voterWeight = balanceOf(msg.sender);
        require(voterWeight > 0, "No voting power");

        if (decision == Decision.Yes) {
            proposal.yesVotes += voterWeight;
        } else if (decision == Decision.No) {
            proposal.noVotes += voterWeight;
        }

        voterDecisions[msg.sender][proposer] = decision;

        if (proposal.yesVotes > totalSupply() / 2) {
            proposal.status = ProposalStatus.Working;
        }
    }

    function getProposal(address proposer)
        external
        view
        returns (
            string memory name,
            uint256 maxMintAmount,
            address owner,
            uint256 yesVotes,
            uint256 noVotes,
            ProposalStatus status
        )
    {
        Proposal storage p = proposals[proposer];
        require(p.exists, "Proposal not found");
        return (p.name, p.maxMintAmount, p.proposer, p.yesVotes, p.noVotes, p.status);
    }

    function hasVoted(address proposer, address voter) external view returns (Decision) {
        return voterDecisions[voter][proposer];
    }

    function getAllProposers() external view returns (address[] memory) {
        return proposers;
    }
}