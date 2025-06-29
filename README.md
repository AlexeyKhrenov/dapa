How it works?
It's an ERC20 token. It's named "Dapa". Just some random word.
Every funder can participate who's trusted by a community. The funder can be a bank or a person or any agent basically trusted by a community. API and JavaScript function of a proposer should also be trusted by a community. For this - a committment proposal should be created on the smart contract of the token. A single proposal for a current address is allowed.

Pros of this token:
Funders don't need to have crypto collaterals.
Funders don't need to have Chainlink nodes or deploy their contracts.

This token can't go to PROD as it has some flaws to be mitigated

Project structure:
./fundermock - a test API to be called by Chainlink Functions to get the reserves available. Run it with "node app.js". Change the amount of funds reserved by "curl -X POST http://localhost:3000/reserve -H "Content-Type: application/json" -d '{"amount": 1000000}'"

Contracts inheritance
token -> withdrawals -> funders -> proposals

Ratio between fiat and the token is 1-100 for simplicity.

Current problems:
There's no penalty or reputation mechanisms for funders that refused to convert the token to fiat.
Funders can be knocked-out by a massive exchange requests.
Voting mechanism - we can create new addresses, double-vote using the tokens that were already used for voting. The workaround for this should be fairly simple.
Funder reputation mechanism is not implemented. If there're more tokens on a funder address than reserves - then funder should mitigate this gap. if a funder constantly refuses to fullfil withdrawal requests - the should also be a reputation penalty or a vote-off.

TODOs:
[ ] Withdrawal requests should have a timeout after which they automatically become declined. Use Chainlink Automation for it.
[ ] Add CCIP to make it cross-chain
[ ] Cap max proposal to a max share of the supply
[ ] Find a way to track function code on the blockchain
[ ] Implement API for the funders for automatic withdrawal
[ ] Make approvement requirement proportional to max in approvement request
[ ] Mechanism for mitigation of a double usage of reserves
[ ] Mechanism for commission distribution between funders
[ ] Optimize proposal voting - on voting just submit a vote, don't change status of a contribution proposal.
[ ] Extract constants from contracts.
[ ] Research https://docs.openzeppelin.com/contracts/4.x/governance
[ ] Mechanism for a funder to change a proposal.
