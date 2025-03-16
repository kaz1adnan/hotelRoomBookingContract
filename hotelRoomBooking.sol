// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Hotel room booking contract
contract hotelRoom {

    // Enum to represent the state of the hotel room
    enum State {
        vacant,  // Room is available for booking
        booked   // Room is already occupied
    }

    // Public variable to store the current status of the room
    State public currentStatus;

    // Event emitted when a room is successfully booked
    event occupy(address _occupant, uint _value);

    // Address of the contract owner (hotel owner) with payable capability
    address payable public owner;

    // Constructor: Sets the owner as the account deploying the contract
    // and initializes the room status to "vacant"
    constructor() {
        owner = payable(msg.sender); // Typecasting msg.sender to payable
        currentStatus = State.vacant; // Initial room status
    }

    // Modifier: Ensures the room is vacant before booking
    modifier onlyWhileVacant() {
        require(currentStatus == State.vacant, "Room is already occupied");
        _; // Continue execution of the function
    }

    // Modifier: Requires a minimum payment amount to proceed
    modifier costs(uint _amount) {
        require(msg.value >= _amount, "Not enough Ether.");
        _; // Continue execution of the function
    }

    // Function to book the hotel room
    // - Requires the room to be vacant
    // - Requires a payment of at least 2 Ether
    // - Updates the room status to "booked"
    // - Transfers the payment to the owner
    // - Emits an event for successful booking
    function book() public payable onlyWhileVacant costs(2 ether) {

        // Change the room status to "booked"
        currentStatus = State.booked;

        // Transfer the payment to the owner using call() for better gas handling
        (bool sent, ) = owner.call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        // Emit the "occupy" event with the occupant's address and payment amount
        emit occupy(msg.sender, msg.value);
    }
}
