// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    // hold all the waves anyone ever sends
    Wave[] waves;

    // to allow the contract to pay someone can be done by adding the keyword 'payable' to the constructor
    constructor() payable {
        console.log("We have been constructed!");
    }

    function wave(string memory _message) public {
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        // store the wave data in the array 
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // emitting the event
        emit NewWave(msg.sender, block.timestamp, _message);

        // --------PRIZE TO A SENDER-------

        // send everyone who waves a small prize in ETH from the contract itself 
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

    //retrieve the waves from website

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}