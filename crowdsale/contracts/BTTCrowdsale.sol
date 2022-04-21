// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./Crowdsale.sol";

contract BTTCrowdsale is Crowdsale {
    constructor(
        uint256 rate, // price of each token for each wei
        address payable wallet, //
        IERC20 token //
    ) Crowdsale(rate, wallet, token) {}
}

// Deposit into the Presalse contract

// Withdraw from the Presalse contract

// Lock Presalse

// Change Presale duration

//
