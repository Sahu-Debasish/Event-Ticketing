// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EventTicketing {
    address public owner;
    uint256 public ticketPrice;
    uint256 public totalTickets;
    uint256 public ticketsSold;

    // Mapping to keep track of which addresses hold tickets
    mapping(address => uint256) public ticketsOwned;

    event TicketPurchased(address indexed buyer, uint256 numTickets);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor(uint256 _ticketPrice, uint256 _totalTickets) {
        owner = msg.sender;
        ticketPrice = _ticketPrice;
        totalTickets = _totalTickets;
        ticketsSold = 0;
    }

    // Function to allow users to purchase tickets
    function purchaseTickets(uint256 numTickets) external payable {
        require(numTickets > 0, "Must purchase at least one ticket");
        require(msg.value == ticketPrice * numTickets, "Incorrect payment amount");
        require(ticketsSold + numTickets <= totalTickets, "Not enough tickets available");

        ticketsOwned[msg.sender] += numTickets;
        ticketsSold += numTickets;
        emit TicketPurchased(msg.sender, numTickets);
    }

    // Function to allow the owner to withdraw funds
    function withdrawFunds() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
