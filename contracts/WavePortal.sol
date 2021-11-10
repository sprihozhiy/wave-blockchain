// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    // variable to help generate a random number
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    // hold all the waves anyone ever sends
    Wave[] waves;

    // store the address with the last time the user waved to prevent spam waves
    mapping(address => uint256) public lastWavedAt;

    // to allow the contract to pay someone can be done by adding the keyword 'payable' to the constructor
    constructor() payable {
        console.log("We have been constructed!");
        // set the initial random number
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {

        //to make sure the current timestamp is at least 15-minutes bigger than the last timestamp
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        // update the current timestamp we have for the user
        lastWavedAt[msg.sender] = block.timestamp;

        // add 1 wave to the current total waves state
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        // store the wave data in the array 
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // generate a new seed for the next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;

        // give a 50% chance that the user wins the prize.
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            // --------PRIZE TO A RANDOM WINNER-------
            // send the winner who waves a small prize in ETH from the contract itself 
                // establish the amount of prize
            uint256 prizeAmount = 0.0001 ether;
                // check whethere the contract has that money
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
                //if the contract has money, it sends prize to the message sender
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
                // check a transaction status (success or failed)
            require(success, "Failed to withdraw money from contract.");

        }
        // emitting the event
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    //retrieve the waves from website

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}